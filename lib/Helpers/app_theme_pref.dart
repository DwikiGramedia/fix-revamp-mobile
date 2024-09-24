import 'package:revamp_eperpus_mobile/Helpers/util_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

const themeStatus = 'themeStatus';

Future<void> setAppTheme(int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(themeStatus, value);
}

Future<int?> getAppTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(themeStatus) ?? lightAppTheme;
}
