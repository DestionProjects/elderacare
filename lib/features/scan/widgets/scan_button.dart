// features/scan/widgets/scan_button.dart

import 'package:flutter/material.dart';

class ScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onPressed;

  const ScanButton({
    Key? key,
    required this.isScanning,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: isScanning ? const Icon(Icons.stop) : const Text("SCAN"),
      onPressed: onPressed,
      backgroundColor: isScanning ? Colors.red : Colors.blue,
    );
  }
}
