// ignore_for_file: file_names
part of flubletter;

class DeviceDiscovered {
  ///The device`s Connection State
  final ConnectionStatus connectionState;

  const DeviceDiscovered({
    required this.connectionState,
  });
  factory DeviceDiscovered.deviceDiscovered(num connectionState) {
    switch (connectionState) {
      case 1:
        {
          return const DeviceDiscovered(
              connectionState: ConnectionStatus.connected);
        }
      case -1:
        {
          return const DeviceDiscovered(
              connectionState: ConnectionStatus.disconnected);
        }
      case 0:
        {
          return const DeviceDiscovered(
              connectionState: ConnectionStatus.connecting);
        }
      case 2:
        {
          return const DeviceDiscovered(
              connectionState: ConnectionStatus.disconnecting);
        }
      default:
        return const DeviceDiscovered(
            connectionState: ConnectionStatus.disconnected);
    }
  }
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
