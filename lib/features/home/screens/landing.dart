import 'package:elderacare/controllers/paramete_controller.dart';
import 'package:elderacare/features/heartStats/views/status_Screen.dart';
import 'package:elderacare/features/home/components/expandable_card.dart';
import 'package:elderacare/features/home/widgets/dynamic_health_inidcator.dart';
import 'package:elderacare/features/home/widgets/training_card.dart';
import 'package:elderacare/features/scan/views/scan_screen.dart';
import 'package:elderacare/utils/app_colors.dart';
import 'package:elderacare/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:elderacare/features/home/components/profile_points.dart';
import 'package:elderacare/utils/font_sizes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ParameterController parameterController =
      Get.put(ParameterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.black,
            fontSize: FontSizes.title,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(HugeIcons.strokeRoundedBluetoothSearch),
        //     onPressed: () {
        //       Get.to(() => ScanScreen()); // Navigate to ScanScreen
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ProfilePointsCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(
                  child: InfoCard(
                    label: 'Weight',
                    value: '64.5 kg',
                    backgroundColor: Color(0xFFB3EAFA),
                  ),
                ),
                Expanded(
                  child: InfoCard(
                    label: 'Height',
                    value: '5.10 ft',
                    backgroundColor: Color(0xFFFDE191),
                  ),
                ),
                Expanded(
                  child: InfoCard(
                    label: 'Age',
                    value: '27',
                    backgroundColor: Color(0xFFFEE2D1),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Obx(() {
                        if (parameterController.currentParameters.value ==
                            null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var params =
                            parameterController.currentParameters.value;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You\'re doing great!',
                              style: TextStyle(
                                  color: AppColors.purple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'All Metrics are in normal range',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(height: 24),
                            GestureDetector(
                              onTap: () {
                                Get.to(SleepStatsScreen());
                              },
                              child: DynamicHealthIndicator(
                                icon: HugeIcons.strokeRoundedPulse01,
                                value: '${params!.heartRate} bpm',
                                label: 'Heart Rate',
                                iconBackgroundColor: AppColors.pink,
                                valueColor: Colors.black,
                                labelColor: AppColors.purple,
                              ),
                            ),
                            SizedBox(height: 16),
                            DynamicHealthIndicator(
                              icon: HugeIcons.strokeRoundedBlood,
                              value: '${params.bloodOxygen} %',
                              label: 'Blood Oxygen',
                              iconBackgroundColor: Color(0xFFFDE191),
                              valueColor: Colors.black,
                              labelColor: AppColors.purple,
                            ),
                            SizedBox(height: 16),
                            DynamicHealthIndicator(
                              icon: HugeIcons.strokeRoundedHealtcare,
                              value: '${params.hrv}',
                              label: 'Hrv',
                              iconBackgroundColor: AppColors.purple,
                              valueColor: Colors.black,
                              labelColor: AppColors.purple,
                            ),
                            SizedBox(height: 16),
                            DynamicHealthIndicator(
                              icon: HugeIcons.strokeRoundedTemperature,
                              value: '${params.bodyTemp} °F',
                              label: 'Temperature',
                              iconBackgroundColor: Color(0xffB6C7AA),
                              valueColor: Colors.black,
                              labelColor: AppColors.purple,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        StatsCard(
                          count: 0.0,
                          description: 'Stress Value',
                        ),
                        SizedBox(height: 16),
                        StatsCard(
                          count: 0.0,
                          description: 'Sleep Hours',
                        ),
                        SizedBox(height: 16),
                        StatsCard(
                          count: 0.0,
                          description: 'Water Intake',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(), // Add the CustomBottomNavBar
    );
  }
}
