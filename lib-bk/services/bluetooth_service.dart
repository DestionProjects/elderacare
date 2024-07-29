import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/crc_calculator.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/crc_calculator.dart';

typedef OnDataReceived = void Function(Map<String, int>);
typedef OnMacAddressReceived = void Function(String);

class BluetoothService {
  final fbp.FlutterBluePlus _flutterBlue = fbp.FlutterBluePlus();
  final StreamController<List<fbp.ScanResult>> _scanResultsController =
      StreamController.broadcast();
  Stream<List<fbp.ScanResult>> get scanResults => _scanResultsController.stream;

  fbp.BluetoothCharacteristic? txCharacteristic;
  fbp.BluetoothCharacteristic? rxCharacteristic;

  OnDataReceived? onDataReceived;
  OnMacAddressReceived? onMacAddressReceived;

  void scanForDevices() {
    fbp.FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    fbp.FlutterBluePlus.scanResults.listen((results) {
      _scanResultsController.add(results);
    });
    Future.delayed(Duration(seconds: 5))
        .then((_) => fbp.FlutterBluePlus.stopScan());
  }

  void stopScan() {
    fbp.FlutterBluePlus.stopScan();
  }

  Future<bool> connectToDevice(fbp.BluetoothDevice device) async {
    try {
      await device.connect();
      Fluttertoast.showToast(
          msg: "Connected to ${device.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      await discoverServices(device);
      sendCommandToMeasure(); // Send command to measure HR, BP, HRV, Temp
      sendCommandToGetMacAddress(); // Send command to get Mac address
      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to connect to ${device.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  Future<void> discoverServices(fbp.BluetoothDevice device) async {
    List<fbp.BluetoothService> services = await device.discoverServices();
    for (fbp.BluetoothService service in services) {
      if (service.uuid == fbp.Guid('0000fff0-0000-1000-8000-00805f9b34fb')) {
        for (fbp.BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid ==
              fbp.Guid('0000fff6-0000-1000-8000-00805f9b34fb')) {
            txCharacteristic = characteristic;
          }
          if (characteristic.uuid ==
              fbp.Guid('0000fff7-0000-1000-8000-00805f9b34fb')) {
            rxCharacteristic = characteristic;
            // listenForResponse(characteristic); // Listen for responses
          }
        }
      }
    }
  }

  void sendCommandToMeasure() async {
    if (txCharacteristic != null) {
      List<int> command = createCommand();
      await txCharacteristic!.write(command);
      print("Sent command to measure HR, BP, HRV, Temp");
    }
  }

  void sendCommandToGetMacAddress() async {
    if (txCharacteristic != null) {
      List<int> command = [0x22]; // Command to get Mac address
      await txCharacteristic!.write(command);
      print("Sent command to get Mac address");
    }
  }

  List<int> createCommand() {
    List<int> value = List.filled(16, 0);
    value[0] =
        0x28; // Command to measure heart rate, blood oxygen, HRV, body temp
    value[1] =
        0x02; // Measurement type: 0x01: HRV, 0x02: Heart Rate, 0x03: Blood Oxygen, 0x04: Body Temperature
    value[2] = 0x01; // 0x01 to start measurement, 0x00 to stop

    // Compute CRC and set the last byte
    int crc = CrcCalculator.calculateCRC(value);
    value[value.length - 1] = crc;

    return value;
  }

  void listenForResponse(fbp.BluetoothCharacteristic characteristic) {
    characteristic.value.listen((value) {
      if (value.isNotEmpty && value[0] == 0x28) {
        Map<String, int> data = {
          'heartRate': value[1],
          'bloodOxygen': value[2],
          'hrv': value[3],
          'temperature': value[4]
        };

        if (onDataReceived != null) {
          onDataReceived!(data);
        }
      } else if (value.isNotEmpty && value[0] == 0x22) {
        // Assuming 0x22 is the identifier for Mac address response

        String macAddress = value
            .sublist(1, 7)
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':');
        if (onMacAddressReceived != null) {
          onMacAddressReceived!(macAddress);
        }
      }
    });
    characteristic.setNotifyValue(true);
  }

  void dispose() {
    _scanResultsController.close();
  }
}
