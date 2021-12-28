part of flubletter;

class Flubletter {
  ///Start Scan
  Stream<DeviceScan> scanDevices(
      {required List<UniqueUID> withServices,
      ScanMode scanMode = ScanMode.balanced}) async* {
    Repository().initialize;
    await Repository().scanDevices(
      withServices: withServices,
      scanMode: scanMode,
    );
  }

  ///Connect To Device
  Stream<DeviceDiscovered> connectToDevice({required String mac}) async* {
    await Repository().connectDevice(
      mac: mac,
    );
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
