import 'dart:convert';

import 'package:elderacare/features/heartStats/model/heartrateresponse.dart';

HeartRateResponse parseStaticData() {
  const String jsonData = '''
  {
    "status": "SUCCESS",
    "data": {
      "heartRate": {
        "current": "72",
        "unit": "bpm",
        "timestamp": "2024-07-12T14:00:00Z",
        "details": {
          "weekly": [
            {
              "average": "75",
              "highest": "79",
              "lowest": "72",
              "trend": "NORMAL",
              "dailyBreakdown": [
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                }
              ]
            },
            {
              "average": "78",
              "highest": "80",
              "lowest": "74",
              "trend": "MODERATE",
              "dailyBreakdown": [
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                }
              ]
            },
            {
              "average": "80",
              "highest": "83",
              "lowest": "75",
              "trend": "HIGH",
              "dailyBreakdown": [
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                }
              ]
            },
            {
              "average": "77",
              "highest": "81",
              "lowest": "73",
              "trend": "NORMAL",
              "dailyBreakdown": [
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                },
                {
                  "date": "2024-07-05",
                  "average": "72",
                  "highest": "80",
                  "lowest": "65"
                }
              ]
            }
          ]
        }
      }
    }
  }
  ''';

  final Map<String, dynamic> jsonMap = jsonDecode(jsonData);
  return HeartRateResponse.fromJson(jsonMap);
}
