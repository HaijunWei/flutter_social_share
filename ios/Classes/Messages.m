//
//  Messages.m
//  flutter_social_share
//
//  Created by Haijun on 2021/6/10.
//

#import "Messages.h"
#import <Flutter/Flutter.h>

static NSDictionary<NSString*, id>* wrapResult(NSDictionary *result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ? error.code : [NSNull null]),
        @"message": (error.message ? error.message : [NSNull null]),
        @"details": (error.details ? error.details : [NSNull null]),
        };
  }
  return @{
      @"result": (result ? result : [NSNull null]),
      @"error": errorDict,
      };
}

@implementation SocialShareInitOption

- (instancetype)initWithMap:(NSDictionary *)map {
    if (self = [super init]) {
        _appKey = map[@"appKey"];
        _sinaWeiboAppKey = map[@"sinaWeiboAppKey"];
        _sinaWeiboAppSecret = map[@"sinaWeiboAppSecret"];
        _sinaRedirectUri = map[@"sinaRedirectUri"];
        _qqAppId = map[@"qqAppId"];
        _qqAppKey = map[@"qqAppKey"];
        _weChatAppId = map[@"weChatAppId"];
        _weChatAppSecret = map[@"weChatAppSecret"];
        _universalLink = map[@"universalLink"];
    }
    return self;
}

- (NSDictionary *)toMap {
    return @{
        @"appKey": self.appKey,
        @"sinaWeiboAppKey": self.sinaWeiboAppKey ?: [NSNull null],
        @"sinaWeiboAppSecret": self.sinaWeiboAppSecret ?: [NSNull null],
        @"sinaRedirectUri": self.sinaRedirectUri ?: [NSNull null],
        @"qqAppId": self.qqAppId ?: [NSNull null],
        @"qqAppKey": self.qqAppKey ?: [NSNull null],
        @"weChatAppId": self.weChatAppId ?: [NSNull null],
        @"weChatAppSecret": self.weChatAppSecret ?: [NSNull null],
        @"universalLink": self.sinaWeiboAppKey
    };
}

@end

@implementation ShareMessage

- (instancetype)initWithMap:(NSDictionary *)map {
    if (self = [super init]) {
        _mediaType = map[@"mediaType"];
        _url = map[@"url"];
        _text = map[@"text"];
        _title = map[@"title"];
        _platform = map[@"platform"];
        _thumbUrl = map[@"thumbUrl"];
        _image = map[@"image"];
    }
    return self;
}

- (NSDictionary *)toMap {
    return @{
        @"mediaType": self.mediaType,
        @"url": self.url ?: [NSNull null],
        @"text": self.text ?: [NSNull null],
        @"title": self.title ?: [NSNull null],
        @"platform": self.platform,
        @"thumbUrl": self.thumbUrl ?: [NSNull null],
        @"image": self.image ?: [NSNull null]
    };
}

@end

@implementation ShareResult

- (instancetype)initWithMap:(NSDictionary *)map {
    if (self = [super init]) {
        _code = map[@"code"];
        _message = map[@"message"];
    }
    return self;
}

- (NSDictionary *)toMap {
    return @{
        @"code": self.code,
        @"message": self.message ?: [NSNull null]
    };
}

@end

@implementation GetUserInfoOption

- (instancetype)initWithMap:(NSDictionary *)map {
    if (self = [super init]) {
        _platform = map[@"platform"];
    }
    return self;
}

- (NSDictionary *)toMap {
    return @{
        @"platform": self.platform
    };
}

@end

@implementation GetUserInfoResult

- (instancetype)initWithMap:(NSDictionary *)map {
    if (self = [super init]) {
        _name = map[@"name"];
        _iconUrl = map[@"iconUrl"];
        _openId = map[@"openId"];
    }
    return self;
}

- (NSDictionary *)toMap {
    return @{
        @"name": self.name,
        @"iconUrl": self.iconUrl,
        @"openId": self.openId,
    };
}

@end

void SocialShareSetup(id<FlutterBinaryMessenger> binaryMessenger, id<SocialShare> api) {
    {
      FlutterBasicMessageChannel *channel =
        [FlutterBasicMessageChannel
          messageChannelWithName:@"com.haijunwei.SocialShare.initialize"
          binaryMessenger:binaryMessenger];
      if (api) {
        [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
            SocialShareInitOption *input = [[SocialShareInitOption alloc] initWithMap:message];
            [api initialize:input completion:^(FlutterError * error) {
                callback(wrapResult(nil, error));
            }];
        }];
      }
      else {
        [channel setMessageHandler:nil];
      }
    }
    {
      FlutterBasicMessageChannel *channel =
        [FlutterBasicMessageChannel
          messageChannelWithName:@"com.haijunwei.SocialShare.share"
          binaryMessenger:binaryMessenger];
      if (api) {
        [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
            ShareMessage *input = [[ShareMessage alloc] initWithMap:message];
            [api share:input completion:^(ShareResult * result, FlutterError * error) {
                callback(wrapResult([result toMap], error));
            }];
        }];
      }
      else {
        [channel setMessageHandler:nil];
      }
    }
    {
        FlutterBasicMessageChannel *channel =
          [FlutterBasicMessageChannel
            messageChannelWithName:@"com.haijunwei.SocialShare.getSocialUserInfo"
            binaryMessenger:binaryMessenger];
        if (api) {
          [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
              GetUserInfoOption *input = [[GetUserInfoOption alloc] initWithMap:message];
              [api getSocialUserInfo:input completion:^(GetUserInfoResult * result, FlutterError * error) {
                  callback(wrapResult([result toMap], error));
              }];
          }];
        }
        else {
          [channel setMessageHandler:nil];
        }
      }
}