import 'dart:async';

import 'package:flutter/services.dart';

class Flubletter {
  static const MethodChannel _channel = MethodChannel('flubletter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> get enableBt async {
    bool BTisOn = await _channel.invokeMethod('bt-ison');
    return BTisOn;
  }

  Future<void> get enableBT async {
    await _channel.invokeMethod('enable-bt');
  }

  Future<void> get disbaleBT async {
    await _channel.invokeMethod('disbale-bt');
  }

  Future<void> get scanDevices async {
    await _channel.invokeMethod('scan-bt');
  }
}
