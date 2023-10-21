import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/static.dart';
import '../../res/AssetsRes.dart';
import '../../ui/reusable/Mycolor/MyColor.dart';
import '../datasources.dart';
import '../model/devices.dart';
import '../model/events.dart';
import 'notificationscreen.dart';

class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int touchedIndex = -1;
  // late ObjectStore objectStore;
  // late EventsStore eventsStore;
  // late DashboardStore dashboardStore;
  // Map<String, ObjectResponse> devicesList = HashMap();
  Map<String, dynamic> devicesSettingsList = HashMap();

  int key = 0;
  SharedPreferences?  prefs;

  List<deviceItems> _inactiveVehicles = [];
  List<deviceItems> _allVehicles = [];
  List<deviceItems> _runningVehicles = [];
  List<deviceItems> _idleVehicles = [];
  List<deviceItems> _stoppedVehicles = [];

  List<EventsData> eventList = [];


  @override
  initState() {
    //notiList = Consts.notiList;
    getnotiList();
    checkPreference();
    _getData();
    super.initState();
  }

  void checkPreference() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {

    });
  }


  Future<void> _getData() async {
    _runningVehicles = [];
    _idleVehicles = [];
    _stoppedVehicles = [];
    _inactiveVehicles = [];
    _allVehicles = [];


    if(StaticVarMethod.devicelist.isNotEmpty){
      gpsapis api = new gpsapis();
      var hash = StaticVarMethod.user_api_hash;
      StaticVarMethod.devicelist = await gpsapis.getDevicesList(hash);
      _allVehicles=StaticVarMethod.devicelist;
    }


    if (StaticVarMethod.devicelist.isNotEmpty) {

      for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
        deviceItems model = StaticVarMethod.devicelist.elementAt(i);
        if (model.online.toString().toLowerCase().contains("offline") &&
            model.time.toString().toLowerCase().contains("not connected")) {
          _inactiveVehicles.add(StaticVarMethod.devicelist.elementAt(i));
        } else if (model.online.toString().toLowerCase().contains("online")) {
          _runningVehicles.add(StaticVarMethod.devicelist.elementAt(i));
        } else if (model.online.toString().toLowerCase().contains("ack") &&
            double.parse(model.speed.toString()) < 1.0) {
          _idleVehicles.add(StaticVarMethod.devicelist.elementAt(i));
        } else if (model.online
            .toString()
            .toLowerCase()
            .contains("offline") &&
            model.time.toString().toLowerCase() != "not connected") {
          _stoppedVehicles.add(StaticVarMethod.devicelist.elementAt(i));
        }
      }
      if (mounted) {
        setState(() {});
      }
    }






    //setState(() {
    // startTimer();
    //  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Text('Dashboard',
                      style: TextStyle(
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                          color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      launch("tel://"+prefs!.getString("PREF_SUPPORT_NO")!);
                    },
                    child: prefs != null ? prefs!.getString("PREF_SUPPORT_NO") != null ? Icon(Icons.support_agent_outlined) : Container() : Container(),
                  )
                ],
              )
          ),
          backgroundColor: Colors.white,
        ),
        body: dashboardView()
    );
  }

  Widget dashboardView(){
    // objectStore = Provider.of<ObjectStore>(context);
    // eventsStore = Provider.of<EventsStore>(context);
    // dashboardStore = Provider.of<DashboardStore>(context);
    // devicesList = objectStore.objects;
    // devicesSettingsList = objectStore.objectSettings;



    return ListView(
      children: [
        fleetStatus(),
        Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child:alertStatus())
            ]),
        //fleetIdle(),
        Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(child:maintenanceRemainder()),
            ]),
        RenewalRemainder()
      ],
    );
  }



  Widget fleetStatus(){

    double all =  _allVehicles.length.toDouble(), moving = _runningVehicles.length.toDouble(), idle = _idleVehicles.length.toDouble(), stop = _stoppedVehicles.length.toDouble(), disconnect = 0, noData = _inactiveVehicles.length.toDouble(), expired =0;

    // devicesList.forEach((key, d) {
    //   all++;
    //   if(d.status !=  false) {
    //     if (Util.getDeviceStatusType(d, devicesSettingsList, key) ==
    //         IS_MOVING) {
    //       moving++;
    //     } else
    //     if (Util.getDeviceStatusType(d, devicesSettingsList, key) == IS_IDLE) {
    //       idle++;
    //     } else
    //     if (Util.getDeviceStatusType(d, devicesSettingsList, key) == IS_STOP) {
    //       stop++;
    //     } else if (Util.getDeviceStatusType(d, devicesSettingsList, key) ==
    //         IS_INACTIVE) {
    //       disconnect++;
    //     } else if (Util.getDeviceStatusType(d, devicesSettingsList, key) ==
    //         IS_NO_DATA) {
    //       noData++;
    //     } else if (Util.getDeviceStatusType(d, devicesSettingsList, key) ==
    //         IS_EXPIRED) {
    //       expired++;
    //     }
    //   }else{
    //     noData++;
    //   }
    // });

    final colorList = <Color>[
      MyColor.ONLINE_COLOR,
      MyColor.IDLE_COLOR,
      MyColor.STOP_COLOR,
      MyColor.INACTIVE_COLOR,
      Colors.black,
    ];

    final dataMap = <_PieData>[
      _PieData('Moving', moving, moving.toStringAsFixed(0),  MyColor.ONLINE_COLOR,),
      _PieData('Idle', idle, idle.toStringAsFixed(0), MyColor.IDLE_COLOR,),
      _PieData('Stop', stop, stop.toStringAsFixed(0), MyColor.STOP_COLOR),
      _PieData('Inactive', disconnect, disconnect.toStringAsFixed(0), MyColor.INACTIVE_COLOR),
      _PieData('No Data', noData, noData.toStringAsFixed(0), Colors.black),
    ];


    return Card(
      child:
      Container(
          padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fleet Status', style: TextStyle(fontWeight: FontWeight.bold),),
              Divider(),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width / 1.1,
                      alignment: Alignment.center,
                      child:SfCircularChart(
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.right
                          ),
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                                widget:  Text(all.toStringAsFixed(0),
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 25))),
                          ],
                          series: <DoughnutSeries<_PieData, String>>[
                            DoughnutSeries<_PieData, String>(
                                explode: true,
                                explodeOffset: '10%',
                                radius: '100%',
                                innerRadius: '60%',
                                onPointTap: (val){
                                  // print(dataMap[val.pointIndex!].xData);
                                  if(dataMap[val.pointIndex!].xData == "Moving"){
                                    // widget.parent!.setState(() {
                                    //   Util.selectedIndex = 2;
                                    //   objectFilter  = 1;
                                    // });
                                  }else if(dataMap[val.pointIndex!].xData == "Idle"){
                                    // widget.parent!.setState(() {
                                    //   Util.selectedIndex = 2;
                                    //   objectFilter  = 2;
                                    // });
                                  }else if(dataMap[val.pointIndex!].xData == "Stop"){
                                    // widget.parent!.setState(() {
                                    //   Util.selectedIndex = 2;
                                    //   objectFilter  = 3;
                                    // });
                                  }else if(dataMap[val.pointIndex!].xData == "Inactive"){
                                    // widget.parent!.setState(() {
                                    //   Util.selectedIndex = 2;
                                    //   objectFilter  = 4;
                                    // });
                                  }else if(dataMap[val.pointIndex!].xData == "No Data"){
                                    // widget.parent!.setState(() {
                                    //   Util.selectedIndex = 2;
                                    //   objectFilter  = 5;
                                    // });
                                  }
                                },
                                dataSource: dataMap,
                                xValueMapper: (_PieData data, _) => data.xData,
                                yValueMapper: (_PieData data, _) => data.yData,
                                dataLabelMapper: (_PieData data, _) => data.text,
                                pointColorMapper: (_PieData data, _) => data.color,
                                dataLabelSettings: DataLabelSettings(isVisible: true,
                                    showZeroValue : false,
                                    labelPosition: ChartDataLabelPosition.inside,
                                    color: Colors.white30,
                                    useSeriesColor: true,
                                    borderColor: Colors.white30,
                                    borderWidth: 10,
                                    borderRadius: 0.2
                                )),
                          ]
                      ))
                ],
              )
            ],
          )
      ),
    );
  }

  Widget alertStatus(){
    return InkWell(
        onTap: (){
          Navigator.pushNamed(context, "/alerts");
        }, child:Card(
        child:   Container(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alert', style: TextStyle(fontWeight: FontWeight.bold),),
                  Divider(),
                  loadEventsData(),
                ]
            ))
    ));
  }

  Widget loadEventsData() {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationsPage()),
        );
      },
      child:Container(
          padding: EdgeInsets.only(top:10, bottom: 10, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AssetsRes.WARNING, width: 60,),
              Text('Alerts : '+eventList.length.toString(), style: TextStyle(color: MyColor.primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          )),
    );
  }

  Future<void> getnotiList() async {
    gpsapis api = new gpsapis();
    try {
      eventList = await api.getEventsList(StaticVarMethod.user_api_hash);
      if (eventList.isNotEmpty) {

        setState(() {});
      } else {
      }
    }
    catch (e) {
      Fluttertoast.showToast(msg: 'Not exist', toastLength: Toast.LENGTH_SHORT);
    }
  }

  // Widget fleetIdle(){
  //   return Card(
  //       child:   Container(
  //           padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
  //           alignment: Alignment.centerLeft,
  //           child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(('fleetIdle').tr(), style: TextStyle(fontWeight: FontWeight.bold),),
  //                 Divider(),
  //               ]
  //           ))
  //   );
  // }

  Widget maintenanceRemainder(){
    return InkWell(
        onTap: (){
          Navigator.pushNamed(context, "/maintenanceRemainder");
        },child: Card(
        child:   Container(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Maintenance Remainder', style: TextStyle(fontWeight: FontWeight.bold),),
                  Divider(),
                  loadMaintenanceData()
                ]
            ))
    ));
  }

  Widget loadMaintenanceData() {
    return Container(
      padding: EdgeInsets.only(top:10, bottom: 10, right: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AssetsRes.MAINTENANCE_REMAINDER, width: 50,),
          Text('Maintenance Remainder : '+'0', style: TextStyle(color: MyColor.primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget RenewalRemainder(){
    return InkWell(
        onTap: (){
          Navigator.pushNamed(context, "/renewalRemainder");
        },child:Card(
        child:   Container(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RenewalRemainder', style: TextStyle(fontWeight: FontWeight.bold),),
                  Divider(),
                  loadRemainderData()
                ]
            ))
    ));
  }

  Widget loadRemainderData() {
    List<dynamic> devices = [];

    // objectStore.objectSettings.forEach((key, value) {
    //   if(value[33] != "0000-00-00"){
    //     DateTime now = DateTime.now();
    //     DateTime date =  DateTime.parse(value[33].toString());
    //     if(now.isAfter(date)){
    //       devices.add(value);
    //     }
    //   }
    // });

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/renewalRemainder");
      },
      child:Container(
          padding: EdgeInsets.only(top:10, bottom: 10, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(AssetsRes.CARD, width: 60,),
              Text('Renewal Remainder : '+devices.length.toString(), style: TextStyle(color: MyColor.primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          )),
    );

  }
}
class _PieData {
  _PieData(this.xData, this.yData, this.text, this.color);
  final String xData;
  final num yData;
  final String text;
  final Color color;
}