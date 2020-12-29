part of analytic;

class TTConfigInfo {
  final int syncServerInterval;
  final int retryInterval;
  final String serverEndpointURL;
  final int batchCount;
  final List<int> retryTimeouts;
  final Map headers;
  final String userAgent;

  TTConfigInfo({
    this.syncServerInterval,
    this.retryInterval,
    this.serverEndpointURL,
    this.batchCount,
    this.userAgent = '',
    this.retryTimeouts = const [0],
    this.headers = const {},
  });

  factory TTConfigInfo.defaultCfg() {
    final userAgent = '${SSCAnalytic.sdkName}/${SSCAnalytic.sdkVersion}';
    return TTConfigInfo(
      retryInterval: 5,
      syncServerInterval: 10,
      serverEndpointURL: '',
      retryTimeouts: [0, 120, 600, 1800, 5400, 12600],
      batchCount: 50,
      headers: {'Connection': 'Keep-Alive'},
      userAgent: userAgent,
    );
  }
}
