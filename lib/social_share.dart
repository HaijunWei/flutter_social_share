import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class SocialShareConfig {
  SocialShareConfig({
    required this.ios,
    required this.android,
  });

  final SocialShareInitOption ios;
  final SocialShareInitOption android;
}

class SocialShareInitOption {
  SocialShareInitOption({
    required this.appKey,
    this.sinaWeiboAppKey,
    this.sinaWeiboAppSecret,
    this.sinaRedirectUri,
    this.qqAppId,
    this.qqAppKey,
    this.weChatAppId,
    this.weChatAppSecret,
    required this.universalLink,
  });

  final String appKey;
  final String? sinaWeiboAppKey;
  final String? sinaWeiboAppSecret;
  final String? sinaRedirectUri;
  final String? qqAppId;
  final String? qqAppKey;
  final String? weChatAppId;
  final String? weChatAppSecret;
  final String universalLink;

  Map<String, dynamic> toMap() {
    return {
      'appKey': appKey,
      'sinaWeiboAppKey': sinaWeiboAppKey,
      'sinaWeiboAppSecret': sinaWeiboAppSecret,
      'sinaRedirectUri': sinaRedirectUri,
      'qqAppId': qqAppId,
      'qqAppKey': qqAppKey,
      'weChatAppId': weChatAppId,
      'weChatAppSecret': weChatAppSecret,
      'universalLink': universalLink,
    };
  }

  factory SocialShareInitOption.fromMap(Map<String, dynamic> map) {
    return SocialShareInitOption(
      appKey: map['appKey'],
      sinaWeiboAppKey: map['sinaWeiboAppKey'],
      sinaWeiboAppSecret: map['sinaWeiboAppSecret'],
      sinaRedirectUri: map['sinaRedirectUri'],
      qqAppId: map['qqAppId'],
      qqAppKey: map['qqAppKey'],
      weChatAppId: map['weChatAppId'],
      weChatAppSecret: map['weChatAppSecret'],
      universalLink: map['universalLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialShareInitOption.fromJson(String source) =>
      SocialShareInitOption.fromMap(json.decode(source));
}

class ShareMessage {
  ShareMessage({
    required this.mediaType,
    this.url,
    this.text,
    this.title,
    required this.platform,
    this.thumb,
    this.image,
  });

  /// 类型，0 = 文本，1 = 图片，2 = 链接
  final int mediaType;

  /// 链接
  final String? url;

  /// 内容文本
  final String? text;

  /// 标题
  final String? title;

  /// 平台，1 = 微信，2 = 微信朋友圈，3 = 微信收藏，4 = QQ，5 = QQ空间，6 = Weibo，7 = WeiboContact
  final int platform;

  /// 缩略图路径
  final String? thumb;

  /// 图片路径
  final String? image;

  Map<String, dynamic> toMap() {
    return {
      'mediaType': mediaType,
      'url': url,
      'text': text,
      'title': title,
      'platform': platform,
      'thumb': thumb,
      'image': image,
    };
  }

  factory ShareMessage.fromMap(Map<String, dynamic> map) {
    return ShareMessage(
      mediaType: map['mediaType'],
      url: map['url'],
      text: map['text'],
      title: map['title'],
      platform: map['platform'],
      thumb: map['thumb'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShareMessage.fromJson(String source) =>
      ShareMessage.fromMap(json.decode(source));
}

class GetUserInfoOption {
  GetUserInfoOption({
    required this.platform,
  });

  /// 平台，0 = QQ，1 = 微信，2 = 微博
  final int platform;

  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
    };
  }

  factory GetUserInfoOption.fromMap(Map<String, dynamic> map) {
    return GetUserInfoOption(
      platform: map['platform'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUserInfoOption.fromJson(String source) =>
      GetUserInfoOption.fromMap(json.decode(source));
}

class GetUserInfoResult {
  GetUserInfoResult({
    required this.name,
    required this.iconUrl,
    required this.openId,
    this.gender,
    required this.userOriginalResponse,
  });

  /// 昵称
  final String name;

  /// 头像链接
  final String iconUrl;

  /// openId
  final String openId;

  /// 社交平台的用户性别，数值1表示男，数值2表示女。
  final int? gender;

  /// 社交平台提供的用户信息原始数据。
  final Map userOriginalResponse;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconUrl': iconUrl,
      'openId': openId,
      'gender': gender,
      'userOriginalResponse': userOriginalResponse,
    };
  }

  factory GetUserInfoResult.fromMap(Map<String, dynamic> map) {
    return GetUserInfoResult(
      name: map['name'],
      iconUrl: map['iconUrl'],
      openId: map['openId'],
      gender: map['gender'],
      userOriginalResponse: Map.from(map['userOriginalResponse']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUserInfoResult.fromJson(String source) =>
      GetUserInfoResult.fromMap(json.decode(source));
}

class CancelAuthOption {
  CancelAuthOption({
    required this.platform,
  });

  /// 平台，0 = QQ，1 = 微信，2 = 微博
  final int platform;

  Map<String, dynamic> toMap() {
    return {
      'platform': platform,
    };
  }

  factory CancelAuthOption.fromMap(Map<String, dynamic> map) {
    return CancelAuthOption(
      platform: map['platform'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelAuthOption.fromJson(String source) =>
      CancelAuthOption.fromMap(json.decode(source));
}

class SocialShare {
  SocialShare({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  Future<void> initialize(SocialShareConfig arg) async {
    SocialShareInitOption? option;
    if (Platform.isIOS) {
      option = arg.ios;
    } else if (Platform.isAndroid) {
      option = arg.android;
    } else {
      assert(true, 'Platform not supported.');
    }
    final Object encoded = option!.toMap();
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'com.haijunwei.SocialShare.initialize', const StandardMessageCodec(),
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(encoded) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    }
  }

  Future<void> share(ShareMessage arg) async {
    final Object encoded = arg.toMap();
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'com.haijunwei.SocialShare.share', const StandardMessageCodec(),
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(encoded) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    }
  }

  Future<GetUserInfoResult> getSocialUserInfo(GetUserInfoOption arg) async {
    final Object encoded = arg.toMap();
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'com.haijunwei.SocialShare.getSocialUserInfo',
        const StandardMessageCodec(),
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(encoded) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return GetUserInfoResult.fromMap(
        Map<String, dynamic>.from(replyMap['result'] as Map<dynamic, dynamic>),
      );
    }
  }

  Future<void> cancelAuth(CancelAuthOption arg) async {
    final Object encoded = arg.toMap();
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'com.haijunwei.SocialShare.cancelAuth', const StandardMessageCodec(),
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(encoded) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null,
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    }
  }
}
