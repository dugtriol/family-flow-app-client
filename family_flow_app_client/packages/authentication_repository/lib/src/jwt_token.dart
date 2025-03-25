import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveJwtToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getJwtToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> removeJwtToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}
