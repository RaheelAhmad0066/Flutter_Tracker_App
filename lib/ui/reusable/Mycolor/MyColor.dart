
import 'package:flutter/material.dart';

class MyColor {

  static var primaryColor = MaterialColor(0xFFe44650, color);
  static var whiteColor = Colors.white;

  static var statusOnColor = Colors.green;
  static var statusOffColor = Colors.red;

  static var INACTIVE_COLOR= Color(0xFF388cb7);
  static var ONLINE_COLOR= Color(0xFF3ad350);
  static var IDLE_COLOR= Color(0xFFfb9739);
  static var STOP_COLOR= Color(0xFFe21b1b);
}

Map<int, Color> color = {
  50: Color.fromRGBO(228, 70, 80, .1),
  100: Color.fromRGBO(228, 70, 80, .2),
  200: Color.fromRGBO(228, 70, 80, .3),
  300: Color.fromRGBO(228, 70, 80, .4),
  400: Color.fromRGBO(228, 70, 80, .5),
  500: Color.fromRGBO(228, 70, 80, .6),
  600: Color.fromRGBO(228, 70, 80, .7),
  700: Color.fromRGBO(228, 70, 80, .8),
  800: Color.fromRGBO(228, 70, 80, .9),
  900: Color.fromRGBO(228, 70, 80, 1),
};