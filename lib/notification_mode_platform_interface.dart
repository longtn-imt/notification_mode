import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'notification_mode_method_channel.dart';

abstract class NotificationModePlatform extends PlatformInterface {
  /// Constructs a NotificationModePlatform.
  NotificationModePlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationModePlatform _instance = MethodChannelNotificationMode();

  /// The default instance of [NotificationModePlatform] to use.
  ///
  /// Defaults to [MethodChannelNotificationMode].
  static NotificationModePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NotificationModePlatform] when
  /// they register themselves.
  static set instance(NotificationModePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isDeviceMuted();

  Stream<bool> get stream;
}
