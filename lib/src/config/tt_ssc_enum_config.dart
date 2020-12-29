part of analytic;

enum DeviceType {
  /// device type is phone (iPhone, Android phone device)
  PHONE,

  /// device type is tablet (iPad, Android tablet device)
  TABLET,

  /// device type is desktop (Desktop monitor)
  DESKTOP,
}

extension DeviceTypeEx on DeviceType {
  String toStr() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum LoginMode {
  /// User login with offline settings
  OFFLINE,

  /// User login with online settings
  ONLINE,
}

extension LoginModeEx on LoginMode {
  String toStr() {
    return this.toString().split('.').last.toLowerCase();
  }
}

enum SSCEvent {
  /// When KSP pop-up is displayed
  KspHit,

  /// When the search action for KSPs is requested
  KspSearchHit,

  /// When the search action for KSPs is completed
  KspSearchResultHit,

  /// When the model and/or the trim has been selected/changed
  ConfigurationHit,

  /// When the "Quotation" pop-up is displayed
  QuotationHit,

  /// When the "My Sales" menu item is activated
  MySalesHit,

  /// When enter-room button is clicked.
  VideoChatHit,
}

extension SSCEventEx on SSCEvent {
  String toStr() {
    return this.toString().split('.').last;
  }
}
