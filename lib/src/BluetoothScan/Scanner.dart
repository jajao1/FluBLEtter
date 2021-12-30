// ignore_for_file: file_names

part of flubletter;

abstract class _Scanner {
  BehaviorSubject<DeviceScan> scanResult = BehaviorSubject<DeviceScan>();

  final Repository _repository = Repository();

  void newDevice(DeviceScan deviceScan) {
    scanResult.add(deviceScan);
  }
}

class Scanner implements _Scanner {
  @override
  BehaviorSubject<DeviceScan> scanResult = BehaviorSubject<DeviceScan>();

  @override
  void newDevice(DeviceScan deviceScan) {
    scanResult.add(deviceScan);
  }

  @override
  Repository get _repository => Repository();
}
