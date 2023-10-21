import 'dart:convert';

import 'package:maktrogps/data/gpsserver/datasources.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktrogps/config/apps/ecommerce/constant.dart';
import 'package:maktrogps/config/apps/food_delivery/global_style.dart';
import 'package:maktrogps/config/static.dart';

import 'package:maktrogps/data/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maktrogps/data/datasources.dart';


class changedevicesettings extends StatefulWidget {
  @override
  _changedevicesettingsState createState() => _changedevicesettingsState();
}

class _changedevicesettingsState extends State<changedevicesettings> {
  List<String> _devicesListstr=[];
  String device_id="",imei="",devicename="",changetext="";
  String? protocol,name,map_arrows6,map_icon7,tail_color8,tail_points9,model12,odometertype15,enginehourtype16,odometer17,enginehour18,fcr19,accuracy21;

  late SharedPreferences prefs;
  @override
  void initState() {
    getdeviesList();
    super.initState();
  }


  Future<void> getdeviesList() async {
    prefs = await SharedPreferences.getInstance();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.grey[300],
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        //elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          // action button

        ],
        backgroundColor: Colors.white,
        title: Text('Change device setting', style: GlobalStyle.appBarTitle),
        //bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        children: [
          _buildVehilelist(),
          _buildchangeseeting(),
        //  _buildchangeseeting2(),
        ],
      ),

    );
  }



  Widget _buildVehilelist(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [



            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        padding: EdgeInsets.all(18),

                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(15)),
                          // borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              //offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   DropdownSearch(
                          mode: Mode.MENU,
                          showSelectedItems: true,
                          items: _devicesListstr,
                          dropdownSearchDecoration: InputDecoration(
                            //labelText: "Location",
                            hintText: "Select Vehicle",
                          ),
                          onChanged: (dynamic value) {
                            for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
                              if (value != null) {
                                if (StaticVarMethod.devicelist.elementAt(i).name!.contains(value)) {
                                  imei=StaticVarMethod.devicelist.elementAt(i).deviceData!.imei.toString();
                                  devicename=StaticVarMethod.devicelist.elementAt(i).name.toString();
                                  device_id=StaticVarMethod.devicelist.elementAt(i).id.toString();
                                  print("value: " + value);
                                  break;
                                }
                              }
                            }
                            setState(() {
                              getfnsettign();
                              //_selectedReport = value;
                            });

                          },
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor: Colors.red,
                          ),

                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _buildchangeseeting(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {

                      (imei!="")?_showPopup(context):showtoast();
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:10,bottom: 10,left: 10, right: 5),

                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(15)),
                          // borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              //offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Change icon',  style: TextStyle(
                                        fontSize: 14, color: SOFT_GREY)),
                                  /*  Text('9AM - 6PM',  style: TextStyle(
                                        fontSize: 10, color: SOFT_GREY)),*/
                                  ]
                              ),
                              Image.asset("assets/speedoicon/assets_images_shuffleicon.png", height: 30,width: 30),

                            ]
                        )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      (imei!="")?_showEdit(context,"Change Name"):showtoast();
                    },
                    child: Container(
                       // padding: EdgeInsets.all(18),
                        padding: EdgeInsets.only(top:10,bottom: 10,left: 10, right: 5),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(15)),
                          // borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              //offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Change Name',  style: TextStyle(
                                        fontSize: 14, color: SOFT_GREY)),
                                 /*   Text('9AM - 6PM',  style: TextStyle(
                                        fontSize: 10, color: SOFT_GREY)),*/
                                  ]
                              ),
                              Image.asset("assets/speedoicon/assets_images_idname.png", height: 30,width: 30),

                            ]
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
  Widget _buildchangeseeting2(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {

                      (imei!="")?_showEdit(context,"Change odometer"):showtoast();
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:10,bottom: 10,left: 10, right: 5),

                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(15)),
                          // borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              //offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Change odometer',  style: TextStyle(
                                        fontSize: 14, color: SOFT_GREY)),
                                    /*  Text('9AM - 6PM',  style: TextStyle(
                                        fontSize: 10, color: SOFT_GREY)),*/
                                  ]
                              ),
                              Image.asset("assets/speedoicon/assets_images_odometericon.png", height: 30,width: 30),

                            ]
                        )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      (imei!="")?_showEdit(context,"Change mileage"):showtoast();
                    },
                    child: Container(
                      // padding: EdgeInsets.all(18),
                        padding: EdgeInsets.only(top:10,bottom: 10,left: 10, right: 5),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(15)),
                          // borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              //offset: const Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Change mileage',  style: TextStyle(
                                        fontSize: 14, color: SOFT_GREY)),
                                    /*   Text('9AM - 6PM',  style: TextStyle(
                                        fontSize: 10, color: SOFT_GREY)),*/
                                  ]
                              ),
                              Image.asset("assets/speedoicon/assets_images_mileageicon.png", height: 30,width: 30),

                            ]
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }

  void showtoast(){
    Fluttertoast.showToast(msg: 'Please select vehicle First!', toastLength: Toast.LENGTH_LONG);
  }
  void _showPopup(BuildContext context){
    double imageSize = MediaQuery.of(context).size.width/10;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(''+devicename),
            children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                  margin: EdgeInsets.only(top: 12, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                               prefs.setString(imei, "bike_");
                               Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                               Navigator.of(context).pop();
                              /* Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => SplashScreen()),
                               );*/
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/bike_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Bike',  style: TextStyle(
                                            fontSize: 12,height: 2))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "car_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/car_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Car',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],

                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "truck_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/truck_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Truck',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(/*top: 12,*/ bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "ambulance_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/ambulance_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Ambulance',  style: TextStyle(
                                            fontSize: 12,height: 2))
                                      ]
                                  )
                              ),
                            ),


                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "bus_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/bus_sidestop.png", height: imageSize,width: imageSize),
                                        Text('BUS',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],

                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "erickshaw_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/erickshaw_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Auto',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(/*top: 12,*/ bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "cycle_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/cycle_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Cycle',  style: TextStyle(
                                            fontSize: 12,height: 2))
                                      ]
                                  )
                              ),
                            ),


                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "scotty_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/scotty_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Scotty',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],

                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                prefs.setString(imei, "tractor_");
                                Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/tbtrack/tractor_sidestop.png", height: imageSize,width: imageSize),
                                        Text('Tractor',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ]
            ),
             /* SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context, 'user01@gmail.com');
                  Fluttertoast.showToast(msg: 'user01@gmail.com', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 36.0, color: Colors.orange),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('user01@gmail.com'),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context, 'user02@gmail.com');
                  Fluttertoast.showToast(msg: 'user02@gmail.com', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 36.0, color: Colors.green),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('user02@gmail.com'),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context, 'Add account');
                  Fluttertoast.showToast(msg: 'Add account', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 36.0, color: Colors.grey),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16.0),
                      child: Text('Add account'),
                    ),
                  ],
                ),
              )*/
            ],
          );
        });
  }

  void _showEdit(BuildContext context, String changetype){
    double imageSize = MediaQuery.of(context).size.width/10;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(''+devicename),
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 12, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child:
                                  Container(

                                      padding: EdgeInsets.only(left: 20, right: 10),
                                      child:
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        //controller: _usernameFieldController,
                                        onChanged: (String value) {
                                          changetext = value;
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.transparent)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent),
                                            ),
                                            //labelText: 'Email / IMEI',
                                            labelText: changetype,
                                            labelStyle: TextStyle(color: Colors.grey[500])),
                                      )
                                  )
                              ),
                            ),


                          ],
                        )
                    ),
                    Container(
                        //margin: EdgeInsets.only(/*top: 12,*/ bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      //prefs.setString(imei, "assets_images_markers_m_4_");
                                      Fluttertoast.showToast(msg: 'Canceled!', toastLength: Toast.LENGTH_LONG);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8),

                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:BorderRadius.all(Radius.circular(15)),
                                          // borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 1.0,
                                              //offset: const Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        // color: Colors.white,
                                        //color: Color(0x99FFFFFF),
                                        child:   Column(
                                            children: <Widget>[
                                              //Image.asset("assets/speedoicon/assets_images_markers_m_4_red.png", height: imageSize,width: imageSize),
                                              Text('Cancel',  style: TextStyle(
                                                  fontSize: 12,height: 2))
                                            ]
                                        )
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      
                                      if(changetype.contains("Change Name")){
                                        editfnsettign(device_id,changetext,imei);
                                      }else if(changetype.contains("Change odometer")){
                                        editfnsettign(name!,changetext, odometer17!);
                                      }else if(changetype.contains("Change mileage")){
                                        editfnsettign(name!,enginehour18!,changetext);
                                      }


                                     // prefs.setString(imei, "assets_images_markers_m_5_");
                                      Fluttertoast.showToast(msg: 'Update Successfully!', toastLength: Toast.LENGTH_LONG);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:BorderRadius.all(Radius.circular(15)),
                                          // borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 1.0,
                                              //offset: const Offset(0.0, 10.0),
                                            ),
                                          ],
                                        ),
                                        child:   Column(
                                            children: <Widget>[
                                              Text('Save',  style: TextStyle(
                                                  fontSize: 12,height: 2.0))
                                            ]
                                        )
                                    ),
                                  ),
                                ],

                              ),
                            ),
                          ],
                        )
                    ),

                  ]
              ),
            ],
          );
        });
  }

  Future<void> editfnsettign(String device_id,String name,String imei) async {
    print("getfnsettign");

    try {

      var response= await gpsapis. editdevice(device_id,name,imei );

      Fluttertoast.showToast(msg: 'Device Updated Succeessfully!!!',backgroundColor: Colors.green, toastLength: Toast.LENGTH_LONG);
      Navigator.pop(context);
    }
    catch (e) {
      print("getfnsettignerror");
      // _showSnackBar("Not exist",0);
    }

  }
  Future<void> getfnsettign() async {
    print("getfnsettign");

    try {

      // gpsserverapis.getfn_settings()
      //     .then((response) {
      //   if (response != null) {
      //    // eventList.clear();
      //     if (response.statusCode == 200) {
      //       var jsonData = json.decode(response.body);
      //       /*  final hyperlinks = jsonData
      //           .map((i) => i['run_hyperlink'])
      //           .toList().cast<Map<String, dynamic>>();*/
      //       print(jsonData);
      //
      //       List keys = jsonData.keys.toList();
      //       List values = jsonData.values.toList();
      //       print (keys);
      //       print (values);
      //
      //       for (var i = 0; i < values.length; i++) {
      //         String inrre=keys[i].toString();
      //         if(keys[i].toString().contains(imei)){
      //            protocol=values[i][0].toString();
      //            name=values[i][4].toString();
      //            map_arrows6=values[i][6].toString();
      //            map_icon7=values[i][7].toString();
      //            tail_color8=values[i][8].toString();
      //            tail_points9=values[i][9].toString();
      //            model12=values[i][12].toString();
      //           // json4=values[i][4].toString();
      //            odometertype15=values[i][15].toString();
      //            enginehourtype16=values[i][16].toString();
      //            odometer17=values[i][17].toString();
      //            enginehour18=values[i][18].toString();
      //            fcr19=values[i][19].toString();
      //            accuracy21=values[i][21].toString();
      //          // String? json90=values[i][4].toString();
      //           print(name);
      //            setState(() {});
      //         }
      //
      //    /*     String? json1=jsonData[i][0].toString();
      //         String? json2=jsonData[i][4].toString();
      //         String? json3=jsonData[i][5].toString();
      //         String? json4=jsonData[i][11].toString();
      //         String? json5=jsonData[i][12].toString();
      //         String? json6=jsonData[i][18].toString();
      //         String? json7=jsonData[i][19].toString();
      //         String? json8=jsonData[i][21].toString();
      //         String? json9=jsonData[i][24].toString();
      //         String? json10=jsonData[i][33].toString();*/
      //     /*    notificationmodel model=new notificationmodel();
      //         model.message=json1;
      //         model.name=json2;
      //         model.imei=json3;
      //         model.time=json4;
      //         model.lat=json5;
      //         model.lng=json6;
      //         eventList.add(model);
      //         //eventList.sort();
      //
      //         eventList.sort((a, b) => b.time!.compareTo(a.time!));*/
      //       }
      //    /*   if (eventList.isNotEmpty) {
      //         _isLoading = false;
      //         setState(() {});
      //         print(jsonData);
      //       } else {
      //       }*/
      //
      //     } else {
      //
      //     }
      //   } else {
      //
      //   }
      // });
    }
    catch (e) {
      print("getfnsettignerror");
      // _showSnackBar("Not exist",0);
    }

  }


}









