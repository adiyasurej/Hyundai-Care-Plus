import 'package:flutter/services.dart';

class AndroidFeatures {
  static const MethodChannel _channel =
      MethodChannel('hyundai_care_plus/android');

  static Future<void> haptic() async {
    try {
      await _channel.invokeMethod('haptic');
    } catch (_) {}
  }

  static Future<void> lightHaptic() async {
    try {
      await _channel.invokeMethod('lightHaptic');
    } catch (_) {}
  }

  static Future<void> successHaptic() async {
    try {
      await _channel.invokeMethod('successHaptic');
    } catch (_) {}
  }

  static Future<void> openNotificationSettings() async {
    try {
      await _channel.invokeMethod(
        'openNotificationSettings',
      );
    } catch (_) {}
  }

  static Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod(
        'openAppSettings',
      );
    } catch (_) {}
  }
}