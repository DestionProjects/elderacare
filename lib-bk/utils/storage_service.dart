import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _macAddressKey = 'mac_address';

  Future<void> storeMacAddress(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_macAddressKey, macAddress.replaceAll(":", "-"));
  }

  Future<String?> retrieveMacAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_macAddressKey);
  }
}
