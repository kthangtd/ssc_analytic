part of analytic;

_AnalyticSrv get analyticSrv => _AnalyticSrv.shared();

Future initAnalyticSrv({@required TTConfigInfo cfg}) async {
  assert(cfg != null);
  await initPlatformSrv();
  await initDBSrv(cfg: cfg);
  await _AnalyticSrv.init(cfg: cfg);
}

class _AnalyticSrv {
  static _AnalyticSrv _sInstance;
  static Isolate _thread;
  static bool _isStop = false;
  static bool _isPause = false;
  ReceivePort _receivePort;
  Queue _msgQueue;
  TTConfigInfo _cfg;
  int _lastSyncToSrvTime = 0;
  int _lastRetryTime = 0;

  _AnalyticSrv._() {
    _msgQueue = Queue();
  }

  factory _AnalyticSrv.shared() {
    if (_sInstance == null) {
      _sInstance = _AnalyticSrv._();
    }
    return _sInstance;
  }

  static Future init({@required TTConfigInfo cfg}) async {
    await analyticSrv._init(cfg: cfg);
  }

  Future _init({@required TTConfigInfo cfg}) async {
    _cfg = cfg;
    stop();
    _AnalyticSrv._isStop = false;
    _AnalyticSrv._isPause = false;
    _receivePort = ReceivePort('analytic');
    _thread = await Isolate.spawn(_AnalyticSrv._looper, _receivePort.sendPort, debugName: 'analytic');
    _receivePort.listen(_onDispatcher);
  }

  static void _looper(SendPort sender) {
    int counter = 0;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_isStop) {
        print('analytic::stop');
        timer.cancel();
        return;
      }
      if (_isPause) {
        print('analytic::pause');
        return;
      }
      counter += 1;
      sender.send(counter);
    });
  }

  ///----------------------------------------------------------
  /// DISPATCH
  ///----------------------------------------------------------

  void _onDispatcher(dynamic tick) async {
    await _onDispatchPushMessage();
    await _onDispatchRetry(tick);
    await _onDispatchSyncToSrv(tick);
  }

  Future _onDispatchPushMessage() async {
    if (_msgQueue.isEmpty) {
      return;
    }
    print('_onDispatchPushMessage - ${_msgQueue.length}');
    while (_msgQueue.isNotEmpty) {
      await dbSrv.addMsgToQueue(msg: _msgQueue.removeFirst());
    }
  }

  Future _onDispatchRetry(int tick) async {
    final int sec = tick ~/ 5;
    if (_lastRetryTime + _cfg.retryInterval > sec) {
      return;
    }
    _lastRetryTime += _cfg.retryInterval;
    print('_onDispatchRetry - $_lastRetryTime');
    await dbSrv.putBackRetryToMsgQueue();
  }

  Future _onDispatchSyncToSrv(int tick) async {
    final int sec = tick ~/ 5;
    if (_lastSyncToSrvTime + _cfg.syncServerInterval > sec) {
      return;
    }
    _lastSyncToSrvTime += _cfg.syncServerInterval;
    print('_onDispatchSyncToSrv - $_lastSyncToSrvTime');
    final List<TTMsgInfo> msgs = await dbSrv.enqueue();
    if (msgs.isEmpty) {
      return;
    }
    final headers = {};
    headers.addAll(_cfg.headers);
    if (_cfg.userAgent != null && _cfg.userAgent.isNotEmpty) {
      headers['User-Agent'] = _cfg.userAgent;
    }
    await networkSrv.sendPOST(
      _cfg.serverEndpointURL,
      events: msgs.map((e) => e.data).toList(),
      onSending: (reqId) async {
        await dbSrv.pushToProcessingQueue(msgIds: msgs, reqId: reqId);
      },
      onDone: (reqId, isSuccess, _, rsp) async {
        if (isSuccess || (rsp.statusCode < 304 && rsp.statusCode > 0)) {
          print('sendPOST - Success');
          await dbSrv.deleteMsgs(msgs: msgs);
        } else {
          print('sendPOST - Fail');
          await dbSrv.backupToRetryQueue(reqId: reqId);
        }
      },
    );
  }

  ///----------------------------------------------------------
  /// PUBLIC
  ///----------------------------------------------------------

  void stop() {
    _AnalyticSrv._isStop = true;
    if (_thread != null) {
      _thread.kill(priority: Isolate.immediate);
      _thread = null;
    }
  }

  void pause() {
    _AnalyticSrv._isPause = true;
    if (_thread != null) {
      _thread.pause(_thread.pauseCapability);
    }
  }

  void resume() {
    if (_thread != null) {
      _thread.resume(_thread.pauseCapability);
    }
    _AnalyticSrv._isPause = false;
  }

  void push({Map parameters = const {}}) {
    assert(parameters != null);
    _msgQueue.add(jsonEncode(parameters));
  }
}
