part of flubletter;

class Flubletter {
  final BluetoothCharacteristic _bluetoothCharacteristic =
      BluetoothCharacteristic();

  final BluetoothManager _bluetoothManager = BluetoothManager();

  final Connection _connection = Connection();

  final Scanner _scanner = Scanner();

  ///Start Scan
  Stream<DeviceScan> scanDevices(
      {required List<int> withServices,
      ScanMode scanMode = ScanMode.balanced}) async* {
    _scanner.scanDevices(withServices: withServices, scanMode: scanMode);
    yield* _scanner.scanResult.stream;
  }

  ///Connect To Device
  Stream<DeviceDiscovered> connectToDevice({required String mac}) async* {
    await _connection.connectDevice(
      mac: mac,
    );
    yield* _connection.deviceState.stream;
  }

  Future<void> onCharacteristicWrite(
      {required String uuidWrite, required String data}) async {
    await _bluetoothCharacteristic.onCharacteristicWrite(
        uuidWrite: uuidWrite, data: data);
  }

  Stream<List<int>> onCharacteristicRead({required String uuidRead}) async* {
    await _bluetoothCharacteristic.onCharacteristicRead(
      uuidRead: uuidRead,
    );
    yield* _bluetoothCharacteristic.dataRead.stream;
  }

  Future<void> disconnect() async {
    await _bluetoothManager.disconnect();
  }

  ///Checking if Bluetooth is enable
  Future<bool> get isOn async {
    return await BluetoothManager.isOn;
  }

  ///Enable Bluetooth
  Future<bool> get enable async {
    return await BluetoothManager.enableBT;
  }

  ///Disable Bluetooth
  Future<bool> get disable async {
    return await BluetoothManager.disbaleBT;
  }
}
