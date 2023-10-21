import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class theme_changer_provider with ChangeNotifier{

  var _themeMode =ThemeMode.light;
  ThemeMode get thememode => _themeMode;

  void setTheme(thememode){
    _themeMode =thememode;
    notifyListeners();
  }

}