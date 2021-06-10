#import "FlutterSocialSharePlugin.h"
#import "Messages.h"
#import "JSHAREService.h"

@interface FlutterSocialSharePlugin () <SocialShare>

@end

@implementation FlutterSocialSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterSocialSharePlugin *plugin = [FlutterSocialSharePlugin new];
    SocialShareSetup([registrar messenger], plugin);
    [registrar publish:plugin];
    [registrar addApplicationDelegate:plugin];
}

- (void)initialize:(nonnull SocialShareInitOption *)input completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = input.appKey;
    config.SinaWeiboAppKey = input.sinaWeiboAppKey;
    config.SinaWeiboAppSecret = input.sinaWeiboAppSecret;
    config.SinaRedirectUri = input.sinaRedirectUri;
    config.QQAppId = input.qqAppId;
    config.QQAppKey = input.qqAppKey;
    config.WeChatAppId = input.weChatAppId;
    config.WeChatAppSecret = input.weChatAppSecret;
    config.universalLink = input.universalLink;
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:YES];
    completion(nil);
}

- (void)share:(nonnull ShareMessage *)input completion:(nonnull void (^)(FlutterError * _Nullable))completion {
    JSHAREMessage *message = [JSHAREMessage new];
    message.platform = input.platform.intValue;
    message.title = input.title;
    if (input.thumb != nil) {
        message.thumbnail = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:input.thumb]];
    }
    if (input.mediaType.intValue == 0) {
        message.mediaType = JSHAREText;
        message.text = input.text;
    } else if (input.mediaType.intValue == 1) {
        message.mediaType = JSHAREImage;
        message.image = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:input.image]];
    } else if (input.mediaType.intValue == 2) {
        message.mediaType = JSHARELink;
        message.url = input.url;
    }
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        if (error != nil) {
            completion([FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.localizedDescription details:nil]);
        } else {
            completion(nil);
        }
    }];
}

- (void)getSocialUserInfo:(nonnull GetUserInfoOption *)input completion:(nonnull void (^)(GetUserInfoResult * _Nullable, FlutterError * _Nullable))completion {
    JSHAREPlatform platform;
    if (input.platform.intValue == 0) {
        platform = JSHAREPlatformQQ;
    } else if (input.platform.intValue == 1) {
        platform = JSHAREPlatformWechatSession;
    } else {
        platform = JSHAREPlatformSinaWeibo;
    }
    [JSHAREService getSocialUserInfo:platform handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        if (error != nil) {
            completion(nil, [FlutterError errorWithCode:[NSString stringWithFormat:@"%ld", error.code] message:error.localizedDescription details:nil]);
        } else {
            GetUserInfoResult *result = [GetUserInfoResult new];
            result.name = userInfo.name;
            result.iconUrl = userInfo.iconurl;
            result.openId = userInfo.openid;
            completion(result, nil);
        }
    }];
}

- (void)cancelAuth:(CancelAuthOption *)input completion:(void (^)(FlutterError * _Nullable))completion {
    JSHAREPlatform platform;
    if (input.platform.intValue == 0) {
        platform = JSHAREPlatformQQ;
    } else if (input.platform.intValue == 1) {
        platform = JSHAREPlatformWechatSession;
    } else {
        platform = JSHAREPlatformSinaWeibo;
    }
    [JSHAREService cancelAuthWithPlatform:platform];
    completion(nil);
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [JSHAREService handleOpenUrl:url];
}

@end
