import 'dart:async';

import 'package:flubletter/src/BluetoothConnection/DeviceDiscovered.dart';
import 'package:flubletter/src/BluetoothScan/DeviceScan.dart';
import 'package:flubletter/src/BluetoothScan/ScanMode.dart';
import 'package:flubletter/src/Repository/Repository.dart';
import 'package:flubletter/src/UniqueUid/UniqueUid.dart';

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
  Stream<bool> get isOn async* {
    bool ison = await Repository().isOn();
    yield ison;
  }

  ///Enable Bluetooth
  Future<void> enable() async {
    await Repository().enableBT;
  }

  ///Disable Bluetooth
  Future<void> disable() async {
    await Repository().disbaleBT;
  }
}
