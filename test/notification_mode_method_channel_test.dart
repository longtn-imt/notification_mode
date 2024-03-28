import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notification_mode/notification_mode_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNotificationMode platform = MethodChannelNotificationMode();
  const MethodChannel channel = MethodChannel('notification_mode');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('isDeviceMuted', () async {
    expect(await platform.isDeviceMuted(), true);
  });
}
