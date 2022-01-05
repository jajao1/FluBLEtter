// ignore_for_file: file_names, unused_field

part of flubletter;

abstract class _BluetoothCharacteristic {
  static const MethodChannel _channel = MethodChannel('flubletter');

  BehaviorSubject<List<int>> dataRead = BehaviorSubject<List<int>>();

  Future<void> onCharacteristicWrite(
      {required String uuidWrite, required String data}) async {}

  Future<void> onCharacteristicRead({required String uuidRead}) async {}

  void initialize() {}

  Future<dynamic> methodCallBack(MethodCall call) async {
    switch (call.method) {
      case "new-read":
        List<int> data = call.arguments;
        dataRead.add(data);
        break;
      default:
    }
  }
}

class BluetoothCharacteristic implements _BluetoothCharacteristic {
  @override
  BehaviorSubject<List<int>> dataRead = BehaviorSubject<List<int>>();

  static const MethodChannel _channel = MethodChannel('flubletter');

  @override
  Future<void> onCharacteristicWrite(
      {required String uuidWrite, required String data}) async {
    try {
      await _channel
          .invokeMethod('write', {"uuidWrite": uuidWrite, "data": data});
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> onCharacteristicRead({required String uuidRead}) async {
    try {
      await _channel.invokeMethod('read', {"uuidRead": uuidRead});
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initialize() {
    _channel.setMethodCallHandler((methodCallBack));
  }

  @override
  Future<dynamic> methodCallBack(MethodCall call) async {
    switch (call.method) {
      case "new-read":
        List<int> data = call.arguments;
        dataRead.add(data);
        break;
      default:
    }
  }
}
