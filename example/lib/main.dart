import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flubletter/flubletter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Flubletter flubletter = Flubletter();
  List<DeviceScan> scanDevices = [];
  StreamSubscription<DeviceScan>? streamscan;
  StreamSubscription<DeviceDiscovered>? device;
  List<String> macs = [];
  bool scanning = false;

  String status = 'Disconnected';

  @override
  void initState() {
    scanDevices = [];
    super.initState();
  }

  void initScan() {
    streamscan = flubletter.scanDevices(withServices: []).listen((device) {
      if (macs.contains(device.mac)) {
        var oldDeviceValue = scanDevices
            .singleWhere((deviceScan) => deviceScan.mac == deviceScan.mac);
        setState(() {
          scanDevices[scanDevices.indexOf(oldDeviceValue)] = device;
        });
      } else {
        setState(() {
          macs.add(device.mac);
          scanDevices.add(device);
        });
      }
    });
  }

  void connectOnDevice(DeviceScan deviceScan) {
    device =
        flubletter.connectToDevice(mac: deviceScan.name).listen((connection) {
      switch (connection.connectionState) {
        case ConnectionStatus.connecting:
          setState(() {
            status = 'Connecting ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.connected:
          setState(() {
            status = 'connected ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.disconnecting:
          setState(() {
            status = 'disconnecting  ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.disconnected:
          setState(() {
            status = 'disconnected ${deviceScan.name}';
          });
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flubletter plugin example'),
          actions: <Widget>[
            scanning
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        scanning = false;
                      });
                    },
                    child: const Icon(
                      Icons.stop,
                      color: Colors.white,
                    ),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        status = 'Scanning';
                        scanning = true;
                      });
                      initScan();
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                status,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Discovered devices ',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scanDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                scanDevices[index].name,
                              ),
                              subtitle: Text(
                                scanDevices[index].mac,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${scanDevices[index].rssi}dBm',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ))),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
