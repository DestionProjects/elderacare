// services/bluetooth_connection_service.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'measurement_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnMacAddressReceived = void Function(String macAddress);
typedef OnMeasurementUpdate = void Function(Map<String, dynamic>);

class BluetoothConnectionService {
  BluetoothCharacteristic? txCharacteristic;
  BluetoothCharacteristic? rxCharacteristic;

  OnMacAddressReceived? onMacAddressReceived;
  OnMeasurementUpdate? onMeasurementUpdate;

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
            _listenForMacAddress();
          }
        }
      }
    }
    if (txCharacteristic != null && rxCharacteristic != null) {
      _startMeasurementService();
    }
  }

  void sendCommandToGetMacAddress() async {
    if (txCharacteristic != null) {
      List<int> command = List.filled(16, 0);
      command[0] = 0x22; // Command to get MAC address
      command[15] = _calculateCRC(command);
      await txCharacteristic!.write(command);
      print("Sent command to get MAC address");
    } else {
      print("TX Characteristic not found.");
    }
  }

  void _listenForMacAddress() {
    rxCharacteristic?.value.listen((value) async {
      if (value.isNotEmpty && value[0] == 0x22) {
        String macAddress = value
            .sublist(1, 7)
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':');
        print("MAC Address: $macAddress");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mac_address', macAddress);

        if (onMacAddressReceived != null) {
          onMacAddressReceived!(macAddress);
        }
      }
    });
    rxCharacteristic?.setNotifyValue(true);
  }

  Future<void> _startMeasurementService() async {
    final prefs = await SharedPreferences.getInstance();
    String? macAddress = prefs.getString('mac_address');

    if (macAddress == null) {
      print("MAC Address not found in storage.");
      return;
    }

    if (txCharacteristic != null && rxCharacteristic != null) {
      final measurementService = MeasurementService(
        txCharacteristic: txCharacteristic!,
        rxCharacteristic: rxCharacteristic!,
        onMeasurementUpdate: (data) {
          if (onMeasurementUpdate != null) {
            onMeasurementUpdate!(data);
          }
          print("Measurement data: $data");
        },
      );
      measurementService.startMeasurements();
    } else {
      print("Cannot start measurement service, characteristics not found.");
    }
  }

  static int _calculateCRC(List<int> data) {
    int crc = 0;
    for (int byte in data) {
      crc = (crc + byte) & 0xFF;
    }
    return crc;
  }
}
