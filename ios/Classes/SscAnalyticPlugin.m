#import "SscAnalyticPlugin.h"
#if __has_include(<ssc_analytic/ssc_analytic-Swift.h>)
#import <ssc_analytic/ssc_analytic-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ssc_analytic-Swift.h"
#endif

@implementation SscAnalyticPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSscAnalyticPlugin registerWithRegistrar:registrar];
}
@end
