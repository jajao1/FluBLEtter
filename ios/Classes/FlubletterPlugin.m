#import "FlubletterPlugin.h"
#if __has_include(<flubletter/flubletter-Swift.h>)
#import <flubletter/flubletter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flubletter-Swift.h"
#endif

@implementation FlubletterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlubletterPlugin registerWithRegistrar:registrar];
}
@end
