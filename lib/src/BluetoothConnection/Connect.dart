// ignore_for_file: file_names

part of flubletter;

abstract class _Connection {
  BehaviorSubject<DeviceDiscovered> deviceState =
      BehaviorSubject<DeviceDiscovered>();

  void newState(DeviceDiscovered deviceScan) {
    deviceState.add(deviceScan);
  }
}

class Connection implements _Connection {
  @override
  BehaviorSubject<DeviceDiscovered> deviceState =
      BehaviorSubject<DeviceDiscovered>();

  @override
  void newState(DeviceDiscovered deviceScan) {
    deviceState.add(deviceScan);
  }
}
