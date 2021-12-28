// ignore_for_file: file_names
part of flubletter;

class DeviceDiscovered {
  ///The device`s MacAddress
  final String mac;

  ///The device`s Connection State
  final ConnectionStatus connectionState;

  const DeviceDiscovered({
    required this.mac,
    required this.connectionState,
  });
}

enum ConnectionStatus {
  ///Connecting to device
  connecting,

  ///Connected to the device
  connected,

  ///Disconnected to the device
  disconnected,

  ///Disconnecting to device
  disconnecting,
}
