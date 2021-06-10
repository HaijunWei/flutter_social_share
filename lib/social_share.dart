import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

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
    this.thumbUrl,
    this.image,
  });

  /// 类型，0 = 文本，1 = 图片，3 = 链接
  final int mediaType;

  /// 链接
  final String? url;

  /// 内容文本
  final String? text;

  /// 标题
  final String? title;

  /// 平台，0 = QQ，1 = 微信，2 = 微博
  final int platform;

  /// 缩略图
  final String? thumbUrl;

  /// 图片路径
  final String? image;

  Map<String, dynamic> toMap() {
    return {
      'mediaType': mediaType,
      'url': url,
      'text': text,
      'title': title,
      'platform': platform,
      'thumbUrl': thumbUrl,
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
      thumbUrl: map['thumbUrl'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShareMessage.fromJson(String source) =>
      ShareMessage.fromMap(json.decode(source));
}

class ShareResult {
  ShareResult({
    required this.code,
    this.message,
  });

  final int code;
  final String? message;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  factory ShareResult.fromMap(Map<String, dynamic> map) {
    return ShareResult(
      code: map['code'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShareResult.fromJson(String source) =>
      ShareResult.fromMap(json.decode(source));
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
  });

  /// 昵称
  final String name;

  /// 头像链接
  final String iconUrl;

  /// openId
  final String openId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconUrl': iconUrl,
      'openId': openId,
    };
  }

  factory GetUserInfoResult.fromMap(Map<String, dynamic> map) {
    return GetUserInfoResult(
      name: map['name'],
      iconUrl: map['iconUrl'],
      openId: map['openId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUserInfoResult.fromJson(String source) =>
      GetUserInfoResult.fromMap(json.decode(source));
}

class SocialShare {
  SocialShare({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  Future<void> initialize(SocialShareInitOption arg) async {
    final Object encoded = arg.toMap();
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

  Future<ShareResult> share(ShareMessage arg) async {
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
    } else {
      return ShareResult.fromMap(
        Map<String, dynamic>.from(replyMap['result'] as Map<dynamic, dynamic>),
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
}
