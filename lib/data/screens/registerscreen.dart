import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:http/http.dart' as http;
import 'package:maktrogps/config/static.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'browser_module_old/browser.dart';

class registerscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _vehicle_infoState();
}

class _vehicle_infoState extends State<registerscreen> {
  @override
  initState() {
    super.initState();
  }
  TextEditingController _VehicleNameFieldController = TextEditingController();
  TextEditingController _IMEINumberFieldController = TextEditingController();
  TextEditingController _odometerFieldController = TextEditingController();
  TextEditingController _SimNumberFieldController = TextEditingController();
  TextEditingController _PlateNumberFieldController = TextEditingController();
  static Color primaryDark = const Color.fromARGB(255, 13, 61, 101);
  @override
  void dispose() {
    super.dispose();
  }
  List<String> _devicesListstr=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.red,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Register',
            style: TextStyle(color: Colors.white,)),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          // action button
        ],
        backgroundColor:  primaryDark,
      ),
      body: ListView(children: <Widget>[
        playBackControls(),
      ]),
    );
  }

  Widget playBackControls() {

    return Container(
      padding: EdgeInsets.only(left: 5, right: 8, top: 20, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                child: Container(
                    height: 70,
                    //margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child:TextField(
                                controller: _VehicleNameFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'Vehicle Name',
                                  labelStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                          ),

                        ]
                    )
                ),
              ),
            ]),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                child: Container(
                    height: 70,
                    //margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child:TextField(
                                controller: _IMEINumberFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'IMEI Number',
                                  labelStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                          ),

                        ]
                    )
                ),
              ),
            ]),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                child: Container(
                    height: 70,
                    //margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child:TextField(
                                controller: _PlateNumberFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'Plate Number',
                                  labelStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                          ),

                        ]
                    )
                ),
              ),
            ]),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                child: Container(
                    height: 70,
                    //margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child:TextField(
                                //obscureText: _obscureText,
                                controller: _SimNumberFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  //hintText: '9172181058',hintStyle: TextStyle(color: Colors.black),
                                  labelText: 'Sim Number',
                                  labelStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                          ),

                        ]
                    )
                ),
              ),
            ]),
          ),
         Row(
           children: [
             Container(
                 margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                 //padding: EdgeInsets.only(left: 10, right: 10),
                 height: 60,
                 width: 170,
                 decoration: BoxDecoration(
                   color:  Colors.white,
                   border: Border.all(width: 0, color: Colors.white,),
                   borderRadius: BorderRadius.all(Radius.circular(0)),
                 ),
                 child:Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       color:  Colors.white,
                       padding: EdgeInsets.only(left: 9, right: 0,bottom: 0,),
                       child: Container(
                         margin: EdgeInsets.only(bottom: 5),
                         child: Text('Categories',
                             style: TextStyle(
                               fontSize: 15,
                               fontWeight: FontWeight.normal,
                               color: Colors.black,
                               // height: 1.7,

                             )
                         ),
                       ),
                     ),
                   ],
                 )
             ),
             Container(
                 margin: EdgeInsets.only(top: 8, left: 30, bottom: 0),
                 //padding: EdgeInsets.only(left: 10, right: 10),
                 height: 60,
                 width: 140,
                 decoration: BoxDecoration(
                   color:  Colors.white,
                   border: Border.all(width: 0, color: Colors.white,),
                   borderRadius: BorderRadius.all(Radius.circular(0)),
                 ),
                 child:Column(
                   children: [
                     Container(
                       color:  Colors.white,
                       //padding: EdgeInsets.only(left: 0, right: 90,bottom: 0,),
                       child: DropdownSearch(
                         mode: Mode.MENU,
                         showSelectedItems: true,
                         items: _devicesListstr,
                         dropdownSearchDecoration: InputDecoration(
                           /*labelText: "Categories",labelStyle: TextStyle(
                           color: Colors.black, //<-- SEE HERE
                         ),*/
                           hintText: " Arrow",hintStyle: TextStyle(
                           fontSize: 15,
                           fontWeight: FontWeight.normal,
                           color: Color(0xff606060),
                           // height: 1.7,

                         )
                         ),
                         onChanged: (dynamic value) {
                           for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
                             if (value != null) {
                               if (StaticVarMethod.devicelist.elementAt(i).name!.contains(value)) {
                                 StaticVarMethod.deviceId=StaticVarMethod.devicelist.elementAt(i).id.toString();
                                 print("value:" + value);
                                 break;
                               }
                             }
                           }
                           setState(() {
                             //_selectedReport = value;
                           });

                         },
                         showSearchBox: true,
                         searchFieldProps: TextFieldProps(
                           cursorColor:Colors.grey[500],
                         ),

                       ),
                     ),
                   ],
                 )
             ),
           ],
         ),
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  width: 130,
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    border: Border.all(width: 0, color: Colors.white,),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color:  Colors.white,
                        padding: EdgeInsets.only(left: 9, right: 0,bottom: 0,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text('Protocols',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                // height: 1.7,

                              )
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top: 8, left: 30, bottom: 0),
                  //padding: EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                    color:  Colors.white,
                    border: Border.all(width: 0, color: Colors.white,),
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  child:Column(
                    children: [
                      Container(
                        color:  Colors.white,
                        //padding: EdgeInsets.only(left: 0, right: 90,bottom: 0,),
                        child: DropdownSearch(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: _devicesListstr,
                          dropdownSearchDecoration: InputDecoration(
                            /*labelText: "Categories",labelStyle: TextStyle(
                           color: Colors.black, //<-- SEE HERE
                         ),*/
                              hintText: "Default (Protocol)",hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Color(0xff606060),
                            // height: 1.7,

                          )
                          ),
                          onChanged: (dynamic value) {
                            for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
                              if (value != null) {
                                if (StaticVarMethod.devicelist.elementAt(i).name!.contains(value)) {
                                  StaticVarMethod.deviceId=StaticVarMethod.devicelist.elementAt(i).id.toString();
                                  print("value:" + value);
                                  break;
                                }
                              }
                            }
                            setState(() {
                              //_selectedReport = value;
                            });

                          },
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor:Colors.grey[500],
                          ),

                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),

            child: Row(children: [
              Expanded(
                child: Container(
                    height: 70,
                    //margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 0),
                              child:TextField(
                                //obscureText: _obscureText,
                                controller: _odometerFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  //hintText: '9172181058',hintStyle: TextStyle(color: Colors.black),
                                  labelText: 'Odometer',
                                  labelStyle: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                          ),

                        ]
                    )
                ),
              ),
            ]),
          ),

          Container(
            margin: EdgeInsets.only(top: 100,left: 5,right: 5,),
            width: 350,
            height: 48,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) =>  primaryDark,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                  ),
                ),
                onPressed: () {
                  savedevice();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
            ),
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

  Future<void> savedevice() async {

    String name=_VehicleNameFieldController.text.toString();
    String imei=_IMEINumberFieldController.text.toString();
    var response= await gpsapis.adddevice(name,imei );

    Fluttertoast.showToast(msg: 'Device Added Succeessfully!!!',backgroundColor: Colors.green, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context);

  }
}
