// ignore_for_file: file_names, unused_field

part of flubletter;

abstract class _Scanner {
  static const MethodChannel _channel = MethodChannel('flubletter');

  BehaviorSubject<DeviceScan> scanResult = BehaviorSubject<DeviceScan>();

  Future<void> scanDevices(
      {required List<int> withServices,
      ScanMode scanMode = ScanMode.balanced}) async {}

  void initialize() {}
  Future<dynamic> methodCallBack(MethodCall call) async {}
}

class Scanner implements _Scanner {
  @override
  BehaviorSubject<DeviceScan> scanResult = BehaviorSubject<DeviceScan>();

  static const MethodChannel _channel = MethodChannel('flubletter');

  @override
  Future<void> scanDevices(
      {required List<int> withServices,
      ScanMode scanMode = ScanMode.balanced}) async {
    try {
      await _channel.invokeMethod('scan-bt');
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
      case "new-scanned":
        List<dynamic> list = call.arguments;
        String macJ = list[0];
        String namej = list[1];
        num rssij = list[2];
        scanResult.add(DeviceScan(mac: macJ, name: namej, rssi: rssij));
        break;
    }
  }
}
