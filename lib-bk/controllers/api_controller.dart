// import 'package:elderacare/services/api_service.dart';
// import 'package:get/get.dart';

// class ApiController extends GetxController {
//   final ApiService _apiService = ApiService();
//   var data = <String, String>{}.obs;
//   var errorMessage = ''.obs;
//   var isLoading = false.obs;

//   Future<void> fetchData(String deviceId) async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       data.value = await _apiService.fetchData(deviceId);
//       print(data);
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
