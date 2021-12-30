// ignore_for_file: file_names, avoid_print

part of flubletter;

class Repository {
  static const MethodChannel _channel = MethodChannel('flubletter');

  DeviceScan? deviceScan;

  bool flagnewdevice = false;

  final Scanner _scanner = Scanner();

  static Future<String?> get platfocrmVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> get isOn async {
    try {
      bool btisOn = await _channel.invokeMethod('btison');
      return btisOn;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  void initialize() {
    _channel.setMethodCallHandler((methodCallBack));
  }

  static Future<bool> get enableBT async {
    try {
      return await _channel.invokeMethod('enable-bt');
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> get disbaleBT async {
    try {
      return await _channel.invokeMethod('disable-bt');
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> scanDevices(
      {required List<UniqueUID> withServices,
      ScanMode scanMode = ScanMode.balanced}) async {
    try {
      initialize();
      await _channel.invokeMethod('scan-bt');
    } on PlatformException catch (e) {
      throw Exception('Could not start the scan.');
    }
  }

  Future<void> connectDevice({
    required String mac,
  }) async {
    try {
      await _channel.invokeMethod('connect-device', {"mac": mac});
    } on PlatformException catch (e) {
      throw Exception('Could not to connect.');
    }
  }

  Future<dynamic> methodCallBack(MethodCall call) async {
    switch (call.method) {
      case "new-scanned":
        List<dynamic> list = call.arguments;
        String macJ = list[0];
        String namej = list[1];
        num rssij = list[2];
        _scanner.newDevice(DeviceScan(mac: macJ, name: namej, rssi: rssij));
        break;
      default:
    }
  }

  Stream<DeviceScan> get scanResult async* {
    yield* _scanner.scanResult.stream;
  }
}
