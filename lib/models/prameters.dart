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
      heartRate: json['heartRate']?.toString() ?? 'N/A',
      bloodOxygen: json['bloodOxygen']?.toString() ?? 'N/A',
      stress: json['stress']?.toString() ?? 'N/A',
      hrv: json['hrv']?.toString() ?? 'N/A',
      bodyTemp: json['bodyTemp']?.toString() ?? 'N/A',
      bloodPressure: json['bloodPressure']?.toString() ?? 'N/A',
    );
  }
}
