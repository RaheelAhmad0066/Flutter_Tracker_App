import 'package:flutter/material.dart';

const Color MAPS_IMAGES_COLOR = Color(0xFF0a4349);
const Color YELLOW_CUSTOM = Color(0xffFFAC00);

class CustomColor {
  static var primaryColor = MaterialColor(0xff48A86B, color);
  // Color(0xff25D366); //MaterialColor(0xFF315378, color);
  static var secondaryColor = Colors.white;
  static var onColor = Colors.lightBlue;
  static var offColor = Colors.grey;
}

Map<int, Color> color = {
  50: Color.fromRGBO(75, 132, 160, .1),
  100: Color.fromRGBO(75, 132, 160, .2),
  200: Color.fromRGBO(75, 132, 160, .3),
  300: Color.fromRGBO(75, 132, 160, .4),
  400: Color.fromRGBO(75, 132, 160, .5),
  500: Color.fromRGBO(75, 132, 160, .6),
  600: Color.fromRGBO(75, 132, 160, .7),
  700: Color.fromRGBO(75, 132, 160, .8),
  800: Color.fromRGBO(75, 132, 160, .9),
  900: Color.fromRGBO(75, 132, 160, 1),
};
