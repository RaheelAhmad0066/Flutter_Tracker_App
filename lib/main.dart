import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maktrogps/data/screens/testscreens/livelocation.dart';
import 'package:maktrogps/provider/theme_changer_provider.dart';

import 'package:maktrogps/utils/LocalNotificationService.dart';
import 'package:provider/provider.dart';
import 'config/static.dart';
import 'data/screens/splashscreen.dart';
import 'mvvm/view_model/objects.dart';



///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification!.title);
  LocalNotificationService.display(message);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyHomePage(title: "title"));
}



// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // debugShowCheckedModeBanner: false,
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   // This is the theme of your application.
//       //   //
//       //   // Try running your application with "flutter run". You'll see the
//       //   // application has a blue toolbar. Then, without quitting the app, try
//       //   // changing the primarySwatch below to Colors.green and then invoke
//       //   // "hot reload" (press "r" in the console where you ran "flutter run",
//       //   // or simply save your changes to "hot reload" in a Flutter IDE).
//       //   // Notice that the counter didn't reset back to zero; the application
//       //   // is not restarted.
//       //   primarySwatch: Colors.blue,
//       // ),
//
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       builder: EasyLoading.init(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  //
  // static void setLocale(BuildContext context, Locale newLocale) async {
  //   _MyHomePageState? state = context.findAncestorStateOfType<_MyHomePageState>();
  //   state!.changeLanguage(newLocale);
  // }
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // late Locale _locale;
  //
  // changeLanguage(Locale locale) {
  //   setState(() {
  //     _locale = locale;
  //   });
  // }

  /*int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    // initPlatformState();
    // secureScreen();
    super.initState();

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });

    getToken();


  }

  Future<void> getDeviceTokenToSendNotification() async {
    String? fcmToken =  await await FirebaseMessaging.instance.getToken();
    StaticVarMethod.notificationToken=fcmToken.toString();
    //deviceTokenToSendPushNotification = token.toString();
    print("Token Value: "+ StaticVarMethod.notificationToken);
  }
  Future<void> getToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();


    return MultiProvider(

      providers: [

        ChangeNotifierProvider(create: (_) => theme_changer_provider()),
        ChangeNotifierProvider(create: (_) => ObjectStore()),
      ],
      child: Builder(
          builder: (context) {
            final themeChanger = Provider.of<theme_changer_provider>(context);
            return MaterialApp(
              themeMode: themeChanger.thememode,
              theme: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.indigo
              ),
              darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.purple
              ),
              home: SplashScreen(),
              builder: EasyLoading.init(),
            );
          }
      ),

    );

    // return MaterialApp(
    //   // debugShowCheckedModeBanner: false,
    //   // title: 'Flutter Demo',
    //   // theme: ThemeData(
    //   //   // This is the theme of your application.
    //   //   //
    //   //   // Try running your application with "flutter run". You'll see the
    //   //   // application has a blue toolbar. Then, without quitting the app, try
    //   //   // changing the primarySwatch below to Colors.green and then invoke
    //   //   // "hot reload" (press "r" in the console where you ran "flutter run",
    //   //   // or simply save your changes to "hot reload" in a Flutter IDE).
    //   //   // Notice that the counter didn't reset back to zero; the application
    //   //   // is not restarted.
    //   //   primarySwatch: Colors.blue,
    //   // ),
    //
    //   home: SplashScreen(),
    //   builder: EasyLoading.init(),
    // );
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return Scaffold(
    //
    // /*  appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),*/
    //  // body: SimpleMarkerAnimationExample(),
    //   body: SplashScreen(),// This trailing comma makes auto-formatting nicer for build methods.
    // );
  }
}
