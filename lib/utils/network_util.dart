import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//this network util class will wrap get and post request and will also handle encoding and decoding
//of json. notice how get and post return future's, this is exactly why Dart is beautiful.
//Asynchronously beautiful.

class NetworkUtil {
  //next three lines makes this class a singleton class
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url){
    return http.get(Uri.parse(url)).then((http.Response response){
      final String res = response.body;
      final int statusCode = response.statusCode;

      if(statusCode<200 || statusCode>400 || json == null){
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
  static Map<String, String> headers = {};
  Future<dynamic> post(String url, {headers, body, encoding}){
    return http
        .post(Uri.parse(url), body: body, headers: headers, encoding: encoding)
        .then((http.Response response){

          final String res = response.body;
          final int statusCode = response.statusCode;
          if(statusCode<200 || statusCode>400 || json == null){
            throw new Exception("Error while fetching data");
          }
          return _decoder.convert(res);
    });
  }
}