// main.dart

import 'dart:async';
import 'package:elderacare/controllers/paramete_controller.dart';
import 'package:elderacare/features/home/screens/landing.dart';
import 'package:elderacare/features/scan/views/scan_screen.dart';
import 'package:elderacare/screens/home.dart';
import 'package:elderacare/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import 'screens/bluetooth_off_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  // Ensure that ParameterController is available for GetX
  Get.put(ParameterController());

  // Check for MAC address in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final macAddress = prefs.getString('mac_address');

  runApp(FlutterBlueApp(
      initialScreen: macAddress != null ? Dashboard() : ScanScreen()));
}

class FlutterBlueApp extends StatelessWidget {
  final Widget initialScreen;

  const FlutterBlueApp({Key? key, required this.initialScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blue',
      color: Colors.lightBlue,
      home: initialScreen,
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}
