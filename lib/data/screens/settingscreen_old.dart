

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
import 'package:maktrogps/data/screens/supportscreen.dart';
import 'package:maktrogps/data/screens/termsandconditions.dart';
import 'package:maktrogps/ui/reusable/cache_image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import 'AlertList.dart';
import 'browser_module_old/browser.dart';


class settingscreen_old extends StatefulWidget {
  @override
  _settingscreenState createState() => _settingscreenState();
}

class _settingscreenState extends State<settingscreen_old> {
  // initialize reusable widget
  // final _reusableWidget = ReusableWidget();
  late User user;
  late SharedPreferences prefs;
  bool isLoading = true;
  final TextEditingController _newPassword = new TextEditingController();
  final TextEditingController _retypePassword = new TextEditingController();
  bool _val = true;
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
    _val= prefs.getBool("notival")!;

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
         // _buildmoreswitch(),
        //  _buildmoreManues(),
         // _buildmoreManues2(),
         // _buildmoreManues3(),
          _buildsettings(),
          _buildManues(),
        ],
      ),

    );
  }

  Widget _createAccountInformation(){
    final double profilePictureSize = MediaQuery.of(context).size.width/4;
    return Container(
      margin: EdgeInsets.all(5),
    child: Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
   //elevation: 2,
    color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: profilePictureSize,
            height: profilePictureSize,
            padding: EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'Click picture', toastLength: Toast.LENGTH_SHORT);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: profilePictureSize,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: profilePictureSize-4,
                      child: Hero(
                        tag: 'profilePicture',
                        child: ClipOval(
                          child:Image.asset("assets/images/icons8-traffic-jam-100.png", height: profilePictureSize-4,width: profilePictureSize-4),

                          //child: buildCacheNetworkImage(width: profilePictureSize-4, height: profilePictureSize-4, url: GLOBAL_URL+'/assets/images/user/avatar.png')
                        ),
                      ),
                    ),
                  ),
                ),

          ),
          SizedBox(
            width: 16,
          ),
          (email.isNotEmpty)?
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(''+email, style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
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
          ) :CircularProgressIndicator(),
        ],
      ),
    )
    );
  }

  Widget _buildmoreswitch(){
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => playbackselection()),
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(1),

                        /*decoration: new BoxDecoration(
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
                        ),*/
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset("assets/images/moreicon.png", height: 35,width: 35),
                              Text('   More',  style: TextStyle(
                                  fontSize: 18,height: 1.5,fontWeight: FontWeight.bold)),


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
  Widget _buildsettings(){
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => playbackselection()),
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(1),

                        /*decoration: new BoxDecoration(
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
                        ),*/
                        // color: Colors.white,
                        //color: Color(0x99FFFFFF),
                        child:   Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Image.asset("assets/images/settingicon.png", height: 35,width: 35),
                              Text('   Settings',  style: TextStyle(
                                  fontSize: 18,height: 1.5,fontWeight: FontWeight.bold)),


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

                      _launchURL("https://safetygpstracker.com.bd/Pay_bill");
                     // _launchURL("https://mototrackerbd.com/dashboard/customer_bill_pay");
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

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
                              Text('Pay Now',  style: TextStyle(
                                  fontSize: 16, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/payment.png", height: 40,width: 40),

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
                     // _launchURL("https://safetygpstracker.com.bd/price_list");
                     // _launchURL("http://mototrackerbd.com/");
                      final url ="https://safetygpstracker.com.bd/price_list";
                      //final url ="http://mototrackerbd.com/";

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Browser(
                                dashboardName: "Pricing",
                                dashboardURL: url,
                              )));
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

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
                              Text('Pricing',  style: TextStyle(
                                  fontSize: 16, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/pricing.png", height: 40,width: 40),

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

  Widget _buildmoreManues2(){
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => supportscreen()),
                      );

                      //_launchURL("https://safetygpstracker.com.bd/");

                      // _launchURL("https://m.me/+923414910057?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");
                     // launchWhatsApp();
                     //  _launchURL("https://m.me/253098044733617?ref=bb54fea9559f614364722d530070222f3980223b84f769ff1");
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

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
                              Text(' Support',  style: TextStyle(
                                  fontSize: 16, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/livesupport.png", height: 40,width: 40),

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
                      //_launchURL("https://safetygpstracker.com.bd/single_page/1");
                      //_launchURL("http://trackcaronline/");
                      //_launchURL("http://mototrackerbd.com/");

                      final url ="https://safetygpstracker.com.bd/single_page/1";
                     // final url ="http://mototrackerbd.com/";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Browser(
                                dashboardName: "About US",
                                dashboardURL: url,
                              )));
                    },
                    child: Container(
                        padding: EdgeInsets.only(top:15,bottom: 15,left: 10, right: 5),

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
                              Text('About Us',  style: TextStyle(
                                  fontSize: 16, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/aboutus.png", height: 40,width: 40),

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

  Widget _buildmoreManues3(){
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
                        padding: EdgeInsets.only(top:18,bottom: 18,left: 10, right: 5),

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
                              Text('Share Location',  style: TextStyle(
                                  fontSize: 15, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/sharelocation.png", height: 30,width: 30),

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

                     // _launchURL("https://safetygpstracker.com.bd/vms");

                     // _launchURL("http://mototrackerbd.com/vms");

                     // final url ="https://mototrackerbd.com/dashboard/customer_bill_vms";
                      final url ="https://safetygpstracker.com.bd/vms";

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Browser(
                                dashboardName: "VMS",
                                dashboardURL: url,
                              )));
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
                        child:   Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('VMS',  style: TextStyle(
                                  fontSize: 16, color: SOFT_GREY)),
                              Image.asset("assets/settingicon/report.png", height: 30,width: 30),

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
  Widget _buildManues(){
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
             // _launchURL("https://safetygpstracker.com.bd/single_page/2");

             // _launchURL("https://mototrackerbd.com/terms-conditions");

              final url ="https://safetygpstracker.com.bd/single_page/2";
              //final url ="https://mototrackerbd.com/terms-conditions";

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Browser(
                        dashboardName: "VMS",
                        dashboardURL: url,
                      )));
             /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => termsandconditions()),
              );*/
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                //margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                   /* border: Border.all(
                        width: 1,
                        color: Colors.grey[300]!
                    ),*/
                    borderRadius: BorderRadius.only(topLeft:  Radius.circular(10) ,topRight:  Radius.circular(10) )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.file_copy_rounded,size: 30, color: Colors.blue),
                        SizedBox(width: 12),
                        Text('Terms & Conditions', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Icon(Icons.chevron_right, size: 30, color: SOFT_GREY),
                  ],
                )
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){

              //_launchURL("https://safetygpstracker.com.bd/single_page/2");
             // _launchURL("https://mototrackerbd.com/privacy-policy/");

             // final url ="https://mototrackerbd.com/privacy-policy";
              final url ="https://safetygpstracker.com.bd/single_page/2";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Browser(
                        dashboardName: "VMS",
                        dashboardURL: url,
                      )));
             /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => privacypolicy()),
              );*/
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[100]!
                    ),
                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(10) ,bottomRight:  Radius.circular(10) )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.privacy_tip,size: 30, color: Colors.yellow),
                        SizedBox(width: 12),
                        Text(' Privacy', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Icon(Icons.chevron_right, size: 30, color: SOFT_GREY),
                  ],
                )
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              changePasswordDialog();
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                //margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    /* border: Border.all(
                        width: 1,
                        color: Colors.grey[300]!
                    ),*/
                    borderRadius: BorderRadius.only(topLeft:  Radius.circular(10) ,topRight:  Radius.circular(10) )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.change_circle,size: 30, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Change Password', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Icon(Icons.chevron_right, size: 30, color: SOFT_GREY),
                  ],
                )
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => reportselection()),
              );
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[100]!
                    ),
                    borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(10) ,bottomRight:  Radius.circular(10) )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.stacked_bar_chart,size: 30, color: Colors.orange),
                        SizedBox(width: 12),
                        Text('Reports', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Icon(Icons.chevron_right, size: 30, color: SOFT_GREY),
                  ],
                )
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AlertListPage()),
              );

            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[300]!
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10) //         <--- border radius here
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications,size: 30, color: Colors.red.shade700),
                        SizedBox(width: 12),
                        Text('Alerts', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    // Switch(
                    //   value: _val,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _val = value;
                    //     });
                    //   },
                    // ),
                  ],
                )
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){


            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 1, 2, 1),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[300]!
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10) //         <--- border radius here
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications,size: 30, color: Colors.red.shade700),
                        SizedBox(width: 12),
                        Text('Notifications', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Switch(
                      value: _val,
                      onChanged: (value) {
                        setState(() {
                          _val = value;
                          prefs.setBool("notival", _val);
                          if(_val==false){
                           // updateToken();
                          }
                        });
                      },
                    ),
                  ],
                )
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              prefs.remove("email");
              prefs.remove("password");
              prefs.remove("popup_notify");
              prefs.remove("user");
              prefs.remove("user_api_hash");
              prefs.remove("user_api_hash");
              prefs.setBool("notival", false);
             // prefs.clear();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => signin()),
              );

            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12, 12, 2, 12),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 1,
                        color: Colors.grey[300]!
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10) //         <--- border radius here
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.logout,size: 30, color: Colors.red.shade700),
                        SizedBox(width: 12),
                        Text('Sign Out', style: TextStyle(
                            color: CHARCOAL, fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                    Icon(Icons.chevron_right, size: 30, color: SOFT_GREY),
                  ],
                )
            ),
          ),

        ],
      ),
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


  launchWhatsApp() async {
    final link = WhatsAppUnilink(
      phoneNumber: '+8801711927826',
      text: "Hey! I'm inquiring about the Tracking listing",
    );
    await launch('$link');
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









//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:maktrogps/config/static.dart';
// import 'package:maktrogps/data/datasources.dart';
// import 'package:maktrogps/data/model/events.dart';
// import 'package:settings_ui/settings_ui.dart';
//
//
//
// class settingscreen extends StatefulWidget {
//
//   @override
//   _settingscreenState createState() => _settingscreenState();
// }
//
// /*class _settingscreenState extends State<settingscreen> {
//   bool valNotify1 = true;
//   bool valNotify2 = false;
//   bool valNotify3 = false;
//   onChangeFunction1(bool newValue1) {
//     setState(() {
//       valNotify1 = newValue1;
//     });
//   }
//
//   onChangeFunction2(bool newValue2) {
//     setState(() {
//       valNotify2 = newValue2;
//     });
//   }
//
//   onChangeFunction3(bool newValue3) {
//     setState(() {
//       valNotify3 = newValue3;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Settings UI", style: TextStyle(fontSize: 22)),
//         leading: IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.print,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         child: ListView(
//           children: [
//             const SizedBox(height: 40),
//             Row(
//               children: const [
//                 Icon(
//                   Icons.person,
//                   color: Colors.blue,
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   "Account",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//             const Divider(height: 20, thickness: 1),
//             const SizedBox(height: 10),
//             buildAccountOption(context, "Change Password"),
//             buildAccountOption(context, "Context Setting"),
//             buildAccountOption(context, "Social"),
//             buildAccountOption(context, "Language"),
//             buildAccountOption(context, "Privacy and Security"),
//             const SizedBox(height: 40),
//             Row(
//               children: const [
//                 Icon(Icons.volume_up_outlined, color: Colors.blue),
//                 SizedBox(width: 10),
//                 Text("Notifications",
//                     style:
//                     TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const Divider(height: 20, thickness: 1),
//             buildNotificationOption(
//                 "Theme Dark", valNotify1, onChangeFunction1),
//             buildNotificationOption(
//                 "Account Active", valNotify2, onChangeFunction2),
//             buildNotificationOption(
//                 "Opportunity", valNotify3, onChangeFunction3),
//             const SizedBox(height: 50),
//             Center(
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal:
//                         40) */
// /*
//                                 shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)
//                         )*/
// /*
//                 ),
//                 onPressed: () {},
//                 child: const Text("SIGN OUT",
//                     style: TextStyle(
//                       fontSize: 16,
//                       letterSpacing: 2.2,
//                       color: Colors.black,
//                     )),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Padding buildNotificationOption(
//       String title, bool value, Function onChangeMethod) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600])),
//           Transform.scale(
//             scale: 0.7,
//             child: CupertinoSwitch(
//               activeColor: Colors.blue,
//               trackColor: Colors.grey,
//               value: value,
//               onChanged: (bool newValue) {
//                 onChangeMethod(newValue);
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   GestureDetector buildAccountOption(BuildContext context, String title) {
//     return GestureDetector(
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text(title),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Text("Option1"),
//                     Text("Option2"),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text("close"))
//                 ],
//               );
//             });
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(title,
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600])),
//             const Icon(
//               Icons.person,
//               color: Colors.blue,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }*/
//
// class _settingscreenState extends State<settingscreen> {
//
//   bool useCustomTheme = false;
//
//   final platformsMap = <DevicePlatform, String>{
//     DevicePlatform.device: 'Default',
//     DevicePlatform.android: 'Android',
//     DevicePlatform.iOS: 'iOS',
//     DevicePlatform.web: 'Web',
//     DevicePlatform.fuchsia: 'Fuchsia',
//     DevicePlatform.linux: 'Linux',
//     DevicePlatform.macOS: 'MacOS',
//     DevicePlatform.windows: 'Windows',
//   };
//   DevicePlatform selectedPlatform = DevicePlatform.device;
//
//   @override
//   initState() {
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     //return noNotificationScreen();
//     return Scaffold(
//       appBar: appBar(),
//       body:  SettingsList(
//         platform: selectedPlatform,
//         lightTheme: !useCustomTheme
//             ? null
//             : SettingsThemeData(
//           dividerColor: Colors.red,
//           tileDescriptionTextColor: Colors.yellow,
//           leadingIconsColor: Colors.pink,
//           settingsListBackground: Colors.white,
//           settingsSectionBackground: Colors.green,
//           settingsTileTextColor: Colors.tealAccent,
//           tileHighlightColor: Colors.blue,
//           titleTextColor: Colors.cyan,
//           trailingTextColor: Colors.deepOrangeAccent,
//         ),
//         darkTheme: !useCustomTheme
//             ? null
//             : SettingsThemeData(
//           dividerColor: Colors.pink,
//           tileDescriptionTextColor: Colors.blue,
//           leadingIconsColor: Colors.red,
//           settingsListBackground: Colors.grey,
//           settingsSectionBackground: Colors.tealAccent,
//           settingsTileTextColor: Colors.green,
//           tileHighlightColor: Colors.yellow,
//           titleTextColor: Colors.cyan,
//           trailingTextColor: Colors.orange,
//         ),
//         sections: [
//           SettingsSection(
//             title: Text('Common'),
//
//             tiles: <SettingsTile>[
//               SettingsTile.navigation(
//                 leading: Icon(Icons.language),
//                 title: Text('Language'),
//                 trailing:Icon(Icons.arrow_forward_ios_outlined),
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.cloud_outlined),
//                 title: Text('Environment'),
//                 value: Text('Production'),
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.devices_other),
//                 title: Text('Platform'),
//                 onPressed: (context) async {
//                 /*final platform = await Navigation.navigateTo<DevicePlatform>(
//                     context: context,
//                     style: NavigationRouteStyle.material,
//                     screen: PlatformPickerScreen(
//                       platform: selectedPlatform,
//                       platforms: platformsMap,
//                     ),
//                   );*/
//
//                /*   if (platform != null && platform is DevicePlatform) {
//                     setState(() {
//                       selectedPlatform = platform;
//                     });
//                   }*/
//                 },
//                 value: Text("platformsMap[selectedPlatform]"),
//               ),
//               SettingsTile.switchTile(
//                 onToggle: (value) {
//                   setState(() {
//                     useCustomTheme = value;
//                   });
//                 },
//                 initialValue: useCustomTheme,
//                 leading: Icon(Icons.format_paint),
//                 title: Text('Enable custom theme'),
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Account'),
//             tiles: <SettingsTile>[
//               SettingsTile.navigation(
//                 leading: Icon(Icons.phone),
//                 title: Text('Phone number'),
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.mail),
//                 title: Text('Email'),
//                 enabled: false,
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.logout),
//                 title: Text('Sign out'),
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Security'),
//             tiles: <SettingsTile>[
//               SettingsTile.switchTile(
//                 onToggle: (_) {},
//                 initialValue: true,
//                 leading: Icon(Icons.phonelink_lock),
//                 title: Text('Lock app in background'),
//               ),
//               SettingsTile.switchTile(
//                 onToggle: (_) {},
//                 initialValue: true,
//                 leading: Icon(Icons.fingerprint),
//                 title: Text('Use fingerprint'),
//                 description: Text(
//                   'Allow application to access stored fingerprint IDs',
//                 ),
//               ),
//               SettingsTile.switchTile(
//                 onToggle: (_) {},
//                 initialValue: true,
//                 leading: Icon(Icons.lock),
//                 title: Text('Change password'),
//               ),
//               SettingsTile.switchTile(
//                 onToggle: (_) {},
//                 initialValue: true,
//                 leading: Icon(Icons.notifications_active),
//                 title: Text('Enable notifications'),
//               ),
//             ],
//           ),
//           SettingsSection(
//             title: Text('Misc'),
//             tiles: <SettingsTile>[
//               SettingsTile.navigation(
//                 leading: Icon(Icons.description),
//                 title: Text('Terms of Service'),
//               ),
//               SettingsTile.navigation(
//                 leading: Icon(Icons.collections_bookmark),
//                 title: Text('Open source license'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//   }
//
//   PreferredSizeWidget  appBar(){
//     return AppBar(
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () =>   Navigator.pop(context,true),
//         //Navigator.of(context,rootNavigator: true).pop(),
//       ),
//       title: Text("Notification"),
//       centerTitle: true,
//     );
//   }
//
//
//
// }
