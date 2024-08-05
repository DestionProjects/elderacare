// services/parameter_service.dart
import 'dart:convert';
import 'package:elderacare/models/prameters.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ParameterService {
  final String baseUrl =
      "https://usmiley-telemetry.onrender.com/api/v1/dashBoardInfo1";
  final Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8"
  };

  Future<ParameterModel?> fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? macAddress = prefs.getString('mac_address');

      if (macAddress == null) {
        print('MAC Address not found---------');
        return null;
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({"id": macAddress}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return ParameterModel.fromJson(jsonResponse);
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
