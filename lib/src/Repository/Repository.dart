// ignore_for_file: file_names, avoid_print

part of flubletter;

class Repository {
  static const MethodChannel _channel = MethodChannel('flubletter');

  DeviceScan? deviceScan;

  bool flagnewdevice = false;

  final Scanner _scanner = Scanner();

  final Connection _connection = Connection();

  BehaviorSubject<List<int>> dataRead = BehaviorSubject<List<int>>();

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
      {required List<UUID> withServices,
      ScanMode scanMode = ScanMode.balanced}) async {
    try {
      initialize();
      await _channel.invokeMethod('scan-bt');
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> connectDevice({
    required String mac,
  }) async {
    try {
      await _channel.invokeMethod('connect-device', {"mac": mac});
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> onCharacteristicRead({required String uuidRead}) async {
    try {
      await _channel.invokeMethod('read', {"uuidRead": uuidRead});
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> onCharacteristicWrite(
      {required String uuidWrite, required String data}) async {
    try {
      await _channel
          .invokeMethod('write', {"uuidWrite": uuidWrite, "data": data});
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      throw Exception(e);
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
      case "new-state":
        num state = call.arguments;
        _connection.deviceState.add(DeviceDiscovered.deviceDiscovered(state));
        break;
      case "new-read":
        List<int> data = call.arguments;
        dataRead.add(data);
        break;
      default:
    }
  }

  Stream<DeviceScan> get scanResult async* {
    yield* _scanner.scanResult.stream;
  }

  Stream<DeviceDiscovered> get deviceState async* {
    yield* _connection.deviceState.stream;
  }

  Stream<List<int>> get dataReadStream async* {
    yield* dataRead.stream;
  }
}
