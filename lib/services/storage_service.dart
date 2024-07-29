// services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _macAddressKey = 'mac_address';

  Future<void> saveMacAddress(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_macAddressKey, macAddress);
  }

  Future<String?> getMacAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_macAddressKey);
  }
}
