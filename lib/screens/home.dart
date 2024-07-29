// screens/parameter_screen.dart
import 'package:elderacare/controllers/paramete_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/scan_screen.dart'; // Import ScanScreen

class ParameterScreen extends StatelessWidget {
  final ParameterController parameterController =
      Get.put(ParameterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parameter Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth_searching), // Icon for scanning
            onPressed: () {
              Get.to(() => ScanScreen()); // Navigate to ScanScreen
            },
          ),
        ],
      ),
      body: Obx(() {
        final parameters = parameterController.currentParameters.value;
        if (parameters == null) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            ListTile(
                title: Text('Heart Rate'),
                subtitle: Text(parameters.heartRate)),
            ListTile(
                title: Text('Blood Oxygen'),
                subtitle: Text(parameters.bloodOxygen)),
            ListTile(title: Text('Stress'), subtitle: Text(parameters.stress)),
            ListTile(title: Text('HRV'), subtitle: Text(parameters.hrv)),
            ListTile(
                title: Text('Body Temperature'),
                subtitle: Text(parameters.bodyTemp)),
            ListTile(
                title: Text('Blood Pressure'),
                subtitle: Text(parameters.bloodPressure)),
          ],
        );
      }),
    );
  }
}
