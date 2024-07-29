// models/measurement_model.dart
class Measurement {
  String? deviceMacId;
  String? readingType;
  int? value;

  Measurement({this.deviceMacId, this.readingType, this.value});

  Map<String, dynamic> toJson() {
    return {
      'deviceMacId': deviceMacId,
      'readingType': readingType,
      'value': value,
    };
  }

  // Add other methods and constructors as needed
}
