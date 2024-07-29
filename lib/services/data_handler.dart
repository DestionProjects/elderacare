import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef OnMacAddressReceived = void Function(String macAddress);
typedef OnMeasurementDataReceived = void Function(Map<String, int> data);

class BluetoothConnectionService {
  BluetoothCharacteristic? txCharacteristic;
  BluetoothCharacteristic? rxCharacteristic;

  OnMacAddressReceived? onMacAddressReceived;
  OnMeasurementDataReceived? onMeasurementDataReceived;
  bool _isMeasuring = false;

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      await discoverServices(device);
      return true;
    } catch (e) {
      print("Failed to connect: $e");
      return false;
    }
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid == Guid('0000fff0-0000-1000-8000-00805f9b34fb')) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid ==
              Guid('0000fff6-0000-1000-8000-00805f9b34fb')) {
            txCharacteristic = characteristic;
          }
          if (characteristic.uuid ==
              Guid('0000fff7-0000-1000-8000-00805f9b34fb')) {
            rxCharacteristic = characteristic;
            listenForResponse(characteristic);
          }
        }
      }
    }
  }

  void sendCommandToGetMacAddress() async {
    if (txCharacteristic != null) {
      List<int> command = List.filled(16, 0);
      command[0] = 0x22; // Command to get MAC address
      command[15] = calculateCRC(command);
      await txCharacteristic!.write(command);
      print("Sent command to get MAC address");
    } else {
      print("TX Characteristic not found.");
    }
  }

  void startContinuousMeasurement() async {
    _isMeasuring = true;
    while (_isMeasuring) {
      for (int type = 1; type <= 4; type++) {
        if (!_isMeasuring) break;
        print("Starting measurement for type $type...");
        sendMeasurementCommand(type, true);
        await Future.delayed(Duration(seconds: 15));
        sendMeasurementCommand(type, false);
        print("Stopped measurement for type $type.");
      }
    }
  }

  void stopContinuousMeasurement() {
    _isMeasuring = false;
  }

  void sendMeasurementCommand(int measurementType, bool start) async {
    if (txCharacteristic != null) {
      List<int> command = List.filled(16, 0);
      command[0] = 0x28; // Command for measurements
      command[1] = measurementType;
      command[2] = start ? 0x01 : 0x00; // Start or stop measurement
      command[15] = calculateCRC(command);
      await txCharacteristic!.write(command);
      print(
          "Sent command for measurement: type $measurementType, start: $start");
    } else {
      print("TX Characteristic not found.");
    }
  }

  void listenForResponse(BluetoothCharacteristic characteristic) {
    characteristic.value.listen((value) {
      if (value.isNotEmpty) {
        if (value[0] == 0x22) {
          String macAddress = value
              .sublist(1, 7)
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':');
          print("MAC Address: $macAddress");
          if (onMacAddressReceived != null) {
            onMacAddressReceived!(macAddress);
          }
        } else if (value[0] == 0x28) {
          Map<String, int> data = {
            "heartRate": value[2],
            "bloodOxygen": value[3],
            "hrv": value[4],
            "bodyTemperature": value[8],
          };
          print(
              "Measurement data received: Heart Rate: ${data['heartRate']}, Blood Oxygen: ${data['bloodOxygen']}, HRV: ${data['hrv']}, Body Temperature: ${data['bodyTemperature']}");
          if (onMeasurementDataReceived != null) {
            onMeasurementDataReceived!(data);
          }
        } else {
          print("Unexpected data received: $value");
        }
      }
    });
    characteristic.setNotifyValue(true);
  }

  static int calculateCRC(List<int> data) {
    int crc = 0;
    for (int byte in data) {
      crc = (crc + byte) & 0xFF;
    }
    return crc;
  }
}
