part of analytic;

class TTPlatformInfo {
  final String appName;
  final String appVersion;
  final String appBuild;
  final String appPackageName;
  final String osName;
  final String osVersion;

  TTPlatformInfo({
    this.appName,
    this.appVersion,
    this.appBuild,
    this.appPackageName,
    this.osName,
    this.osVersion,
  });

  factory TTPlatformInfo.from(Map e) {
    return TTPlatformInfo(
      appPackageName: e['pkg_name'] ?? '',
      appName: e['app_name'] ?? '',
      appVersion: e['app_version'] ?? '',
      appBuild: e['app_build'] ?? '',
      osName: e['os_name'] ?? '',
      osVersion: e['os_version'] ?? '',
    );
  }
}
