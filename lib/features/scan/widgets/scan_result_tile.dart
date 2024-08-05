import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({
    Key? key,
    required this.result,
    this.onTap,
    this.onDeviceConnected,
  }) : super(key: key);

  final ScanResult result;
  final VoidCallback? onTap;
  final VoidCallback? onDeviceConnected;

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
        print('Connection State: $_connectionState'); // Debug print

        if (_isConnected && widget.onDeviceConnected != null) {
          print(
              'Device connected: ${widget.result.device.remoteId.str}'); // Debug print
          widget.onDeviceConnected!();
        }

        if (!_isConnected) {
          print(
              'Device disconnected: ${widget.result.device.remoteId.str}'); // Debug print
        }
      });
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String _formatHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String _formatManufacturerData(List<List<int>> data) {
    return data.map((val) => _formatHexArray(val)).join(', ').toUpperCase();
  }

  String _formatServiceData(Map<Guid, List<int>> data) {
    return data.entries
        .map((v) => '${v.key}: ${_formatHexArray(v.value)}')
        .join(', ')
        .toUpperCase();
  }

  String _formatServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get _isConnected =>
      _connectionState == BluetoothConnectionState.connected;

  Widget _buildTitle(BuildContext context) {
    final device = widget.result.device;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (device.platformName.isNotEmpty) ...[
          Text(
            device.platformName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            device.remoteId.str,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else
          Text(device.remoteId.str),
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

  @override
  Widget build(BuildContext context) {
    final adv = widget.result.advertisementData;
    return ExpansionTile(
      title: _buildTitle(context),
      leading: Text(widget.result.rssi.toString()),
      trailing: _buildConnectButton(context),
      children: [
        if (adv.advName.isNotEmpty) _buildAdvRow(context, 'Name', adv.advName),
        if (adv.txPowerLevel != null)
          _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
        if ((adv.appearance ?? 0) > 0)
          _buildAdvRow(
              context, 'Appearance', '0x${adv.appearance!.toRadixString(16)}'),
        if (adv.msd.isNotEmpty)
          _buildAdvRow(
              context, 'Manufacturer Data', _formatManufacturerData(adv.msd)),
        if (adv.serviceUuids.isNotEmpty)
          _buildAdvRow(
              context, 'Service UUIDs', _formatServiceUuids(adv.serviceUuids)),
        if (adv.serviceData.isNotEmpty)
          _buildAdvRow(
              context, 'Service Data', _formatServiceData(adv.serviceData)),
      ],
    );
  }
}
