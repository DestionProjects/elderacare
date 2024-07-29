import 'dart:async';
import 'dart:ffi';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../utils/crc_calculator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/storage_service.dart';

typedef OnMeasurementUpdate = void Function(Map<String, dynamic>);

class MeasurementService {
  final fbp.BluetoothDevice device;
  final fbp.BluetoothCharacteristic txCharacteristic;
  final fbp.BluetoothCharacteristic rxCharacteristic;
  OnMeasurementUpdate onMeasurementUpdate;
  final StorageService _storageService = StorageService();
  late List<int> heartRateList;
  late List<int> bloodOxygenList;
  late List<int> hrvList;
  late List<int> bodyTempList;

  MeasurementService({
    required this.device,
    required this.txCharacteristic,
    required this.rxCharacteristic,
    required this.onMeasurementUpdate,
  }) {
    print("MeasurementService created for device: ${device.id}");
  }

  Future<void> startMeasurements() async {
    print("Starting measurements");
    int heartCount = 0;
    int spo2Count = 0;
    int hrvCount = 0;
    int tempCount = 0;
    int startCount = 0;
    int stopCount = 0;
    String? macAddress = await _storageService.retrieveMacAddress();
    while (true) {
      if (startCount == 0 && heartCount == 0) {
        print("###########################Inside heart reading **********");
        heartRateList = [];
        await _readHeartRate();
        ++heartCount;
        ++startCount;
        stopCount = 0;

        if (macAddress != null &&
            heartRateList != null &&
            heartRateList.length > 0) {
          int hRate = 0;
          for (int i = 0; i < heartRateList.length; i++) {
            hRate = hRate + heartRateList.elementAt(i);
          }
          if (hRate > 0) {
            callAPI(macAddress, "heartRate",
                (hRate / heartRateList.length).round().toString());
          }
        }
      }

      if (startCount == 1 && spo2Count == 0) {
        print(
            "###########################Inside BloodOxygen reading **********");
        bloodOxygenList = [];
        await _readBloodOxygen();
        ++spo2Count;
        ++startCount;

        if (macAddress != null &&
            bloodOxygenList != null &&
            bloodOxygenList.length > 0) {
          int blood = 0;
          for (int i = 0; i < bloodOxygenList.length; i++) {
            blood = blood + bloodOxygenList.elementAt(i);
          }
          if (blood > 0) {
            callAPI(macAddress, "bloodOxygen",
                (blood / bloodOxygenList.length).round().toString());
          }
        }
      }

      if (startCount == 2 && hrvCount == 0) {
        print("###########################Inside HRV reading **********");
        hrvList = [];
        await _readHRV();
        ++hrvCount;
        ++startCount;

        if (macAddress != null && hrvList != null && hrvList.length > 0) {
          int hrv = 0;
          for (int i = 0; i < hrvList.length; i++) {
            hrv = hrv + hrvList.elementAt(i);
          }
          if (hrv > 0) {
            callAPI(
                macAddress, "hrv", (hrv / hrvList.length).round().toString());
          }
        }
      }

      if (startCount == 3 && tempCount == 0) {
        print("###########################Inside Body Temp reading **********");
        bodyTempList = [];
        await _readTemperature();
        ++tempCount;
        ++startCount;

        if (macAddress != null &&
            bodyTempList != null &&
            bodyTempList.length > 0) {
          int temp = 0;
          for (int i = 0; i < bodyTempList.length; i++) {
            temp = temp + bodyTempList.elementAt(i);
          }
          if (temp > 0) {
            callAPI(macAddress, "bodyTemp",
                (temp / bodyTempList.length).round().toString());
          }
        }
      }

      if (stopCount == 0 && startCount == 4) {
        print("###########################Inside Reset readings **********");
        heartCount = 0;
        spo2Count = 0;
        hrvCount = 0;
        tempCount = 0;
        startCount = 0;
        ++stopCount;

        await Future.delayed(Duration(minutes: 1));
      }
    }
  }

  void commonListener() {
    rxCharacteristic.value.listen((value) async {
      if (value.isNotEmpty && value[0] == 0x28) {
        //Heart Reading
        if (value.isNotEmpty && value[1] == 2) {
          int heartRate = value[2];
          print("Heart Rate Value: $heartRate");
          onMeasurementUpdate({'heartRate': heartRate});
          if (heartRate > 0) heartRateList.add(heartRate);
          print("HeartRate List #################: $heartRateList");
        }

        //HRV Reading
        if (value.isNotEmpty && value[1] == 1) {
          int hrv = value[4];
          print("HRV Value: $hrv");
          onMeasurementUpdate({'hrv': hrv});
          if (hrv > 0) hrvList.add(hrv);
        }

        //BoodOxygen Reading
        if (value.isNotEmpty && value[1] == 3) {
          int bloodOxygen = value[3];
          print("Blood Oxygen Value: $bloodOxygen");
          onMeasurementUpdate({'bloodOxygen': bloodOxygen});
          if (bloodOxygen > 0) bloodOxygenList.add(bloodOxygen);
        }

        //Body Temperature Reading
        if (value.isNotEmpty && value[1] == 4) {
          int temperature = value[8];
          print("Temperature Value: $temperature");
          onMeasurementUpdate({'temperature': temperature});
          if (temperature > 0) bodyTempList.add(temperature);
        }
      }
      // await Future.delayed(Duration(seconds: 10));
    });
  }

  Future<void> _readHeartRate() async {
    print("Starting heart rate measurement");
    List<int> command = createCommand(0x02, 0x01); // Command to read heart rate
    await txCharacteristic.write(command);
    print("Sent command to read heart rate");
    commonListener();
    await Future.delayed(Duration(minutes: 1));
    await _stopMeasurement(0x02);
  }

  Future<void> _readHRV() async {
    print("Starting HRV measurement");
    List<int> command = createCommand(0x01, 0x01); // Command to read HRV
    await txCharacteristic.write(command);
    print("Sent command to read HRV");
    commonListener();

    await Future.delayed(Duration(seconds: 59));
    await _stopMeasurement(0x01);
  }

  Future<void> _readBloodOxygen() async {
    print("Starting blood oxygen measurement");
    List<int> command =
        createCommand(0x03, 0x01); // Command to read blood oxygen
    await txCharacteristic.write(command);
    print("Sent command to read blood oxygen");
    commonListener();

    await Future.delayed(Duration(seconds: 60));
    await _stopMeasurement(0x03);
  }

  Future<void> _readTemperature() async {
    print("Starting temperature measurement");
    List<int> command =
        createCommand(0x04, 0x01); // Command to read temperature
    await txCharacteristic.write(command);
    print("Sent command to read temperature");
    commonListener();

    await Future.delayed(Duration(seconds: 10));
    await _stopMeasurement(0x04);
  }

  Future<void> _stopMeasurement(int measurement) async {
    print("Stopping measurement for $measurement");
    List<int> command =
        createCommand(measurement, 0x00); // Command to stop measurement
    await txCharacteristic.write(command);
    print("Sent command to stop measurement for $measurement");
  }

  List<int> createCommand(int measurementType, int startStopInd) {
    List<int> value = List.filled(16, 0);
    value[0] = 0x28; // Command to measure
    value[1] = measurementType;
    value[2] = startStopInd; // 0x01 to start measurement, 0x00 to stop

    // Compute CRC and set the last byte
    int crc = CrcCalculator.calculateCRC(value);
    value[value.length - 1] = crc;

    return value;
  }

  Future<String> callAPI(
      String deviceMacId, String readingType, String value) async {
    print("Calling API for $readingType with value $value");
    var now = DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);

    try {
      final response = await http.post(
        Uri.parse('https://usmiley-telemetry.onrender.com/api/v1/$readingType'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': deviceMacId,
          'date': formatted,
          readingType: value,
        }),
      );

      if (response.statusCode == 200) {
        print("API Call for $readingType Successful");
        return "Success";
      } else {
        print("API Call for $readingType Failed");
        return "Failure";
      }
    } catch (Exception) {
      print("Exception while calling API");
      return "Failure";
    }
  }
}
