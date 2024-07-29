// import 'dart:async';
// import 'package:elderacare/utils/storage_service.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
// import '../services/bluetooth_service.dart';
// import '../services/measurement_service.dart';

// class BluetoothController {
//   final BluetoothService _bluetoothService = BluetoothService();
//   late StreamSubscription<fbp.BluetoothAdapterState> _adapterStateSubscription;
//   Stream<List<fbp.ScanResult>> get scanResults => _bluetoothService.scanResults;

//   int heartRate = 0;
//   int bloodOxygen = 0;
//   int hrv = 0;
//   int temperature = 0;
//   MeasurementService? _measurementService;

//   BluetoothController() {
//     _adapterStateSubscription =
//         fbp.FlutterBluePlus.adapterState.listen((state) {
//       if (state != fbp.BluetoothAdapterState.on) {
//         // Handle Bluetooth off state
//       }
//     });

//     _bluetoothService.onDataReceived = (data) {
//       heartRate = data['heartRate']!;
//       bloodOxygen = data['bloodOxygen']!;
//       hrv = data['hrv']!;
//       temperature = data['temperature']!;
//     };

//     // Listen for Mac address updates
//     _bluetoothService.onMacAddressReceived = (macAddress) async {
//       await _storageService.storeMacAddress(macAddress);
//     };
//   }

//   final StorageService _storageService = StorageService();

//   Future<bool> connectToDevice(fbp.BluetoothDevice device) async {
//     bool connected = await _bluetoothService.connectToDevice(device);
//     print("Device Before Connect $connected");
//     if (connected) {
//       fbp.BluetoothCharacteristic tx = _bluetoothService.txCharacteristic!;
//       fbp.BluetoothCharacteristic rx = _bluetoothService.rxCharacteristic!;
//       MeasurementService measurementService = MeasurementService(
//         device: device,
//         txCharacteristic: tx,
//         rxCharacteristic: rx,
//         onMeasurementUpdate: (data) {
//           if (data.containsKey('heartRate')) heartRate = data['heartRate'];
//           if (data.containsKey('bloodOxygen'))
//             bloodOxygen = data['bloodOxygen'];
//           if (data.containsKey('hrv')) hrv = data['hrv'];
//           if (data.containsKey('temperature'))
//             temperature = data['temperature'];
//         },
//       );
//       print("Starting MeasurementService");
//       measurementService.startMeasurements(); // Start measurements
//       // measurementService.startMeasurements();
//     }
//     return connected;
//   }

//   BluetoothService get bluetoothService => _bluetoothService;

//   void dispose() {
//     _adapterStateSubscription.cancel();
//     _bluetoothService.dispose();
//   }
// }
