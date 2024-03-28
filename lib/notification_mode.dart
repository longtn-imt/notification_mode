import 'notification_mode_platform_interface.dart';

class NotificationMode {
  Future<bool?> isDeviceMuted() {
    return NotificationModePlatform.instance.isDeviceMuted();
  }

  Stream<bool> get stream => NotificationModePlatform.instance.stream;
}
