import 'package:elderacare/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: 135,
            height: 88,
            child: CircularProgressIndicator(
              value: 0.92, // Assuming 92% progress
              strokeWidth: 4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: AppColors.purple,
        shape: BoxShape.circle,
      ),
    );
  }
}
