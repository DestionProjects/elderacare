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
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'screens/bluetooth_off_screen.dart';
import 'dart:isolate'; // Import the dart:isolate library

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  // Ensure that ParameterController is available for GetX
  Get.put(ParameterController());

  // Check for MAC address in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final macAddress = prefs.getString('mac_address');

  // Initialize foreground task
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'MeasurementServiceChannel',
      channelName: 'Measurement Service Channel',
      channelDescription:
          'This notification appears when the measurement service is running.',
      channelImportance: NotificationChannelImportance.DEFAULT,
      priority: NotificationPriority.DEFAULT,
      iconData: NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
    ),
    iosNotificationOptions: IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      interval: 5000,
      isOnceEvent: false,
    ),
  );

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
      navigatorObservers: [BluetoothAdapterStateObserver()],
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

void startForegroundService() {
  FlutterForegroundTask.startService(
    notificationTitle: 'Measurement Service',
    notificationText: 'Running measurement service...',
  );

  FlutterForegroundTask.setTaskHandler(MeasurementTaskHandler());
}

class MeasurementTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Initialize and start measurement service
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Handle periodic events
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Clean up resources
  }

  @override
  void onButtonPressed(String id) {
    // Handle button pressed
  }

  @override
  void onNotificationPressed() {
    // Handle notification pressed
  }
}
