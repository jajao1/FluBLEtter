// ignore_for_file: file_names, unused_field

part of flubletter;

abstract class _Connection {
  BehaviorSubject<DeviceDiscovered> deviceState =
      BehaviorSubject<DeviceDiscovered>();

  static const MethodChannel _channel = MethodChannel('flubletter');

  Future<void> connectDevice({
    required String mac,
  }) async {}

  void initialize() {}

  Future<dynamic> methodCallBack(MethodCall call) async {}
}

class Connection implements _Connection {
  @override
  BehaviorSubject<DeviceDiscovered> deviceState =
      BehaviorSubject<DeviceDiscovered>();

  static const MethodChannel _channel = MethodChannel('flubletter');

  @override
  Future<void> connectDevice({
    required String mac,
  }) async {
    try {
      await _channel.invokeMethod('connect-device', {"mac": mac});
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
      case "new-state":
        num state = call.arguments;
        deviceState.add(DeviceDiscovered.deviceDiscovered(state));
        break;
    }
  }
}
