import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:maktrogps/config/static.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:maktrogps/data/datasources.dart';

import 'browser_module_old/browser.dart';

class addalert extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _vehicle_infoState();
}

class _vehicle_infoState extends State<addalert> {

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _typeFieldController = TextEditingController();
  TextEditingController _overspeedFieldController = TextEditingController();
  static Color primaryDark = const Color.fromARGB(255, 13, 61, 101);


  @override
  initState() {
    super.initState();

    _overspeedFieldController.text="20";
    _typeFieldController.text="overspeed";
    getdeviesList();
  }


  Future<void> getdeviesList() async {
    _devicesListstr.clear();

    for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
      _devicesListstr.add(StaticVarMethod.devicelist.elementAt(i).name!);
    }

    setState(() {

    });
  }

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
        title: Text('Add Alerts',
            style: TextStyle(color: Colors.white, )),
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
                                controller: _nameFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'Name',
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
                                controller: _typeFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'Type',
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
                                controller: _overspeedFieldController,
                                onChanged: (String value) {
                                },

                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey.shade500)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  labelText: 'Overspeed Value',
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
            margin: EdgeInsets.only(top: 20, left: 5, right: 5),
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
            ),
            child:Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0.3,
                //color: Colors.grey.shade900,
                //shadowColor: Colors.pink,
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownSearch(
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      items: _devicesListstr,
                      dropdownSearchDecoration: InputDecoration(
                        //labelText: "Location",
                          hintText: "Select Vehicle",
                          border: InputBorder.none
                      ),
                      onChanged: (dynamic value) {
                        for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
                          if (value != null) {
                            if (StaticVarMethod.devicelist.elementAt(i).name!.contains(value)) {
                              StaticVarMethod.deviceId=StaticVarMethod.devicelist.elementAt(i).id.toString();
                              print("value: " + value);
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
                        cursorColor: Colors.red,
                      ),

                    )
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 100,left: 5,right: 5,),
            width: 350,
            height: 48,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => primaryDark,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                  ),
                ),
                onPressed: () {
                  savealert();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    'Add Alerts',
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
  Future<void> savealert() async {

    String name=_nameFieldController.text.toString();
    String type=_typeFieldController.text.toString();
    String overspeed=_overspeedFieldController.text.toString();
    var response= await gpsapis.addalert(name, type, StaticVarMethod.deviceId,overspeed) ;

    Fluttertoast.showToast(msg: 'Alert Added Succeessfully!!!',backgroundColor: Colors.green, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context);
  }

}
