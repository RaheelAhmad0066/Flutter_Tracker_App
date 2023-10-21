import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation_01.dart';
import 'package:maktrogps/config/constant.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/loginModel.dart';
import 'package:maktrogps/data/screens/listscreen.dart';
import 'package:maktrogps/data/screens/mainmapscreenoriginal.dart';
import 'package:maktrogps/data/screens/supportscreen.dart';
import 'package:maktrogps/ui/reusable/global_function.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class signin extends StatefulWidget {
  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  final _globalWidget = GlobalWidget();
  final _globalFunction = GlobalFunction();
  Color _gradientTop = Color(0xFF039be6);
  Color _gradientBottom = Color(0xFF0299e2);
  Color mainColor = Color(0xff0540ac);

 // Color themeDark = Color(0xff009640);
  Color _underlineColor = Color(0xFFCCCCCC);
  late LoginModel loginModel;
  String _username = "demo@moto.com", _password = "demo", _cnic = "",_customserver="";

  //text controlller//
  TextEditingController _usernameFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  TextEditingController _customserverFieldController = TextEditingController();
  late SharedPreferences prefs;
  bool isBusy = true;
  bool isLoggedIn = false;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  int _selectedserver = 0;
  double _dialogHeight = 300.0;
  double _dialogCommandHeight = 150.0;

  @override
  void initState() {

    _usernameFieldController.addListener(_emailListen);
    _passwordFieldController.addListener(_passwordListen);

    checkPreference();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkPreference() async {
    prefs = await SharedPreferences.getInstance();

    _usernameFieldController.text = prefs.getString('email')!;
    _passwordFieldController.text = prefs.getString('password')!;

    _customserverFieldController.text= prefs!.get('baseurlall').toString();
    if (prefs.get('email') != null) {
      login();
    } else {
      isBusy = false;
      setState(() {});
    }
  }



  void _emailListen() {
    if (_usernameFieldController.text.isEmpty) {
      _username = "";
    } else {
      _username = _usernameFieldController.text;
    }
  }

  void _passwordListen() {
    if (_passwordFieldController.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFieldController.text;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS?SystemUiOverlayStyle.light:SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light
          ),
          child: Stack(
            children: <Widget>[
              // top blue background gradient

              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/images/backgroundimage.jpeg"),
              //       fit: BoxFit.cover,
              //     ),
              //     /* gradient: LinearGradient(
              //           colors: [_gradientTop, _gradientBottom],
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter)*/
              //   ),
              // ),
              // Container(
              //   height: MediaQuery.of(context).size.height / 3.5,
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           colors: [_gradientTop, _gradientBottom],
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter)),
              // ),
              // set your logo here
              Container(
                  margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height / 10, 0, 0),
                  alignment: Alignment.topCenter,
                  child:Image.asset(StaticVarMethod.splashimageurl,height: 60) /*Image.asset('assets/appsicon/btplloginlogo.png', height: 90)*/

               // child: Text("Track With Advance Technology"),
    ),
              ListView(
                children: <Widget>[
                  // create form login
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(25, MediaQuery.of(context).size.height / 3.0 - 40, 25, 0),
                    color: Colors.white,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children:[
                                Container(

                                    padding: EdgeInsets.only(left: 20, right: 10),
                                    child:Text(
                                      'Login',
                                      style: TextStyle(
                                          color: themeDark,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )
                                )
                              ]
                            ),
                          /*  Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: themeDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),*/
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                                child:
                                Container(

                                    padding: EdgeInsets.only(left: 20, right: 10),
                                    child:
                                    TextField(
                                      controller: _usernameFieldController,
                                      keyboardType: TextInputType.emailAddress,
                                      //controller: _usernameFieldController,
                                      onChanged: (String value) {
                                        _username = value;
                                      },
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.transparent)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                          ),
                                          labelText: 'Email / UserName',
                                          labelStyle: TextStyle(color: Colors.grey[500])),
                                    )
                                )
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                                child:
                                Container(

                                    padding: EdgeInsets.only(left: 20, right: 10),
                                    child:TextField(
                                      controller: _passwordFieldController,
                                      obscureText: _obscureText,
                                      //controller: _passwordFieldController,
                                      onChanged: (String value) {
                                        _password = value;
                                      },

                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                        suffixIcon: IconButton(
                                            icon: Icon(_iconVisible, color: Colors.grey[500], size: 20),
                                            onPressed: () {
                                              _toggleObscureText();
                                            }),
                                      ),
                                    )
                                )
                            ),

                            /*
                             SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(msg: 'Click forgot password', toastLength: Toast.LENGTH_SHORT);
                                },
                                child: Text('Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 13
                                    ),
                                ),
                              ),
                            ),*/
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) => themeDark,
                                    ),
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        )
                                    ),
                                  ),
                                  onPressed: () {
                                    EasyLoading.show(status: 'loading...');
                                    //_globalFunction.showProgressDialog(context);
                                    if (_username == null || _username.isEmpty) {

                                      Fluttertoast.showToast(msg: '_username == null || _username.isEmpty', toastLength: Toast.LENGTH_SHORT);

                                    } else if (_password == null || _password.isEmpty) {
                                       Fluttertoast.showToast(msg: '_password == null || _password.isEmpty', toastLength: Toast.LENGTH_SHORT);

                                    } else {
                                      login();
                                    }
                                   // Fluttertoast.showToast(msg: 'Click login', toastLength: Toast.LENGTH_SHORT);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  // create sign up link
                  /*Center(
                    child: Wrap(
                      children: <Widget>[
                        Text('New User? '),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: themeDark,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),*/



                //  support()



                ],
              )
            ],
          ),
        )
    );
  }

  Widget support(){

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [

        Expanded(
          child:  GestureDetector(
            onTap: () {

              _username="demo@moto.com";
              _password="demo";
              login();


            },
            child: Container(

                child:   Column(
                    children: <Widget>[
                      Image.asset("assets/speedoicon/assets_images_vehicleicon.png", height: 30,width: 30),
                      Text('  Demo  ',  style: TextStyle(
                          fontSize: 12,height: 2.0,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent))
                    ]
                )
            ),
          ),
        ),
        Expanded(
          child:  GestureDetector(
            onTap: () {
              // _launchURL("https://m.me/253098044733617?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");
              // launchWhatsApp();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => supportscreen()),
              );

            },
            child: Container(

                child:   Column(
                    children: <Widget>[
                      Image.asset("assets/speedoicon/assets_images_whatsappicon.png", height: 30,width: 30),
                      Text('  Support  ',  style: TextStyle(
                          fontSize: 12,height: 2.0,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent))
                    ]
                )
            ),
          ),
        ),
        // Expanded(
        //   child:  GestureDetector(
        //     onTap: () {
        //
        //       _launchURL("https://safetygpstracker.com.bd/Pay_bill");
        //     //  _launchURL("https://mototrackerbd.com/dashboard/customer_bill_pay");
        //
        //
        //     },
        //     child: Container(
        //
        //         child:   Column(
        //             children: <Widget>[
        //               Image.asset("assets/speedoicon/assets_images_payicon.png", height: 30,width: 30),
        //               Text('  Pay Now  ',  style: TextStyle(
        //                   fontSize: 12,height: 2.0,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent))
        //             ]
        //         )
        //     ),
        //   ),
        // ),
        Expanded(
          child:  GestureDetector(
            onTap: () {
              showserverDialog(context);


            },
            child: Container(

                child:   Column(
                    children: <Widget>[
                      Image.asset("assets/images/switchserver.png", height: 30,width: 30),
                      Text('  Switch Server  ',  style: TextStyle(
                          fontSize: 13,height: 2.0,fontWeight: FontWeight.bold,color: Colors.lightBlueAccent))
                    ]
                )
            ),
          ),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+8801711927826',
      text: "Hey! I'm inquiring about the Tracking listing",
    );
    await launch('$link');
  }
  Future<void> login() async{
    gpsapis api=new gpsapis();

    // if(_username.contains("abc@gmail.co")){
      api.getlogin(_username, _password).then((response) {

        if (response != null) {
          if (response.statusCode == 200) {
            prefs.setBool("popup_notify", true);
            prefs.setString("user", response.body);
            isBusy = false;
            isLoggedIn = true;
            final res= LoginModel.fromJson(json.decode(response.body));
            StaticVarMethod.user_api_hash=res.userApiHash;
            EasyLoading.dismiss();
            prefs.setString('user_api_hash', res.userApiHash!);


            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => BottomNavigation( loginModel: response)),
                //  builder: (context) => BottomNavigation()),
                  builder: (context) => BottomNavigation_01()),

            );
          } else if (response.statusCode == 401) {
            isBusy = false;
            isLoggedIn = false;
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg: "Login Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          } else if (response.statusCode == 400) {
            isBusy = false;
            isLoggedIn = false;
            if (response.body ==
                "Account has expired - SecurityException (PermissionsManager:259 < *:441 < SessionResource:104 < ...)") {
              setState(() {});
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: Text("Failed"),
                  content: Text(
                      "Login Failed"),
                  actions: <Widget>[
                    new ElevatedButton(
                      onPressed: () {
                        EasyLoading.dismiss();
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // dismisses only the dialog and returns nothing
                      },
                      child: new Text(
                          "ok"),
                    ),
                  ],
                ),
              );
            }
          } else {
            isBusy = false;
            isLoggedIn = false;
            EasyLoading.dismiss();
            Fluttertoast.showToast(
                msg: response.body,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black54,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
          }
        } else {
          isLoggedIn = false;
          isBusy = false;
          setState(() {});
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: "Error Msg",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.lightGreen.shade50,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        /*   if (response != null) {
        var res= LoginModel.fromJson(json.decode(response.body));
        StaticVarMethod.user_api_hash=res.userApiHash;
        EasyLoading.dismiss();
        Navigator.push(
          context,
          MaterialPageRoute(
             // builder: (context) => BottomNavigation( loginModel: response)),
              builder: (context) => BottomNavigation()),
        );
      }else{

      }*/
      });
    // }
    // else{
    //
    //
    //   Fluttertoast.showToast(
    //       msg: "You are not registered!!!",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black54,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

  }



  void showserverDialog(BuildContext context) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return new Container(
            height: _dialogHeight,
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Radio(
                                value: 0,
                                groupValue: _selectedserver,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedserver = value!;
                                    _dialogHeight = 300.0;
                                  });
                                },
                              ),
                              new Text('Impressive Security',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Radio(
                                value: 1,
                                groupValue: _selectedserver,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedserver = value!;
                                    _dialogHeight = 300.0;
                                  });
                                },
                              ),
                              new Text('Safety GPS',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Radio(
                                value: 2,
                                groupValue: _selectedserver,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedserver = value!;
                                    _dialogHeight = 300.0;
                                  });
                                },
                              ),
                              new Text('BRTC VTS',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Radio(
                                value: 3,
                                groupValue: _selectedserver,
                                onChanged: (value) {
                                  setState(() {
                                    _dialogHeight = 400.0;
                                    _selectedserver = value!;
                                  });
                                },
                              ),
                              new Text('Custom Server',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          _selectedserver == 3
                              ? new Container(
                            
                               padding: EdgeInsets.all(20),
                              child: new Column(
                                children: <Widget>[

                                 
                                   TextField(
                                      controller: _customserverFieldController,
                                      keyboardType: TextInputType.emailAddress,
                                      //controller: _usernameFieldController,
                                      onChanged: (String value) {
                                        _customserver = value;
                                      },
                                      decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey)),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          labelText: 'Custom Server',
                                          labelStyle: TextStyle(color: Colors.grey[500])),
                                    )
                                  
                                  
                                ],
                              ))
                              : new Container(),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // background
                                  onPrimary: Colors.white, // foreground
                                ),
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
                                onPressed: () {
                                  showReport();
                                },
                                child: Text('Save',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }


  Future<void> showReport() async {
    
    if (_selectedserver == 0) {
      await prefs!.setString('baseurlall', "https://track.impressivebd.com");

      StaticVarMethod.baseurlall="https://track.impressivebd.com";
      _customserverFieldController.text= StaticVarMethod.baseurlall;
      Navigator.pop(context);
    } else if (_selectedserver == 1) {
      await prefs!.setString('baseurlall', "https://track.safetyvts.com");
      StaticVarMethod.baseurlall="https://track.safetyvts.com";
      _customserverFieldController.text= StaticVarMethod.baseurlall;
      Navigator.pop(context);
    } else if (_selectedserver == 2) {
      await prefs!.setString('baseurlall', "http://brtcvts.com");
      StaticVarMethod.baseurlall= "http://brtcvts.com";
      _customserverFieldController.text= StaticVarMethod.baseurlall;
      Navigator.pop(context);
    }else if (_selectedserver == 3) {
      await prefs!.setString('baseurlall', _customserver);
      StaticVarMethod.baseurlall=_customserver;
      _customserverFieldController.text= StaticVarMethod.baseurlall;
      Navigator.pop(context);
    }

    setState(() {
    });
  }

/*  void updateToken() {
    gpsapis.getUserData()
        .then((value) => {gpsapis.activateFCM(StaticVarMethod.notificationToken)});
  }*/
/*  api.getHistory(response.userApiHash).then((response){
          if (response != null) {

            var res=response.items?.length;

          }
        });
        api.getEvents(response.userApiHash).then((response){
          if (response != null) {

            var res=response.items?.data?.length;
            print(res);

          }
        });
        print(response.userApiHash);*/

}
