// import 'package:elderacare/utils/storage_service.dart';
// import 'package:elderacare/views/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

// class BluetoothScreen extends StatefulWidget {
//   @override
//   _BluetoothScreenState createState() => _BluetoothScreenState();
// }

// class _BluetoothScreenState extends State<BluetoothScreen> {
//   final fbp.FlutterBluePlus _flutterBlue = fbp.FlutterBluePlus();
//   final StorageService _storageService = StorageService();
//   List<fbp.ScanResult> _scanResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _startScan();
//   }

//   void _startScan() {
//     fbp.FlutterBluePlus.startScan(timeout: Duration(seconds: 25));
//     fbp.FlutterBluePlus.scanResults.listen((results) {
//       setState(() {
//         String pName;
//         print("Scan Screen Result ##################$results");
//         for (int i = 0; i < results.length; i++) {
//           pName = results[i].device.platformName;
//           if (pName != null && pName.startsWith("J")) {
//             _scanResults.addOrUpdate(results[i]);
//           }
//         }
//         //_scanResults = results;
//       });
//     });
//   }

//   Future<void> _connectToDevice(fbp.BluetoothDevice device) async {
//     try {
//       await device.connect();
//       await _storageService.storeMacAddress(device.id.id);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) => HomeScreen(macAddress: device.id.id)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to connect to devicefffff')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Bluetooth Device'),
//       ),
//       body: ListView.builder(
//         itemCount: _scanResults.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_scanResults[index].device.name),
//             subtitle: Text(_scanResults[index].device.id.id),
//             onTap: () => _connectToDevice(_scanResults[index].device),
//           );
//         },
//       ),
//     );
//   }
// }
