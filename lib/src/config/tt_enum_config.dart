part of analytic;

enum SdkEnvironment {
  PRODUCTION,
  SANDBOX,
}

extension SdkEnvironmentEx on SdkEnvironment {
  String toStr() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum ActivityKind {
  IMPRESSION,
  CLICK,
  INSTALL,
  SESSION,
  EVENT,
}

extension ActivityKindEx on ActivityKind {
  String toStr() {
    return this.toString().split('.').last.toLowerCase();
  }
}
