import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequiredHelp extends ChangeNotifier {
  // static String _help_type = "";
  static String _userDetails = "";
  static int _index = 0;
  RequiredHelp() {
    loadRequiredHelp();
  }
  int get contactsIndex => _index;
  String get userInfo => _userDetails;
  Function get init => setInitialValues;
  Function get setHelpstate => setPrefs;
  void setInitialValues(String userDetails, int index) {
    _userDetails = userDetails;
    if (index != -1) {
      _index = index;
    }
    saveRequiredHelp();
  }

  Future setPrefs(String userDetails, int index) async {
    _userDetails = userDetails;
    if (index != -1) {
      _index = index;
    }
    notifyListeners();
    await saveRequiredHelp();
  }

  Future saveRequiredHelp() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('userDetails', _userDetails);
      prefs.setInt('index', _index);
    });
  }

  void loadRequiredHelp() {
    SharedPreferences.getInstance().then((prefs) {
      _userDetails = prefs.getString('userDetails') ?? "";
      _index = prefs.getInt('index') ?? 0;
      notifyListeners();
    });
  }
}
