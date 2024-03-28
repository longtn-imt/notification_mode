import Flutter
import UIKit
import AVFoundation

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
            result(self.isDeviceMuted())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func isDeviceMuted() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            let isMuted = session.outputVolume == 0.0
            return isMuted
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
            return false
        }
    }
}

class NotificationModeStreamHandler: NSObject, FlutterStreamHandler {
    private var _eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionRouteChange(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        _eventSink = nil
        return nil
    }
    
    @objc func audioSessionRouteChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .categoryChange:
            let audioSession = AVAudioSession.sharedInstance()
            let isMuted = audioSession.category == .ambient || audioSession.category == .soloAmbient
            if let _eventSink = self._eventSink {
                _eventSink(isMuted)
            }
        default:
            break
        }
    }
}
