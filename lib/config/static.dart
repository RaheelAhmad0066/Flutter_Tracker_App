import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:maktrogps/data/model/devices.dart';
import 'package:maktrogps/data/model/events.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticVarMethod{
  static bool isInitLocalNotif = false;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool isDarkMode = false;
  static String? user_api_hash = "\$2y\$10\$yUmXjzCeKUZ1fb8SHRZJTe7AWBmVhDAMrSmoi6DVxkicvS3rtmW6G";
  static List<deviceItems> devicelist= [];
  static List<EventsData> eventList= [];
  static String deviceName= "";
  static String deviceId= "";
  static String imei= "";
  static String simno= "";
  static double lat= 0.0;
  static double lng=0.0;

  static int reportType=1;

  //static String baseurlall= "https://maktrogps.com";

 // static String baseurlall= "http://38.242.199.100";
  // static String baseurlall= "http://38.242.158.64";

 // static String baseurlall= "http://207.244.225.51";

  //static String baseurlall= "http://136.244.82.204";
  //demo@demo.com   demo
 // static String baseurlall="https://bittrackerz.com";
  //static String baseurlall= "http://gps.mototrackerbd.com";
  //static String baseurlall= "http://brtcvts.com";
  static String baseurlall= "http://31.220.78.153";
 // static String imageurl= 'assets/appsicon/trackon.png';


  // static String listimageurl= 'assets/appsicon/rqtrackerlist.png';
  // static String loginimageurl= 'assets/appsicon/rqtrackerlogin.png';
  // static String splashimageurl= 'assets/appsicon/rqtrackerlogin.png';

  // static String listimageurl= 'assets/appsicon/trackmasterlistscreen.jpeg';
  // static String loginimageurl= 'assets/appsicon/trackmasterlogin.jpeg';
  // static String splashimageurl= 'assets/appsicon/trackmasterlogin.jpeg';

  // static String listimageurl= 'assets/appsicon/sigo500by200.png';
  // static String loginimageurl= 'assets/appsicon/sigo500by200.png';
  // static String splashimageurl= 'assets/appsicon/sigo500by200.png';

  static String listimageurl= 'assets/appsicon/vehitrack.jpeg';
  static String loginimageurl= 'assets/appsicon/vehitrack.jpeg';
  static String splashimageurl= 'assets/appsicon/vehitrack.jpeg';

  // static String listimageurl= 'assets/appsicon/gblrentalexpressappicon.jpg';
  // static String loginimageurl= 'assets/appsicon/gblrentalexpressappicon.jpg';
  // static String splashimageurl= 'assets/appsicon/gblrentalexpressappicon.jpg';


  // static String listimageurl= 'assets/appsicon/vehitracklogo.jpeg';
  // static String loginimageurl= 'assets/appsicon/vehitracklogo.jpeg';
  // static String splashimageurl= 'assets/appsicon/vehitracklogo.jpeg';




  static SharedPreferences? pref_static;
  //static String baseurlall= "https://ingreso.securitytecno.com";
  static String notificationToken="";
  static String fromdate= DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  static String fromtime="00:00";
  static String todate= DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  static String totime= DateFormat('HH:mm').format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour, DateTime.now().minute));

}