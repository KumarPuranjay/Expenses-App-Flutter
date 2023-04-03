import 'package:expenses_app/constants/key_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessSharedPreferences{

  Future<int?> accessExpenseItemCount() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keySharedPref);
  }

  Future<void> setExpenseItemCount(int value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keySharedPref, value);
  }

}