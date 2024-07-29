// controllers/parameter_controller.dart
import 'dart:async';

import 'package:elderacare/models/prameters.dart';
import 'package:elderacare/services/parameters_api.dart';
import 'package:get/get.dart';

class ParameterController extends GetxController {
  final ParameterService parameterService = ParameterService();
  final Rx<ParameterModel?> currentParameters = Rx<ParameterModel?>(null);
  final int fetchInterval = 5; // in seconds

  @override
  void onInit() {
    super.onInit();
    fetchLatestParameters();
    startFetching();
  }

  void fetchLatestParameters() async {
    final parameters = await parameterService.fetchData();
    if (parameters != null) {
      currentParameters.value = parameters;
    }
  }

  void startFetching() {
    Timer.periodic(Duration(seconds: fetchInterval), (timer) {
      fetchLatestParameters();
    });
  }
}
