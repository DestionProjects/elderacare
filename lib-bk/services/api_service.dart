import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      "https://usmiley-telemetry.onrender.com/api/v1/dashBoardInfo1";
  final Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8"
  };

  Future<Map<String, String>> fetchData(String deviceId) async {
    final Map<String, String> dataMap = {};

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({"id": deviceId}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      dataMap['heartRate'] = jsonResponse['heartRate'] ?? 'N/A';
      dataMap['bloodOxygen'] = jsonResponse['bloodOxygen'] ?? 'N/A';
      dataMap['stress'] = jsonResponse['stress'] ?? 'N/A';
      dataMap['hrv'] = jsonResponse['hrv'] ?? 'N/A';
      dataMap['bodyTemp'] = jsonResponse['bodyTemp'] ?? 'N/A';
      dataMap['bloodPressure'] = jsonResponse['bloodPressure'] ?? 'N/A';
    } else {
      throw Exception('Failed to load data');
    }

    return dataMap;
  }
}
