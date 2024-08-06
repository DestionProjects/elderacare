class HeartRateResponse {
  final String status;
  final HeartRateData data;

  HeartRateResponse({
    required this.status,
    required this.data,
  });

  factory HeartRateResponse.fromJson(Map<String, dynamic> json) {
    return HeartRateResponse(
      status: json['status'],
      data: HeartRateData.fromJson(json['data']),
    );
  }
}

class HeartRateData {
  final HeartRateDetails heartRate;

  HeartRateData({
    required this.heartRate,
  });

  factory HeartRateData.fromJson(Map<String, dynamic> json) {
    return HeartRateData(
      heartRate: HeartRateDetails.fromJson(json['heartRate']),
    );
  }
}

class HeartRateDetails {
  final String current;
  final String unit;
  final String timestamp;
  final List<WeeklyDetails> weekly;

  HeartRateDetails({
    required this.current,
    required this.unit,
    required this.timestamp,
    required this.weekly,
  });

  factory HeartRateDetails.fromJson(Map<String, dynamic> json) {
    var list = json['details']['weekly'] as List;
    List<WeeklyDetails> weeklyList =
        list.map((i) => WeeklyDetails.fromJson(i)).toList();

    return HeartRateDetails(
      current: json['current'],
      unit: json['unit'],
      timestamp: json['timestamp'],
      weekly: weeklyList,
    );
  }
}

class WeeklyDetails {
  final String average;
  final String highest;
  final String lowest;
  final String trend;
  final List<DailyBreakdown> dailyBreakdown;

  WeeklyDetails({
    required this.average,
    required this.highest,
    required this.lowest,
    required this.trend,
    required this.dailyBreakdown,
  });

  factory WeeklyDetails.fromJson(Map<String, dynamic> json) {
    var list = json['dailyBreakdown'] as List;
    List<DailyBreakdown> dailyList =
        list.map((i) => DailyBreakdown.fromJson(i)).toList();

    return WeeklyDetails(
      average: json['average'],
      highest: json['highest'],
      lowest: json['lowest'],
      trend: json['trend'],
      dailyBreakdown: dailyList,
    );
  }
}

class DailyBreakdown {
  final String date;
  final String average;
  final String highest;
  final String lowest;

  DailyBreakdown({
    required this.date,
    required this.average,
    required this.highest,
    required this.lowest,
  });

  factory DailyBreakdown.fromJson(Map<String, dynamic> json) {
    return DailyBreakdown(
      date: json['date'],
      average: json['average'],
      highest: json['highest'],
      lowest: json['lowest'],
    );
  }
}
