// models/parameter_model.dart
class ParameterModel {
  final String heartRate;
  final String bloodOxygen;
  final String stress;
  final String hrv;
  final String bodyTemp;
  final String bloodPressure;

  ParameterModel({
    required this.heartRate,
    required this.bloodOxygen,
    required this.stress,
    required this.hrv,
    required this.bodyTemp,
    required this.bloodPressure,
  });

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      heartRate: json['heartRate']?.toString() ?? 'Reading...',
      bloodOxygen: json['bloodOxygen']?.toString() ?? 'Reading...',
      stress: json['stress']?.toString() ?? 'Reading...',
      hrv: json['hrv']?.toString() ?? 'Reading...',
      bodyTemp: json['bodyTemp']?.toString() ?? 'Reading...',
      bloodPressure: json['bloodPressure']?.toString() ?? 'Reading...',
    );
  }
}
