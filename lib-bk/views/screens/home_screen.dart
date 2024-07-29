// import 'dart:async';

// import 'package:elderacare/controllers/bluetooth_controller.dart';
// import 'package:elderacare/services/api_service.dart';
// import 'package:elderacare/utils/storage_service.dart';
// import 'package:elderacare/views/screens/scan_screen.dart';
// import 'package:elderacare/views/widgets/bottom_nav_bar.dart';
// import 'package:elderacare/views/widgets/health_stat_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class HomeScreen extends StatefulWidget {
//   final String macAddress;

//   HomeScreen({required this.macAddress});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final BluetoothController _bluetoothController = BluetoothController();
//   final ApiService _apiService = ApiService();
//   final StorageService _storageService = StorageService();
//   Timer? _timer;
//   var healthData = {
//     'Heart Rate': '',
//     'SpO2': '',
//     'HRV': '',
//     'Temperature': '',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _retrieveAndFetchData();
//     _startPeriodicUpdate();
//   }

//   void _startPeriodicUpdate() {
//     _timer = Timer.periodic(
//         Duration(seconds: 20), (Timer t) => _retrieveAndFetchData());
//   }

//   void updateHealthData(Map<String, dynamic> newData) {
//     setState(() {
//       healthData = {
//         'Heart Rate': '${newData['heartRate'] ?? ''} bpm',
//         'SpO2': '${newData['bloodOxygen'] ?? ''} %',
//         'HRV': '${newData['hrv'] ?? ''} ms',
//         'Temperature': '${newData['bodyTemp'] ?? ''} °F',
//       };
//     });
//   }

//   void _retrieveAndFetchData() async {
//     String? macAddress = await _storageService.retrieveMacAddress();
//     if (macAddress != null) {
//       fetchAndUpdateHealthData(macAddress);
//     }
//   }

//   void fetchAndUpdateHealthData(String deviceId) async {
//     try {
//       var newData = await _apiService.fetchData(deviceId);
//       updateHealthData(newData);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load data: $e')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Stop the timer to avoid memory leaks
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       bottomNavigationBar: CustomBottomNavBar(),
//       body: Stack(
//         children: <Widget>[
//           Container(
//             height: size.height * .33,
//             decoration: BoxDecoration(
//               color: Color(0xFFF5CEB8),
//               image: DecorationImage(
//                 alignment: Alignment.centerLeft,
//                 image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ScanScreen(onDeviceSelected: (device) async {
//                           print(
//                               "Start Bluetooth Device command ###############");
//                           if (await _bluetoothController
//                               .connectToDevice(device)) {
//                             Navigator.pop(context);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content:
//                                     Text('Failed to connffff ect to device')));
//                           }
//                         }),
//                       ),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 92,
//                       width: 52,
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF2BEA1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: SvgPicture.asset("assets/icons/blue.svg"),
//                     ),
//                   ),
//                   Text(
//                     "Good Day Suri\nYour health monitoring looks good. Maintain the same",
//                     style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
//                   ),
//                   SizedBox(height: 30),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       childAspectRatio: .85,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                       children: healthData.entries.map((entry) {
//                         return HealthStatCard(
//                           title: entry.key,
//                           value: entry.value,
//                           imagePath:
//                               'assets/images/${entry.key.toLowerCase().replaceAll(' ', '_')}.png',
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
