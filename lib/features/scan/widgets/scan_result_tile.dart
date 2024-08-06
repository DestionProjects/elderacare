import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({
    Key? key,
    required this.result,
    this.onTap,
  }) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
      setState(() {
        _connectionState = state;
      });
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get _isConnected =>
      _connectionState == BluetoothConnectionState.connected;

  Widget _buildTitle(BuildContext context) {
    final device = widget.result.device;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(device.name.isNotEmpty ? device.name : device.id.toString()),
        Text(device.id.toString(),
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      child: Text(_isConnected ? 'Details' : 'CONNECT'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed:
          widget.result.advertisementData.connectable ? widget.onTap : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adv = widget.result.advertisementData;
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(widget.result.rssi.toString()),
      trailing: _buildConnectButton(context),
      children: [
        if (adv.localName.isNotEmpty)
          _buildAdvRow(context, 'Name', adv.localName),
        if (adv.txPowerLevel != null)
          _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
        if ((adv.appearance ?? 0) > 0)
          _buildAdvRow(
              context, 'Appearance', '0x${adv.appearance!.toRadixString(16)}'),
        if (adv.manufacturerData.isNotEmpty)
          _buildAdvRow(context, 'Manufacturer Data',
              _formatHexArray(adv.manufacturerData)),
        if (adv.serviceUuids.isNotEmpty)
          _buildAdvRow(
              context, 'Service UUIDs', _formatServiceUuids(adv.serviceUuids)),
        if (adv.serviceData.isNotEmpty)
          _buildAdvRow(
              context, 'Service Data', _formatServiceData(adv.serviceData)),
      ],
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.black),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHexArray(Map<int, List<int>> bytes) {
    return bytes.entries
        .map((entry) => entry.value
            .map((i) => i.toRadixString(16).padLeft(2, '0'))
            .join(', '))
        .join(', ')
        .toUpperCase();
  }

  String _formatServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${_formatHexArray({v.key.hashCode: v.value})}')
        .join(', ')
        .toUpperCase();
  }

  String _formatServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }
}
