class HeartRateResponse {
  final int heartRate;
  final String prediction;
  final DateTime time;

  HeartRateResponse({
    required this.heartRate,
    required this.prediction,
    required this.time,
  });

  factory HeartRateResponse.fromJson(Map<String, dynamic> json) {
    return HeartRateResponse(
      heartRate: json['heart_rate'],
      prediction: json['prediction'],
      time: DateTime.parse(json['time']),
    );
  }
}
