import 'package:shared_preferences/shared_preferences.dart';

Future<bool> set_userId(String user_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('user_id', user_id);
}

Future get_userId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String user_id = prefs.getString('user_id') ?? "null";

  return user_id;
}
