

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktrogps/config/apps/ecommerce/constant.dart';
import 'package:maktrogps/config/apps/food_delivery/global_style.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/model/User.dart';
import 'package:maktrogps/data/screens/livetrackoriginal.dart';
import 'package:maktrogps/data/screens/playback.dart';
import 'package:maktrogps/data/screens/playbackselection.dart';
import 'package:maktrogps/data/screens/privacypolicy.dart';
import 'package:maktrogps/data/screens/reports/kmdetail.dart';
import 'package:maktrogps/data/screens/reports/reportselection.dart';
import 'package:maktrogps/data/screens/reports/vehicle_info.dart';
import 'package:maktrogps/data/screens/signin.dart';
import 'package:maktrogps/data/screens/termsandconditions.dart';
import 'package:maktrogps/ui/reusable/cache_image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AlertList.dart';


class lockscreen extends StatefulWidget {
  @override
  _lockscreenState createState() => _lockscreenState();
}

class _lockscreenState extends State<lockscreen> {
  // initialize reusable widget
  // final _reusableWidget = ReusableWidget();
  late User user;
  late SharedPreferences prefs;
  bool isLoading = true;
  final TextEditingController _newPassword = new TextEditingController();
  final TextEditingController _retypePassword = new TextEditingController();
  bool _val = false;
  String email ="";
  String expiration_date ="";
  @override
  void initState() {
    getUser();
    checkPreference();
    super.initState();
  }
  void checkPreference() async {
    prefs = await SharedPreferences.getInstance();


  }

  getUser() async {
    gpsapis.getUserData().then((value) => {
      isLoading = false,
      user = value!,
      email = value!.email.toString(),
      expiration_date = value.expiration_date.toString(),
      setState(() {})
    });
    setState(() {});
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
        automaticallyImplyLeading: false,
        elevation: 0,
        /* iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),*/
        //systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        centerTitle: true,
        title: Text('Settings Screen', style: GlobalStyle.appBarTitle),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        //bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        children: [

          _createAccountInformation(),
          _buildmoreswitch(),
          _buildmoreManues(),


        ],
      ),

    );
  }

  Widget _createAccountInformation(){
    final double profilePictureSize = MediaQuery.of(context).size.width/4;
    return Container(
        margin: EdgeInsets.all(5),
        //  padding: EdgeInsets.all(10),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.all(5),
                padding: EdgeInsets.only(left: 8,right: 8,top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(''+StaticVarMethod.deviceName, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold
                        )),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: (){
                            Fluttertoast.showToast(msg: 'Click account information / user profile', toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Row(
                            children: [
                              /* Text(''+expiration_date, style: TextStyle(
                          fontSize: 14, color: Colors.grey
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.chevron_right, size: 20, color: SOFT_GREY)*/
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(''+StaticVarMethod.imei, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold
                        )),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: (){
                            Fluttertoast.showToast(msg: 'Click account information / user profile', toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Row(
                            children: [
                              /* Text(''+expiration_date, style: TextStyle(
                          fontSize: 14, color: Colors.grey
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.chevron_right, size: 20, color: SOFT_GREY)*/
                            ],
                          ),
                        )
                      ],
                    ),
                  ) ,
                ],
              ),
            )
        )
    );
  }

  Widget _buildmoreswitch(){
    return Container(
        margin: EdgeInsets.all(10),
        child:     Center(child:
        Text('   Control Vehicle Engine',  style: TextStyle(
            fontSize: 15,height: 1.5,fontWeight: FontWeight.bold)),
        )
    );
  }


  Widget _buildmoreManues(){
    return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      _launchURL("www.maktro.com/mgt/pay");
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

                        decoration: new BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(30)),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.lock, size: 30, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                            //  Image.asset("assets/settingicon/payment.png", height: 40,width: 40),
                              Text('Lock',  style: TextStyle(
                                  fontSize: 16, color: Colors.white)),


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
                      _launchURL("www.maktro.com/mgt/price");
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

                        decoration: new BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          shape: BoxShape.rectangle,
                          borderRadius:BorderRadius.all(Radius.circular(30)),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //Image.asset("assets/settingicon/pricing.png", height: 40,width: 40),
                              Icon(Icons.lock_open, size: 30, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Unlock',  style: TextStyle(
                                  fontSize: 16, color: Colors.white)),

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





  Future<void> updateToken() async{

    String token="fF-uE2bmQQOujEy5v8eIgn:APA91bFGxHZ7B2rhOUvSojd0qQiAjsa_9e7AYgomwaiM9AKRj2LSytOvvujsLspcq4p_APu7f1APHFAibaODfGElInM-7cuPh7NDjTCc1bd5Jxt_lbkVYloT_auWBY-WN4WmVzHOE";
    gpsapis.getUserData()
        .then((value) => {gpsapis.activateFCM(token)});
    print("Remove notification successfuly");

  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  void changePasswordDialog() {
    Dialog simpleDialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 250.0,
                width: 400.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Container(
                                child: new TextField(
                                  controller: _newPassword,
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'New Password'),
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              new Container(
                                child: new TextField(
                                  controller: _retypePassword,
                                  decoration: new InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Retype Password'),
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    //color: Colors.red,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    // color: CustomColor.primaryColor,
                                    onPressed: () {
                                      updatePassword();
                                    },
                                    child: Text('Ok',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }

  void updatePassword() {
    if (_newPassword.text == _retypePassword.text) {
      // Map<String, String> requestBody = <String, String>{
      //   'password': _newPassword.text
      // };
      // gpsapis.changePassword(_newPassword.toString()).then((value) => {
      //   AlertDialogCustom().showAlertDialog(
      //       context,'Password Updated Successfully','Change Password','ok')
      // });
      var result= gpsapis.changePassword(_newPassword.text.toString());
      if(result != null){
        AlertDialogCustom().showAlertDialog(
            context,'Password Updated Successfully','Change Password','ok');
      }
    } else {
      AlertDialogCustom().showAlertDialog(
          context,'Password Not Same','Failed','ok');
    }
  }
}








