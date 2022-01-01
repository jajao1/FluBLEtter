part of flubletter;

class Flubletter {
  final Repository _repository = Repository();

  ///Start Scan
  Stream<DeviceScan> scanDevices(
      {required List<UniqueUID> withServices,
      ScanMode scanMode = ScanMode.balanced}) async* {
    _repository.scanDevices(withServices: withServices, scanMode: scanMode);
    yield* _repository.scanResult;
  }

  ///Connect To Device
  Stream<DeviceDiscovered> connectToDevice({required String mac}) async* {
    await _repository.connectDevice(
      mac: mac,
    );
    yield* _repository.deviceState;
  }

  Future<void> onCharacteristicWrite(
      {required String uuidWrite, required String data}) async {
    await _repository.onCharacteristicWrite(uuidWrite: uuidWrite, data: data);
  }

  Future<void> disconnect() async {
    await _repository.disconnect();
  }

  ///Checking if Bluetooth is enable
  Future<bool> get isOn async {
    return await Repository.isOn;
  }

  ///Enable Bluetooth
  Future<bool> get enable async {
    return await Repository.enableBT;
  }

  ///Disable Bluetooth
  Future<bool> get disable async {
    return await Repository.disbaleBT;
  }
}
