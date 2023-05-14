#import "EsewaPnpPlugin.h"
#if __has_include(<esewa_pnp/esewa_pnp-Swift.h>)
#import <esewa_pnp/esewa_pnp-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "esewa_pnp-Swift.h"
#endif

@implementation EsewaPnpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEsewaPnpPlugin registerWithRegistrar:registrar];
}
@end
