// // screens/scan_screen.dart

// import 'dart:async';
// import 'package:elderacare/features/scan/widgets/scan_result_tile.dart';
// import 'package:elderacare/screens/home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'device_screen.dart';
// import '../utils/snackbar.dart';
// import '../widgets/system_device_tile.dart';
// import '../widgets/scan_result_tile.dart';
// import '../utils/extra.dart';
// import '../services/bluetooth_connection_service.dart'; // Import the BluetoothConnectionService
// import 'package:lottie/lottie.dart';

// class ScanScreen extends StatefulWidget {
//   const ScanScreen({Key? key}) : super(key: key);

//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   final BluetoothConnectionService _bluetoothConnectionService =
//       BluetoothConnectionService();
//   List<BluetoothDevice> _systemDevices = [];
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;

//   @override
//   void initState() {
//     super.initState();

//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         _scanResults = results
//             .where(
//                 (result) => result.device.advName.toLowerCase().startsWith('j'))
//             .toList();
//       });
//     }, onError: (e) {
//       Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });

//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       setState(() {
//         _isScanning = state;
//       });
//     });

//     // _bluetoothConnectionService.connectToSavedDevice().then((device) {
//     //   if (device != null) {
//     //     // Handle successful reconnection (e.g., update UI)
//     //   }
//     // }).catchError((e) {
//     //   Snackbar.show(ABC.c, "Failed to connect to the saved device.",
//     //       success: false);
//     // });
//   }

//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }

//   Future<void> onScanPressed() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
//           success: false);
//     }
//     try {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Start Scan Error:", e),
//           success: false);
//     }
//   }

//   Future<void> onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
//           success: false);
//     }
//   }

//   void onConnectPressed(BluetoothDevice device) {
//     _bluetoothConnectionService.connectToDevice(device).then((success) {
//       if (success) {
//         _bluetoothConnectionService.sendCommandToGetMacAddress();
//         _bluetoothConnectionService.onMacAddressReceived = (macAddress) {
//           _bluetoothConnectionService.saveDeviceId(macAddress);

//           Snackbar.show(ABC.b, "MAC Address: $macAddress", success: true);
//           // Navigate to ParameterScreen with the device and MAC address
//           MaterialPageRoute route = MaterialPageRoute(
//               builder: (context) => DeviceScreen(device: device),
//               settings: RouteSettings(name: '/DeviceScreen'));
//           Navigator.of(context).push(route);
//           // Navigator.of(context).push(MaterialPageRoute(
//           //   builder: (context) => ParameterScreen(
//           //       // device: device,
//           //       // macAddress: macAddress,
//           //       ),
//           //   settings: RouteSettings(name: '/DeviceScreen'),
//           // ));
//         };
//       } else {
//         Snackbar.show(ABC.c, "Failed to connect to ${device.name}",
//             success: false);
//       }
//     }).catchError((e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//           success: false);
//     });
//   }

//   Future<void> onRefresh() {
//     if (!_isScanning) {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     }
//     return Future.delayed(Duration(milliseconds: 500));
//   }

//   Widget buildScanButton(BuildContext context) {
//     return FloatingActionButton(
//       child: _isScanning ? const Icon(Icons.stop) : const Text("SCAN"),
//       onPressed: _isScanning ? onStopPressed : onScanPressed,
//       backgroundColor: _isScanning ? Colors.red : Colors.blue,
//     );
//   }

//   List<Widget> _buildSystemDeviceTiles(BuildContext context) {
//     return _systemDevices.map((d) {
//       return SystemDeviceTile(
//         device: d,
//         onOpen: () => Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => DeviceScreen(device: d),
//           settings: RouteSettings(name: '/DeviceScreen'),
//         )),
//         onConnect: () => onConnectPressed(d),
//       );
//     }).toList();
//   }

//   List<Widget> _buildScanResultTiles(BuildContext context) {
//     return _scanResults.map((r) {
//       return ScanResultTile(
//         bluetoothConnectionService: _bluetoothConnectionService,
//         result: r,
//         onTap: () => onConnectPressed(r.device),
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: Snackbar.snackBarKeyB,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Find Devices'),
//         ),
//         body: RefreshIndicator(
//           onRefresh: onRefresh,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Center(
//                 child: _isScanning
//                     ? Lottie.asset(
//                         'assets/animations/scanning.json', // Animation when scanning
//                         height: 200,
//                       )
//                     : Lottie.asset(
//                         'assets/animations/not_scanning.json', // Animation when not scanning
//                         height: 200,
//                       ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 _isScanning ? 'Scanning for devices...' : 'Scan for devices',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Make sure your Bluetooth is enabled',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//               const SizedBox(height: 40),
//               Expanded(
//                 child: ListView(
//                   children: <Widget>[
//                     ..._buildSystemDeviceTiles(context),
//                     ..._buildScanResultTiles(context),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: buildScanButton(context),
//       ),
//     );
//   }
// }
