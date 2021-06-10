#import "FlutterSocialSharePlugin.h"
#import "Messages.h"

@interface FlutterSocialSharePlugin () <SocialShare>

@end

@implementation FlutterSocialSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterSocialSharePlugin *plugin = [FlutterSocialSharePlugin new];
    SocialShareSetup([registrar messenger], plugin);
    [registrar publish:plugin];
}
@end
