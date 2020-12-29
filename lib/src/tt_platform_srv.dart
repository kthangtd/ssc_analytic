part of analytic;

Future initPlatformSrv() async {
  await platformSrv._init();
}

_TTPlatform get platformSrv => _TTPlatform.shared();

class _TTPlatform {
  static const MethodChannel _channel = const MethodChannel('ssc_internal_analytic');
  static _TTPlatform _sInstance;

  TTPlatformInfo _info;
  TTPlatformInfo get info => _info;
  String registrationId = '';

  _TTPlatform._();
  factory _TTPlatform.shared() {
    if (_sInstance == null) {
      _sInstance = _TTPlatform._();
    }
    return _sInstance;
  }

  Future<TTPlatformInfo> get deviceInfo async {
    final rs = await _channel.invokeMapMethod('getPlatformInfo') ?? {};
    return TTPlatformInfo.from(rs);
  }

  Future _init() async {
    _info = await deviceInfo;
    final cache = await SharedPreferences.getInstance();
    if (cache.containsKey('rId')) {
      registrationId = cache.getString('rId');
    } else {
      registrationId = _TTUtils.genRandomUserId();
      cache.setString('rId', registrationId);
    }
  }
}
