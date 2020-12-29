part of analytic;

_NetworkSrv get networkSrv => _NetworkSrv.shared();

class _NetworkSrv {
  static _NetworkSrv _sInstance;

  _NetworkSrv._();

  factory _NetworkSrv.shared() {
    if (_sInstance == null) {
      _sInstance = _NetworkSrv._();
    }
    return _sInstance;
  }

  Future sendPOST(
    String url, {
    Map<String, dynamic> headers,
    List<Map> events,
    Future Function(int) onSending,
    Future Function(int, bool, List<Map>, http.Response) onDone,
  }) async {
    final reqId = DateTime.now().toUtc().millisecondsSinceEpoch;
    try {
      final body = {'events': events};
      if (onSending != null) {
        await onSending(reqId);
      }
      http.Response res;
      if (kReleaseMode) {
        res = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
          encoding: Encoding.getByName("utf-8"),
        );
      } else {
        res = await _NetworkDemo.post(
          url,
          headers: headers,
          body: jsonEncode(body),
          encoding: Encoding.getByName("utf-8"),
        );
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final resBody = jsonDecode(res.body ?? '{}');
        bool isSuccess = resBody['success'] == true;
        onDone?.call(reqId, isSuccess, events, res);
      } else {
        onDone?.call(reqId, false, events, res);
      }
    } catch (_) {
      onDone?.call(reqId, false, events, null);
    }
  }
}
