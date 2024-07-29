import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanScreen extends StatefulWidget {
  final Function(fbp.BluetoothDevice) onDeviceSelected;

  const ScanScreen({Key? key, required this.onDeviceSelected})
      : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final fbp.FlutterBluePlus _flutterBlue = fbp.FlutterBluePlus();
  List<fbp.ScanResult> _scanResults = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    fbp.FlutterBluePlus.startScan(timeout: Duration(seconds: 25));
    fbp.FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        String pName;
        // print("Scan Screen Result ##################$results");
        for (int i = 0; i < results.length; i++) {
          pName = results[i].device.platformName;
          print("Platform Name **************** : $pName");
          if (pName != null && pName.startsWith("J")) {
            //results.remove(i);
            _scanResults.addOrUpdate(results[i]);
          }
        }
        //_scanResults = results;
      });
    });
  }

  @override
  void dispose() {
    fbp.FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan for Devices')),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          var result = _scanResults[index];
          return ListTile(
            title: Text(result.device.name),
            subtitle: Text(result.device.id.toString()),
            onTap: () => widget.onDeviceSelected(result.device),
          );
        },
      ),
    );
  }
}
