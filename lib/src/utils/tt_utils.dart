part of analytic;

class _TTUtils {
  _TTUtils._();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static int genMilisecUnixTime() {
    return DateTime.now().toUtc().millisecondsSinceEpoch;
  }

  static int genUnixTime() {
    return genMilisecUnixTime() ~/ 1000;
  }

  static int genRandomNumber({int e = 9}) {
    double n = Random.secure().nextDouble();
    return (n * pow(10, e)).toInt();
  }

  static String genRandomString({int len = 9}) {
    final r = Random.secure();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  static String genRandomUserId({int len = 39}) {
    return genRandomString(len: len).toLowerCase();
  }

  static String genNounce({int len = 9}) {
    return genRandomString(len: len).toLowerCase();
  }

  static String genSessionId() {
    return Uuid().v4();
  }

  static String getDeviceType() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DeviceType.DESKTOP.toStr();
    }
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    if (data.size.shortestSide < 600) {
      return DeviceType.PHONE.toStr();
    }
    return DeviceType.TABLET.toStr();
  }

  static String getScreenResolution() {
    final ws = window.physicalSize;
    return '${ws.width}x${ws.height}';
  }
}
