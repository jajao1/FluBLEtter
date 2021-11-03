// ignore_for_file: file_names, constant_identifier_names

class DeviceScan {
  ///The device`s MacAddress
  final String mac;

  ///The device`s Name
  final String name;

  ///The device`s RSSI
  final int rssi;

  const DeviceScan({
    required this.mac,
    required this.name,
    required this.rssi,
  });
}

enum ObserveStateChanges {
  ///Bluetooth for this device is not available
  bluetooth_not_avaible,

  ///The location permission not granted
  location_permission_not_granted,

  ///Bluetooth for this device is not enable
  bluetooth_not_enable,

  ///Location services not enable
  location_services_not_enable,

  ///
  ready,
}
