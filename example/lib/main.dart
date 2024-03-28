import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notification_mode/notification_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationMode _notificationModePlugin = NotificationMode();
  bool? _notificationModel;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _notificationModePlugin.stream.listen(changeNotificationMode);
  }

  void changeNotificationMode(bool? notificationModel) {
    if (mounted) setState(() => _notificationModel = notificationModel);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    try {
      final bool? notificationModel = await _notificationModePlugin.isDeviceMuted();

      changeNotificationMode(notificationModel);
    } on PlatformException catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Device is muted: $_notificationModel'),
        ),
      ),
    );
  }
}
