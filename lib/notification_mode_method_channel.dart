import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'notification_mode_platform_interface.dart';

/// An implementation of [NotificationModePlatform] that uses method channels.
class MethodChannelNotificationMode extends NotificationModePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel = const MethodChannel('notification_mode_method');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final EventChannel eventChannel = const EventChannel('notification_mode_event');

  @override
  Future<bool?> isDeviceMuted() async {
    final version = await methodChannel.invokeMethod<bool>('isDeviceMuted');
    return version;
  }

  @override
  Stream<bool> get stream => eventChannel.receiveBroadcastStream().cast();
}
