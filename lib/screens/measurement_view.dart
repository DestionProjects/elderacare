// views/measurement_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/measurement_controller.dart';

class MeasurementView extends StatelessWidget {
  final MeasurementController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Measurements'),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: _controller.measurements.length,
          itemBuilder: (context, index) {
            final measurement = _controller.measurements[index];
            return ListTile(
              title: Text('${measurement.readingType}: ${measurement.value}'),
              subtitle: Text('Device: ${measurement.deviceMacId}'),
            );
          },
        );
      }),
    );
  }
}
