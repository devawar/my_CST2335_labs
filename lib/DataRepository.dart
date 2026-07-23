import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String loginName = "";
  static String firstName = "";
  static String lastName = "";
  static String phoneNumber = "";
  static String emailAddress = "";

  static Future<void> loadData() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    DataRepository.firstName    = await prefs.getString("firstName");
    DataRepository.lastName     = await prefs.getString("lastName");
    DataRepository.phoneNumber  = await prefs.getString("phoneNumber");
    DataRepository.emailAddress = await prefs.getString("emailAddress");
  }

  static Future<void> saveData() async {
    EncryptedSharedPreferences prefs = EncryptedSharedPreferences();
    await prefs.setString("firstName",    DataRepository.firstName);
    await prefs.setString("lastName",     DataRepository.lastName);
    await prefs.setString("phoneNumber",  DataRepository.phoneNumber);
    await prefs.setString("emailAddress", DataRepository.emailAddress);
  }
}