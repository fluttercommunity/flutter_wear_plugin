#import "WearPlugin.h"
#import <wear/wear-Swift.h>

@implementation WearPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWearPlugin registerWithRegistrar:registrar];
}
@end
