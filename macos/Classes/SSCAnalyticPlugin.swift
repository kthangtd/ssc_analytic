import Cocoa
import FlutterMacOS

public class SscAnalyticPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ssc_internal_analytic", binaryMessenger: registrar.messenger)
    let instance = SscAnalyticPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getPlatformInfo":
        getPlatformInfo(result)
        break
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getPlatformInfo(_ result: @escaping FlutterResult) {
    var rs = [String: Any]()
    rs["pkg_name"] = Bundle.main.bundleIdentifier
    rs["app_name"] = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    rs["app_version"] = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    rs["app_build"] = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    rs["os_name"] = "Mac OS"
    rs["os_version"] = ProcessInfo.processInfo.operatingSystemVersionString
    result(rs)
  }
}
