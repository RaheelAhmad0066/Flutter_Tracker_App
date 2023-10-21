import 'dart:convert';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/gpsserver/model/devicesdata.dart';
import 'package:maktrogps/data/model/PositionHistory.dart';
import 'package:maktrogps/data/model/events.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:maktrogps/utils/Session.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;

class gpsserverapis{

  static final BASE_URL = "";

  static final ServerURL = BASE_URL + "/api/api.php?api=server&ver=1.0&key=2C805608B18ED88096531BC30C8F1008&cmd=";
  static final UserURL = BASE_URL + "/api/api.php?api=user";





  static Map<String, String> headers = {};


  static Future<http.Response?> login(email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(
          BASE_URL + "/login.php?username=abc@gmail.com&password=demo123456&mobile=false"));

      if (response.statusCode == 200) {
        if(response.body !="ERROR_USERNAME_PASSWORD_INCORRECT") {
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        }
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }


  static Future<http.Response> getuserloginapikey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        ServerURL + "GET_USER_API_KEY,demo@demo.com")
        , headers: headers);

    var res=response.body;
    print(res);
    await prefs.setString('apikey', response.body);
    return response;
  }



  static Future<List<devicesdata>> getDevicesItems(String? user_api_hash)async {

    final response = await http.get(Uri.parse(UserURL + "&cmd=USER_GET_OBJECTS&key=FE27B8364272A4AAFB5484BA9D9115D7"));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      try {
        List<devicesdata> list = [];
         for (var i = 0; i < jsonData.length; i++) {
           list.add(devicesdata.fromJson(jsonData[i]));
          /* for (var p in devicesdata.fromJson(jsonData[i])) {
           list.add(p);
           }*/
        }
       // list.map((model) => devicesdata.fromJson(jsonData)).toList();
        print(list);
        return list;
      } catch (Ex) {
        print(Ex);
        print("Error occurred");
        List<devicesdata> list = [];
        return list;
      }
    } else {
      print(response.statusCode);
      List<devicesdata> list = [];
      return list;
    }
  }

}






