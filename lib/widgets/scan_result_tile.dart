// import 'dart:async';

// import 'package:elderacare/services/bluetooth_connection_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class ScanResultTile extends StatefulWidget {
//   const ScanResultTile({
//     Key? key,
//     required this.result,
//     this.onTap,
//     required this.bluetoothConnectionService, // Inject the service
//   }) : super(key: key);

//   final ScanResult result;
//   final VoidCallback? onTap;
//   final BluetoothConnectionService bluetoothConnectionService;

//   @override
//   State<ScanResultTile> createState() => _ScanResultTileState();
// }

// class _ScanResultTileState extends State<ScanResultTile> {
//   BluetoothConnectionState _connectionState =
//       BluetoothConnectionState.disconnected;

//   late StreamSubscription<BluetoothConnectionState>
//       _connectionStateSubscription;

//   @override
//   void initState() {
//     super.initState();

//     _connectionStateSubscription =
//         widget.result.device.connectionState.listen((state) {
//       _connectionState = state;
//       if (mounted) {
//         setState(() {});
//       }

//       // Automatically start measurement service if connected
//       if (state == BluetoothConnectionState.connected) {
//         widget.bluetoothConnectionService.startMeasurementService();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _connectionStateSubscription.cancel();
//     super.dispose();
//   }

//   bool get isConnected {
//     return _connectionState == BluetoothConnectionState.connected;
//   }

//   Widget _buildConnectButton(BuildContext context) {
//     return ElevatedButton(
//       child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.black,
//         foregroundColor: Colors.white,
//       ),
//       onPressed: () {
//         if (widget.result.advertisementData.connectable) {
//           if (widget.onTap != null) {
//             widget
//                 .onTap!(); // Call the onTap method if the device is connectable
//           }

//           // Removed the manual call to startMeasurementService
//         } else {
//           // Show a toast message if the device is not connectable
//           Fluttertoast.showToast(
//             msg: "Device is not connectable",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//           );
//         }
//       },
//     );
//   }

//   Widget _buildTitle(BuildContext context) {
//     if (widget.result.device.platformName.isNotEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             widget.result.device.platformName,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             widget.result.device.remoteId.str,
//             style: Theme.of(context).textTheme.bodySmall,
//           )
//         ],
//       );
//     } else {
//       return Text(widget.result.device.remoteId.str);
//     }
//   }

//   Widget _buildAdvRow(BuildContext context, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(title, style: Theme.of(context).textTheme.bodySmall),
//           const SizedBox(width: 12.0),
//           Expanded(
//             child: Text(
//               value,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.apply(color: Colors.black),
//               softWrap: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var adv = widget.result.advertisementData;
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: Text(widget.result.rssi.toString()),
//       trailing: _buildConnectButton(context),
//       children: <Widget>[
//         if (adv.advName.isNotEmpty) _buildAdvRow(context, 'Name', adv.advName),
//         if (adv.txPowerLevel != null)
//           _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
//         if ((adv.appearance ?? 0) > 0)
//           _buildAdvRow(
//               context, 'Appearance', '0x${adv.appearance!.toRadixString(16)}'),
//         if (adv.msd.isNotEmpty)
//           _buildAdvRow(
//               context, 'Manufacturer Data', getNiceManufacturerData(adv.msd)),
//         if (adv.serviceUuids.isNotEmpty)
//           _buildAdvRow(
//               context, 'Service UUIDs', getNiceServiceUuids(adv.serviceUuids)),
//         if (adv.serviceData.isNotEmpty)
//           _buildAdvRow(
//               context, 'Service Data', getNiceServiceData(adv.serviceData)),
//       ],
//     );
//   }

//   String getNiceHexArray(List<int> bytes) {
//     return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
//   }

//   String getNiceManufacturerData(List<List<int>> data) {
//     return data
//         .map((val) => '${getNiceHexArray(val)}')
//         .join(', ')
//         .toUpperCase();
//   }

//   String getNiceServiceData(Map<Guid, List<int>> data) {
//     return data.entries
//         .map((v) => '${v.key}: ${getNiceHexArray(v.value)}')
//         .join(', ')
//         .toUpperCase();
//   }

//   String getNiceServiceUuids(List<Guid> serviceUuids) {
//     return serviceUuids.join(', ').toUpperCase();
//   }
// }
