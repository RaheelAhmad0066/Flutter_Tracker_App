import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'browser_module_old/browser.dart';

class supportscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _vehicle_infoState();
}

class _vehicle_infoState extends State<supportscreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support',
            style: TextStyle(color: Colors.black, fontSize: 15)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          // action button
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(children: <Widget>[
        playBackControls(),
      ]),
    );
  }

  Widget playBackControls() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 40),
      decoration: BoxDecoration(
        color: Color(0xffF5F5F5),
        /* borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 20,
                offset: const Offset(0.0, 10.0)
               // color: Colors.grey.withOpacity(0.5)
            )
          ]*/
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        // builder: (context) => playbackselection()),
                        // );

                      //
                       // _launchUrl("mailto:info@impressivebd.com?subject=News&body=hey");
                       // _launchUrl("mailto:infosbd32@gmail.com?subject=News&body=hey");
                      //  _launchUrl("mailto:info@trackmaster.pk?subject=News&body=hey");
                        _launchUrl("mailto:Contact@vehitrack.com?subject=News&body=hey");

                       // _emaillaunchURL();
                      },
                      child: Container(
                          height: 180,
/*
                          margin: EdgeInsets.only(top: 5, left: 8, right: 8),
*/
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(38),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 28),
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 13, left: 9, right: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffF1F1F1),
                                  ),
                                  child: ClipRRect(
                                      child: Image.asset(
                                          "assets/speedoicon/assets_images_emailicon.png",
                                          height: 40,
                                          width: 40)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text('Email',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,

                                        //fontWeight: FontWeight.bold,
                                        // height: 1.7,
                                        //fontFamily: 'digital_font'
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text('24/7',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffA6A8AC),
                                        // fontFamily: 'digital_font'
                                      )),
                                ),
                              ])))),
              SizedBox(
                width: 30,
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        // builder: (context) => playbackselection()),
                        // );


                       // _launchUrl("tel:8801713546487");
                        //_launchUrl("tel:8801711927826");
                        //_launchUrl("tel:03133320020");
                        _launchUrl("tel:+212637222815");
                      },
                      child: Container(
                          height: 180,
/*
                          margin: EdgeInsets.only(top: 5, left: 8, right: 8),
*/
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(38),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 28),
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 13, left: 9, right: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffF1F1F1),
                                  ),
                                  child: ClipRRect(
                                      child: Image.asset(
                                          "assets/speedoicon/assets_images_hotlineicon.png",
                                          height: 40,
                                          width: 40)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text('Hotline',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,

                                        //fontWeight: FontWeight.bold,
                                        // height: 1.7,
                                        //fontFamily: 'digital_font'
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text('24/7',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffA6A8AC),
                                        // fontFamily: 'digital_font'
                                      )),
                                ),
                                // Card(
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     elevation: 2,
                                //     color: Colors.white,
                                //     child: Container(
                                //         margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.start,
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: <Widget>[
                                //
                                //             SizedBox(
                                //               width: 5,
                                //             ),
                                //
                                //           ],
                                //         )
                                //     ))
                              ])))),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        // builder: (context) => playbackselection()),
                        // );

                         //_launchUrl("https://m.me/8801713546487?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");
                         //_launchUrl("https://m.me/03192803563?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");
                         _launchUrl("https://m.me/212637222815?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");

                       // moto
                        // _launchUrl("https://m.me/253098044733617?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");

                       // final url ="https://m.me/253098044733617?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1";
                       //  final url ="https://m.me/212637222815?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1";

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Browser(
                        //           dashboardName: "Messenger",
                        //           dashboardURL: url,
                        //         )));
                      },
                      child: Container(
                          height: 180,
/*
                          margin: EdgeInsets.only(top: 5, left: 8, right: 8),
*/
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(38),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 28),
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 13, left: 9, right: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffF1F1F1),
                                  ),
                                  child: ClipRRect(
                                      child: Image.asset(
                                          "assets/nepalicon/live-chatbot.png",
                                          height: 40,
                                          width: 40)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text('Messenger',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,

                                        //fontWeight: FontWeight.bold,
                                        // height: 1.7,
                                        //fontFamily: 'digital_font'
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text('24/7',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffA6A8AC),
                                        // fontFamily: 'digital_font'
                                      )),
                                ),
                                // Card(
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     elevation: 2,
                                //     color: Colors.white,
                                //     child: Container(
                                //         margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.start,
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: <Widget>[
                                //
                                //             SizedBox(
                                //               width: 5,
                                //             ),
                                //
                                //           ],
                                //         )
                                //     ))
                              ])))),
              SizedBox(
                width: 30,
              ),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                       // launchWhatsApp("+923192803563");

                       // moto
                        //launchWhatsApp("+8801711927826");
                        //vehitrack
                        launchWhatsApp("+212637222815");

                      },
                      child: Container(
                          height: 180,
/*
                          margin: EdgeInsets.only(top: 5, left: 8, right: 8),
*/
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(38),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 28),
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 13, left: 9, right: 9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffF1F1F1),
                                  ),
                                  child: ClipRRect(
                                      child: Image.asset(
                                          "assets/speedoicon/assets_images_whatsappicon.png",
                                          height: 40,
                                          width: 40)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Text('Whatsapp',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,

                                        //fontWeight: FontWeight.bold,
                                        // height: 1.7,
                                        //fontFamily: 'digital_font'
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  child: Text('24/7',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffA6A8AC),
                                        // fontFamily: 'digital_font'
                                      )),
                                ),
                                // Card(
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     elevation: 2,
                                //     color: Colors.white,
                                //     child: Container(
                                //         margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.start,
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: <Widget>[
                                //
                                //             SizedBox(
                                //               width: 5,
                                //             ),
                                //
                                //           ],
                                //         )
                                //     ))
                              ])))),
            ]),
          ),
        ],
      ),
    );
  }

  launchWhatsApp(num) async {
    final link = WhatsAppUnilink(
      phoneNumber: num,
      text: "Hey! I'm inquiring about the Tracking listing",
    );
    await launch('$link');
  }

  _emaillaunchURL() async {
     final url = Uri.encodeFull('mailto:infosbd32@gmail.com?subject=News&body=hey');
  //  final url = '';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchUrl(String url1) async {

    if (await canLaunchUrl(Uri.parse(url1))) {
      await launchUrl(Uri.parse(url1),
          mode: LaunchMode.externalApplication);
    }
    // if (await canLaunchUrl(Uri.parse(url1))) {
    //   await launchUrl(Uri.parse(url1));
    // } else {
    //   throw 'Could not launch $url1';
    // }
  }


}
