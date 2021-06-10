import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_social_share/social_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    SocialShare().initialize(SocialShareConfig(
      ios: SocialShareInitOption(
        appKey: 'AppKey copied from JiGuang Portal application',
        universalLink: 'https://sv42fn.jmlk.co/ae68e02b59822c4ea458b74d/',
      ),
      android: SocialShareInitOption(
        appKey: 'AppKey copied from JiGuang Portal application',
        universalLink: 'https://sv42fn.jmlk.co/ae68e02b59822c4ea458b74d/',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
