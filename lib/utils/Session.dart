import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'Consts.dart';

var cj = new CookieJar();

class Session {
  static HttpClient client = new HttpClient();
  // ..badCertificateCallback = (_certificateCheck);

  static Future<String> apiGet(String url) async {
    HttpClientRequest request = await client.getUrl(Uri.parse(url));

   // _setHeadersCookies(request, url);

    HttpClientResponse response = await request.close();

    //_updateCookies(response, url);

    return await response.transform(utf8.decoder).join();
  }

  static Future<String> apiPost(String url, dynamic data) async {
    HttpClientRequest request = await client.postUrl(Uri.parse(url));

    _setHeadersCookies(request, url);

    request.add(utf8.encode(json.encode(data)));
    HttpClientResponse response = await request.close();

    _updateCookies(response, url);

    return await response.transform(utf8.decoder).join();
  }

  static Future<void> _setHeadersCookies(HttpClientRequest request, String url) async {
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer ' + Consts.token);
    request.headers.set('UserID', Consts.UserID);
    request.cookies.addAll(await cj.loadForRequest(Uri.parse(url)));
   // request.cookies.addAll(cj.loadForRequest(Uri.parse(url)));
  }

  /*var cj=CookieJar();

  request = await httpClient.openUrl(options.method, uri);
  request.cookies.addAll(await cj.loadForRequest(uri));
  response = await request.close();
  await cj.saveFromResponse(uri, response.cookies);*/

  static void _updateCookies(HttpClientResponse response, String url) {
    cj.saveFromResponse(Uri.parse(url), response.cookies);
  }

  static bool _certificateCheck(X509Certificate cert, String host, int port) =>
      true;
}
