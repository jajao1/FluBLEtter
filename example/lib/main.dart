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

  String status = 'desconectado';

  @override
  void initState() {
    scanDevices = [];
    super.initState();
  }

  Future<void> initScan() async {
    streamscan = flubletter.scanDevices(withServices: []).listen((device) {
      setState(() {
        scanDevices.add(device);
      });
    });
  }

  void connectOnDevice(DeviceScan deviceScan) {
    device =
        flubletter.connectToDevice(mac: deviceScan.name).listen((connection) {
      switch (connection.connectionState) {
        case ConnectionStatus.connecting:
          setState(() {
            status = 'conectando a ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.connected:
          setState(() {
            status = 'conectado a ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.disconnecting:
          setState(() {
            status = 'desconectando de ${deviceScan.name}';
          });
          break;
        case ConnectionStatus.disconnected:
          setState(() {
            status = 'desconectado de ${deviceScan.name}';
          });
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(status),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => initScan(),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.blueAccent]),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 100,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      'NOVO GATEWAY',
                      style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scanDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      scanDevices[index].name,
                    ),
                    subtitle: Text(
                      scanDevices[index].mac,
                    ),
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
