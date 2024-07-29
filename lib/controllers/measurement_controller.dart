// controllers/measurement_controller.dart
import 'package:elderacare/models/measurement_type.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class MeasurementController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  var measurements = <Measurement>[].obs; // Observables for GetX

  MeasurementController() {
    // Initialize with data if necessary
  }

  void addMeasurement(Measurement measurement) {
    measurements.add(measurement);
    _sendToApi(measurement);
  }

  void _sendToApi(Measurement measurement) {
    final macAddress = measurement.deviceMacId;
    final readingType = measurement.readingType;
    final value = measurement.value;

    if (macAddress != null && readingType != null && value != null) {
      _apiService
          .sendMeasurement(macAddress, readingType, value.toString())
          .then((result) {
        if (result == "Success") {
          print("Successfully sent $readingType to API");
        } else {
          print("Failed to send $readingType to API");
        }
      });
    } else {
      print("Missing information, cannot send to API");
    }
  }
}
