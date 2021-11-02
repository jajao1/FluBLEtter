
import 'dart:async';

import 'package:flutter/services.dart';

class Flubletter {
  static const MethodChannel _channel = MethodChannel('flubletter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
