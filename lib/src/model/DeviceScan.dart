// ignore_for_file: file_names, constant_identifier_names

part of flubletter;

class DeviceScan {
  ///The device`s MacAddress
  final String mac;

  ///The device`s Name
  final String name;

  ///The device`s RSSI
  final num rssi;

  const DeviceScan({
    required this.mac,
    required this.name,
    required this.rssi,
  });
}

enum ScanMode {
  opportunistic,

  lowPower,

  balanced,

  lowLatency,
}
