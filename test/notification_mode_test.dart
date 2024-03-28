import 'package:flutter_test/flutter_test.dart';
import 'package:notification_mode/notification_mode.dart';
import 'package:notification_mode/notification_mode_platform_interface.dart';
import 'package:notification_mode/notification_mode_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNotificationModePlatform with MockPlatformInterfaceMixin implements NotificationModePlatform {
  @override
  Future<bool?> isDeviceMuted() => Future.value(true);

  @override
  Stream<bool> get stream => throw UnimplementedError();
}

void main() {
  final NotificationModePlatform initialPlatform = NotificationModePlatform.instance;

  test('$MethodChannelNotificationMode is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNotificationMode>());
  });

  test('isDeviceMuted', () async {
    NotificationMode notificationModePlugin = NotificationMode();
    MockNotificationModePlatform fakePlatform = MockNotificationModePlatform();
    NotificationModePlatform.instance = fakePlatform;

    expect(await notificationModePlugin.isDeviceMuted(), true);
  });
}
