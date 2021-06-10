//
//  Messages.h
//  flutter_social_share
//
//  Created by Haijun on 2021/6/10.
//

#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@interface SocialShareInitOption : NSObject

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy, nullable) NSString *sinaWeiboAppKey;
@property (nonatomic, copy, nullable) NSString *sinaWeiboAppSecret;
@property (nonatomic, copy, nullable) NSString *sinaRedirectUri;
@property (nonatomic, copy, nullable) NSString *qqAppId;
@property (nonatomic, copy, nullable) NSString *qqAppKey;
@property (nonatomic, copy, nullable) NSString *weChatAppId;
@property (nonatomic, copy, nullable) NSString *weChatAppSecret;
@property (nonatomic, copy) NSString *universalLink;

- (instancetype)initWithMap:(NSDictionary *)map;
- (NSDictionary *)toMap;

@end

@interface ShareMessage : NSObject

@property (nonatomic, strong) NSNumber *mediaType;
@property (nonatomic, copy, nullable) NSString *url;
@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, strong) NSNumber *platform;
@property (nonatomic, copy, nullable) NSString *thumbUrl;
@property (nonatomic, copy, nullable) NSString *image;

- (instancetype)initWithMap:(NSDictionary *)map;
- (NSDictionary *)toMap;

@end

@interface ShareResult : NSObject

@property (nonatomic, strong) NSNumber *code;
@property (nonatomic, copy, nullable) NSString *message;

- (instancetype)initWithMap:(NSDictionary *)map;
- (NSDictionary *)toMap;

@end

@interface GetUserInfoOption : NSObject

@property (nonatomic, strong) NSNumber *platform;

- (instancetype)initWithMap:(NSDictionary *)map;
- (NSDictionary *)toMap;

@end

@interface GetUserInfoResult : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *openId;

- (instancetype)initWithMap:(NSDictionary *)map;
- (NSDictionary *)toMap;

@end


@protocol SocialShare <NSObject>

- (void)initialize:(SocialShareInitOption *)input completion:(void(^)(FlutterError *_Nullable))completion;
- (void)share:(ShareMessage *)input completion:(void(^)(ShareResult *_Nullable, FlutterError *_Nullable))completion;
- (void)getSocialUserInfo:(GetUserInfoOption *)input completion:(void(^)(GetUserInfoResult *_Nullable, FlutterError *_Nullable))completion;

@end

extern void SocialShareSetup(id<FlutterBinaryMessenger> binaryMessenger, id<SocialShare> _Nullable api);

NS_ASSUME_NONNULL_END
