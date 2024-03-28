package com.longtn.notification_mode

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NotificationModePlugin */
class NotificationModePlugin : FlutterPlugin, MethodCallHandler, BroadcastReceiver(), EventChannel.StreamHandler {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private lateinit var _context: Context
    private lateinit var _audioManager: AudioManager
    private var _sink: EventChannel.EventSink? = null

    /// This FlutterPlugin has been associated with a FlutterEngine instance.
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        _context = flutterPluginBinding.applicationContext
        _audioManager = _context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        _context.registerReceiver(this, IntentFilter(AudioManager.RINGER_MODE_CHANGED_ACTION))

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "notification_mode_method")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "notification_mode_event")
        eventChannel.setStreamHandler(this)
    }

    /// This FlutterPlugin has been removed from a FlutterEngine instance.
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isDeviceMuted") {
            result.success(isDeviceMuted(_context))
        } else {
            result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        _sink = events
    }

    override fun onCancel(arguments: Any?) {
        _sink = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == AudioManager.RINGER_MODE_CHANGED_ACTION) {
            val isMuted = _audioManager.ringerMode == AudioManager.RINGER_MODE_SILENT
            this._sink?.success(isMuted)
        }
    }

    private fun isDeviceMuted(context: Context): Boolean {
        return _audioManager.ringerMode == AudioManager.RINGER_MODE_SILENT
    }
}