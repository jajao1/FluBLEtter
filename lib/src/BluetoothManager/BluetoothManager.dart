// ignore_for_file: file_names, unused_field, unused_element

part of flubletter;

abstract class _BluetoothManager {
  static const MethodChannel _channel = MethodChannel('flubletter');

  Future<void> disconnect() async {}
}

class BluetoothManager implements _BluetoothManager {
  static const MethodChannel _channel = MethodChannel('flubletter');

  static Future<bool> get isOn async {
    try {
      bool btisOn = await _channel.invokeMethod('btison');
      return btisOn;
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> get enableBT async {
    try {
      return await _channel.invokeMethod('enable-bt');
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  static Future<bool> get disbaleBT async {
    try {
      return await _channel.invokeMethod('disable-bt');
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }
}
