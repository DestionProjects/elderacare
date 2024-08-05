// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elderacare/features/heartStats/controller/heartrate_controller.dart';
import 'package:elderacare/features/home/widgets/points_indicator.dart';
import 'package:elderacare/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePointsCard extends StatelessWidget {
  final HeartRateController heartRateController =
      Get.put(HeartRateController());

  ProfilePointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 100, // Set your desired height
              decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius:
                    BorderRadius.circular(24), // Adjusted for better curvature
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      24), // Smaller radius inside the padding
                  color: AppColors
                      .pink, // Optional: for better visibility of the image boundary
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      24), // Clipping the image to the border radius
                  child: Image.asset(
                    'assets/images/user.png',
                    fit: BoxFit
                        .contain, // Using BoxFit.cover to fill the area without distorting the image
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: Container(
              height: 100, // Set your desired height
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.blue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Text(
                      '${heartRateController.heartRateResponse.value.heartRate}',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Heart Rate',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Your predicted heart rate value',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
