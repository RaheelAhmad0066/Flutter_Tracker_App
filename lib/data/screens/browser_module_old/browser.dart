import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class Browser extends StatefulWidget {
  static final String path = "/browser_module_old/browser.dart";

  String dashboardName = "";
  String dashboardURL = "";

  Browser({Key? key, required this.dashboardName, required this.dashboardURL})
      : super(key: key);

  @override
  _BrowserState createState() =>
      _BrowserState(dashboardName: dashboardName, dashboardURL: dashboardURL);
}

class _BrowserState extends State<Browser> with SingleTickerProviderStateMixin {
  String dashboardName = "";
  String dashboardURL = "";
  String returnUrlVal = "";
  static const primary = Color(0xffD73034);
  final key = new GlobalKey<ScaffoldState>();
  _BrowserState({required this.dashboardName, required this.dashboardURL});

  var _isRestored = false;
  bool status = false;

  @override
  void initState() {
//    status = false;

    super.initState();
  }

  @override
  void dispose() {
    returnUrlVal = "";
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRestored) {
      _isRestored = true;

    }
    precacheImage(AssetImage("assets/images/app_icon.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title:  Text(''+dashboardName,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: primary,
          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.refresh),
//              tooltip: 'Refresh',
//              onPressed: () {},
//            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse(dashboardURL)) // updated

      /*    initialHeaders: {},
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                supportZoom: false, // zoom support
                debuggingEnabled: true,
                preferredContentMode: UserPreferredContentMode.MOBILE), // here you change the mode
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {

          },
          onLoadStop: (InAppWebViewController controller, String url) async {

          },*/
        )
      /*WebView(
          initialUrl: Uri.parse(dashboardURL).toString(),
          javascriptMode: JavascriptMode.unrestricted,
        )*/
    );
  }

 /* Widget _buildBrowser() {




    return WebView(
      initialUrl: dashboardURL,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }*/






}
