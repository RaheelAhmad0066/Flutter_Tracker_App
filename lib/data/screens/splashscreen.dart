import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/Login.dart';
import 'package:maktrogps/data/model/PushNotification.dart';
import 'package:maktrogps/data/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottom_navigation/bottom_navigation_01.dart';
import '../model/loginModel.dart';
import 'listscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  SharedPreferences? prefs;
/*  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;*/

/*  String _notificationToken = "";
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );*/

/*  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();*/
  @override
  void initState() {
    checkPreference();
    //initFirebase();
    super.initState();
    Timer(Duration(seconds: 4), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => signin())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 8,

                  child :Image.asset(StaticVarMethod.loginimageurl,height: 60,)/*Image.asset('assets/appsicon/btplappicon512.png')*/,
                 // child: Text("Track With Advance Technology"),
                ),

                Container(
                   alignment: Alignment.center,
                   // margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold
                      ),
                    )
                )
              ]
          )
      ),
    );
  }








  void checkPreference() async {
    prefs = await SharedPreferences.getInstance();


    if (prefs!.get('baseurlall') != null) {
        StaticVarMethod.baseurlall=prefs!.get('baseurlall').toString();
    } else {
      //StaticVarMethod.baseurlall="https://plataforma.integracionescontraccar.com";
     // demo@demo.com
      //1234567890
      //Bolo stephane
    //StaticVarMethod.baseurlall="http://207.244.225.51";
    // StaticVarMethod.baseurlall="http://38.242.158.64";
    //   demo@brtcvts.com
    // 112233
     //StaticVarMethod.baseurlall="http://brtcvts.com";
     // StaticVarMethod.baseurlall="http://31.220.78.153";
     // StaticVarMethod.baseurlall="http://gps.mototrackerbd.com";
     // StaticVarMethod.baseurlall="http://38.242.220.125";

      //karachi shawaiz
    //  StaticVarMethod.baseurlall="http://45.84.138.70";
      //tanzim
     // StaticVarMethod.baseurlall="http://167.71.216.19";
    //sergio
   //  StaticVarMethod.baseurlall="http://62.171.191.144";
//finland
  // StaticVarMethod.baseurlall="http://89.117.58.199";
//ecudor
     // StaticVarMethod.baseurlall="http://143.198.64.107";
//muhhammad noor ul huda
     // StaticVarMethod.baseurlall="http://167.86.91.29";

      //Radouan adnan vehitrack
      StaticVarMethod.baseurlall="http://173.249.6.87";
//bayyniah
    //  StaticVarMethod.baseurlall="http://38.242.199.100";
//gbl rental express
     // StaticVarMethod.baseurlall="http://154.26.156.183";

      //Vtrack
    //  StaticVarMethod.baseurlall="http://185.197.194.170";


    }


    if (prefs!.get('email') != null) {
      if (prefs!.get("popup_notify") == null) {
        prefs!.setBool("popup_notify", true);
      }
      checkLogin();
    } else {
      prefs!.setBool("popup_notify", true);
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => BottomNavigation( loginModel: response)),
            builder: (context) => signin()),
      );
      //Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void checkLogin() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // gpsapis.login(prefs!.get('email'), prefs!.get('password'))
      //     .then((response) {
      //   if (response != null) {
      //     if (response.statusCode == 200) {
      //       prefs!.setString("user", response.body);
      //       final user = Login.fromJson(jsonDecode(response.body));
      //       prefs!.setString('user_api_hash', user.user_api_hash!);
      gpsapis api=new gpsapis();

      api.getlogin(prefs!.get('email').toString(), prefs!.get('password').toString()).then((response) {

        if (response != null) {
          if (response.statusCode == 200) {
            prefs!.setBool("popup_notify", true);
            prefs!.setString("user", response.body);
            //isBusy = false;
            //isLoggedIn = true;
            final res= LoginModel.fromJson(json.decode(response.body));
            StaticVarMethod.user_api_hash=res.userApiHash;
           // EasyLoading.dismiss();
            prefs!.setString('user_api_hash', res.userApiHash!);
           // updateToken();
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => BottomNavigation( loginModel: response)),
                 // builder: (context) => BottomNavigation()),
                builder: (context) => BottomNavigation_01()),


            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => BottomNavigation( loginModel: response)),
                  builder: (context) => signin()),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => BottomNavigation( loginModel: response)),
                builder: (context) => signin()),
          );
        }
      });
    });
  }



/*  void requestAndRegisterNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _messaging.getToken();
      print("The token is "+token!);
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }*/

 /* void updateToken() {
    gpsapis.getUserData()
        .then((value) => {gpsapis.activateFCM(_notificationToken)});
  }*/


/*  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
        });

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging
        .getToken()
        .then((value) => {print(value), _notificationToken = value!});
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await messaging.getToken().then((value) => {
      _notificationToken = value!,
      StaticVarMethod.notificationToken=_notificationToken
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(message.messageId!,
          message.notification!.title!,
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true);
      NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: 'item x');
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   Navigator.pushNamed(context, '/eventMap',
    //       arguments: EventArgument(
    //           message.data['message'],
    //           message.data['latitude'],
    //           message.data['longitude'],
    //           message.data['speed'],
    //           message.data['time'],
    //           message.data['device_name']));
    // });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });
  }*/
}
