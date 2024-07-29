// services/measurement_service.dart
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

typedef OnMeasurementUpdate = void Function(Map<String, dynamic>);

class MeasurementService {
  final BluetoothCharacteristic txCharacteristic;
  final BluetoothCharacteristic rxCharacteristic;
  final OnMeasurementUpdate onMeasurementUpdate;
  final ApiService _apiService = ApiService();
  int validMeasurementCount = 0;
  static const int thresholdCount =
      3; // Number of consecutive valid readings before sending to API

  MeasurementService({
    required this.txCharacteristic,
    required this.rxCharacteristic,
    required this.onMeasurementUpdate,
  }) {
    _commonListener();
  }

  Future<void> startMeasurements() async {
    while (true) {
      await _readAndSendMeasurement(0x02, 'Heart Rate');
      await _readAndSendMeasurement(0x03, 'Blood Oxygen');
      await _readAndSendMeasurement(0x01, 'HRV');
      await _readAndSendMeasurement(0x04, 'Body Temperature');
      await Future.delayed(Duration(minutes: 1));
    }
  }

  void _commonListener() {
    rxCharacteristic.value.listen((value) async {
      if (value.isNotEmpty && value[0] == 0x28) {
        final prefs = await SharedPreferences.getInstance();
        String? macAddress = prefs.getString('mac_address');
        if (macAddress == null) {
          print("MAC Address not found in storage.");
          return;
        }
        _processMeasurementData(value, macAddress);
      }
    });
  }

  Future<void> _readAndSendMeasurement(
      int measurementType, String parameterName) async {
    await _startMeasurement(measurementType);
    await Future.delayed(Duration(seconds: 15));
    await _stopMeasurement(measurementType);
    print("$parameterName reading completed.");
  }

  Future<void> _startMeasurement(int measurementType) async {
    List<int> command = _createCommand(measurementType, 0x01);
    await txCharacteristic.write(command);
  }

  Future<void> _stopMeasurement(int measurementType) async {
    List<int> command = _createCommand(measurementType, 0x00);
    await txCharacteristic.write(command);
  }

  List<int> _createCommand(int measurementType, int startStopInd) {
    List<int> value = List.filled(16, 0);
    value[0] = 0x28;
    value[1] = measurementType;
    value[2] = startStopInd;
    value[15] = _calculateCRC(value);
    return value;
  }

  void _processMeasurementData(List<int> value, String macAddress) {
    int measurementType = value[1];
    int measurementValue;

    switch (measurementType) {
      case 0x02:
        measurementValue = value[2];
        if (measurementValue > 0) {
          print("Heart Rate: $measurementValue");
          _sendToApi(macAddress, "heartRate", measurementValue);
          onMeasurementUpdate({'heartRate': measurementValue});
        }
        break;
      case 0x03:
        measurementValue = value[3];
        if (measurementValue > 0) {
          print("Blood Oxygen: $measurementValue");
          _sendToApi(macAddress, "bloodOxygen", measurementValue);
          onMeasurementUpdate({'bloodOxygen': measurementValue});
        }
        break;
      case 0x01:
        measurementValue = value[4];
        if (measurementValue > 0) {
          print("HRV: $measurementValue");
          _sendToApi(macAddress, "hrv", measurementValue);
          onMeasurementUpdate({'hrv': measurementValue});
        }
        break;
      case 0x04:
        measurementValue = value[8];
        if (measurementValue > 0) {
          print("Body Temperature: $measurementValue");
          _sendToApi(macAddress, "bodyTemperature", measurementValue);
          onMeasurementUpdate({'bodyTemperature': measurementValue});
        }
        break;
      default:
        print("Unknown measurement type: $measurementType");
    }
  }

  void _sendToApi(String macAddress, String readingType, int value) {
    _apiService
        .sendMeasurement(macAddress, readingType, value.toString())
        .then((result) {
      if (result == "Success") {
        print("Successfully sent $readingType to API");
      } else {
        print("Failed to send $readingType to API");
      }
    });
  }

  static int _calculateCRC(List<int> data) {
    int crc = 0;
    for (int byte in data) {
      crc = (crc + byte) & 0xFF;
    }
    return crc;
  }
}
