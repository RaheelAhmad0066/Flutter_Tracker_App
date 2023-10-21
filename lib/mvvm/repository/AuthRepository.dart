


import 'package:maktrogps/mvvm/data/network/BaseApiService.dart';
import 'package:maktrogps/mvvm/data/network/NetworkApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/static.dart';
import '../../data/model/loginModel.dart';

class AuthRepository{

  BaseApiService apiService =NetworkApiService();
  final LOGIN_URL = StaticVarMethod.baseurlall + "/api/login";

  Future<dynamic> loginApi(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic response= await apiService.getGetApiResponse(LOGIN_URL+"?email=$email&password=$password");


    var res= LoginModel.fromJson(response);
    StaticVarMethod.user_api_hash=res.userApiHash;

    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool("notival", true);


  }

}