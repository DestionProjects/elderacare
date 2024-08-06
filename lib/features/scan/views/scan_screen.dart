// screens/scan_screen.dart

// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:elderacare/features/home/screens/landing.dart';
import 'package:elderacare/features/measurements/services/connection.dart';
import 'package:elderacare/features/scan/views/device_info.dart';
import 'package:elderacare/features/scan/widgets/scan_button.dart';
import 'package:elderacare/features/scan/widgets/scan_result_tile.dart';
import 'package:elderacare/screens/home.dart';
import 'package:elderacare/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/system_device_tile.dart';
import 'package:lottie/lottie.dart';

// screens/scan_screen.dart

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final BluetoothConnectionService _bluetoothConnectionService =
      BluetoothConnectionService();
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  void _initializeBluetooth() {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults = results
            .where((result) => result.device.name.toLowerCase().startsWith('j'))
            .toList();
      });
    }, onError: (e) {
      Snackbar.show(ABC.a, "Scan Error: $e", success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      setState(() {
        _isScanning = state;
      });
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    try {
      _systemDevices = await FlutterBluePlus.connectedDevices;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      Snackbar.show(ABC.b, "Scan Error: $e", success: false);
    }
  }

  Future<void> _stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.c, "Stop Scan Error: $e", success: false);
    }
  }

  void _onDeviceSelected(BluetoothDevice device) async {
    bool isConnected =
        await _bluetoothConnectionService.connectToDevice(device);
    if (isConnected) {
      await _bluetoothConnectionService.sendCommandToGetMacAddress();
      _bluetoothConnectionService.onMacAddressReceived = (macAddress) {
        Snackbar.show(ABC.c, "MAC Address: $macAddress", success: true);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard()), // Navigate to Dashboard
        );
      };
    } else {
      Snackbar.show(ABC.c, "Failed to connect to ${device.name}",
          success: false);
    }
  }

  Future<void> _refreshDevices() async {
    if (!_isScanning) {
      await _startScan();
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyA,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshDevices,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                _isScanning ? 'Scanning for devices...' : 'Scan for devices',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Make sure your Bluetooth is enabled',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ..._systemDevices.map((d) => SystemDeviceTile(
                          device: d,
                          onOpen: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DeviceScreen(device: d),
                            ),
                          ),
                          onConnect: () => _onDeviceSelected(d),
                        )),
                    ..._scanResults.map((r) => ScanResultTile(
                          result: r,
                          onTap: () => _onDeviceSelected(r.device),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ScanButton(
          isScanning: _isScanning,
          onPressed: _isScanning ? _stopScan : _startScan,
        ),
      ),
    );
  }
}
