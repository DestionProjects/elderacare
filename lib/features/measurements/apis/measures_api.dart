// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Ensure this import for date formatting

class MeasureApiService {
  static const String _baseUrl =
      'https://usmiley-telemetry.onrender.com/api/v1';

  Future<String> sendMeasurement(
      String deviceMacId, String readingType, String value) async {
    print("Preparing to call API for $readingType with value $value");
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    try {
      print("Sending request to $_baseUrl/$readingType");
      final response = await http.post(
        Uri.parse('$_baseUrl/$readingType'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': deviceMacId,
          'date': formattedDate,
          readingType: value,
        }),
      );

      print("API Response Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("API Call for $readingType Successful: ${response.body}");
        return "Success";
      } else {
        print("API Call for $readingType Failed: ${response.body}");
        return "Failure";
      }
    } catch (e) {
      print("Exception while calling API: $e");
      return "Failure";
    }
  }
}
