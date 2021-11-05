// ignore_for_file: file_names, avoid_print

import 'package:flubletter/src/BluetoothScan/ScanMode.dart';
import 'package:flubletter/src/UniqueUid/UniqueUid.dart';
import 'package:flutter/services.dart';

class Repository {
  static const MethodChannel _channel = MethodChannel('flubletter');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> get isOn async {
    try {
      bool btisOn = await _channel.invokeMethod('bt-ison');
      return btisOn;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> get enableBT async {
    try {
      await _channel.invokeMethod('enable-bt');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> get disbaleBT async {
    try {
      await _channel.invokeMethod('disbale-bt');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> scanDevices(
      {required List<UniqueUID> withServices,
      ScanMode scanMode = ScanMode.balanced}) async {
    try {
      await _channel.invokeMethod('scan-bt');
    } on PlatformException catch (e) {
      throw Exception('Could not start the scan.');
    }
  }

  Future<void> connectDevice({
    required String mac,
  }) async {
    try {
      await _channel.invokeMethod('connect-Device');
    } on PlatformException catch (e) {
      throw Exception('Could not to connect.');
    }
  }
}
