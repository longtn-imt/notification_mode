import Flutter
import Mute
import UIKit

public class NotificationModePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "notification_mode_method", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(NotificationModePlugin(), channel: methodChannel)

        let eventChannel = FlutterEventChannel(name: "notification_mode_event", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(NotificationModeStreamHandler())
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isDeviceMuted":
            result(NotificationModeStreamHandler.isMuted)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

class NotificationModeStreamHandler: NSObject, FlutterStreamHandler {
    static var isMuted: Bool?

    private var eventSink: FlutterEventSink?

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // Always notify on interval
        Mute.shared.alwaysNotify = true

        // Update label when notification received
        Mute.shared.notify = { mute in
            if let eventSink = self.eventSink, mute != NotificationModeStreamHandler.isMuted {
                eventSink(mute)
            }

            NotificationModeStreamHandler.isMuted = mute
        }

        eventSink = events
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        // Always notify on interval
        Mute.shared.alwaysNotify = false

        eventSink = nil
        return nil
    }
}
