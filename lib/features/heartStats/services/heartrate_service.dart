import 'dart:convert';
import 'package:elderacare/features/heartStats/model/heartrate_pred.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://64.227.190.46:5000';

  Future<HeartRateResponse> fetchHeartRate() async {
    final prefs = await SharedPreferences.getInstance();
    final macAddress = prefs.getString('mac_address');

    if (macAddress == null) {
      throw Exception("MAC address not found in shared preferences");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/heart_rate'),
      headers: {'Content-Type': 'application/json', 'mac_address': macAddress},
      //  jsonEncode({'mac_address': macAddress}),
    );
    print(response.body);

    if (response.statusCode == 200) {
      return HeartRateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load heart rate data');
    }
  }
}
