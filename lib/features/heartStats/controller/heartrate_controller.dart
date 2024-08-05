import 'dart:async';
import 'package:elderacare/features/heartStats/model/heartrate_pred.dart';
import 'package:elderacare/features/heartStats/services/heartrate_service.dart';
import 'package:get/get.dart';

class HeartRateController extends GetxController {
  final ApiService apiService = ApiService();
  var heartRateResponse = HeartRateResponse(
    heartRate: 0,
    prediction: '',
    time: DateTime.now(),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    fetchHeartRateData();
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchHeartRateData();
    });
  }

  Future<void> fetchHeartRateData() async {
    try {
      final response = await apiService.fetchHeartRate();
      heartRateResponse.value = response;
    } catch (e) {
      print('Error fetching heart rate data: $e');
    }
  }
}
