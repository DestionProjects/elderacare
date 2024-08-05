import 'package:flutter/material.dart';

class DynamicHealthIndicator extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconBackgroundColor;
  final Color valueColor;
  final Color labelColor;

  const DynamicHealthIndicator({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconBackgroundColor,
    required this.valueColor,
    required this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                  color: valueColor, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              label,
              style: TextStyle(
                  color: labelColor, fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }
}
