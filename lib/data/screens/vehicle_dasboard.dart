
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maktrogps/bloc/kmandfuelhistory/bloc/kmandfuelhistory_bloc.dart';
import 'package:maktrogps/config/apps/ecommerce/global_style.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/model/PositionHistory.dart';
import 'package:maktrogps/data/model/devices.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:maktrogps/mapconfig/CommonMethod.dart';
import 'package:http/http.dart' as http;
import 'package:maktrogps/mvvm/view_model/objects.dart';
import 'package:provider/provider.dart';



class vehicle_dasboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _vehicle_dasboard();
}

class _vehicle_dasboard extends State<vehicle_dasboard> {



  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();

  var selectedToTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedTripInfoToTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedFromTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedTripInfoFromTime =  TimeOfDay.fromDateTime(DateTime.now());
  var fromTime=        DateFormat("HH:mm:ss").format(DateTime.now());
  var fromTripInfoTime=        DateFormat("HH:mm:ss").format(DateTime.now());
  var toTime=  DateFormat("HH:mm:ss").format(DateTime.now());
  var toTripInfoTime=  DateFormat("HH:mm:ss").format(DateTime.now());
  String distance_sum="O KM";
  String top_speed="O KM";
  String move_duration="Os";
  String stop_duration="Os";
  String fuel_consumption="O ltr";
  String stopcount="O";
  var startdate;
  var enddate;
  KmandfuelHistoryBloc kmhistorybloc = KmandfuelHistoryBloc();

  late ObjectStore objectStore;
  //History _history=History();
  List<deviceItems> devicesList = [];

  @override
  initState() {

    kmhistorybloc.add(KmandfuelHistoryInitialFetchEvent());
    super.initState();

   // showReport1(0, "Today");
  }


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Provider.of<ObjectStore>(context, listen: true).getHistory(StaticVarMethod.deviceId);
    // objectStore = Provider.of<ObjectStore>(context);
    // History _history = objectStore.history;
    // print(_history);

    objectStore = Provider.of<ObjectStore>(context);
    devicesList = objectStore.objects;


    var devicemodel= devicesList.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;
    if (devicemodel !=null ) {
      // updateMarker(devicemodel);
      //  isLoading = false;
      //  noData = false;
    }else{
      setState(() {
        //isLoading = false;
        // noData = true;
      });
    }

    return Scaffold(
      backgroundColor: Color(0xffF8F7FC),
      appBar: AppBar(
        title: Text(StaticVarMethod.deviceName.toString(),
            style: TextStyle(color: Colors.black,fontSize: 15)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          // action button

        ],
        backgroundColor: Colors.white,
       // backgroundColor: Color(0xff0D3D65),
      ),
      body: ListView(
          children: <Widget>
          [


            playBackControls(devicemodel),
          ]),
    );
  }
  String? selectedValue;
  List<String> items = [
    'Today',
    'Yesterday',
    '2 days ago',
  ];
  Widget playBackControls(deviceItems devicemodel) {


    String other =devicemodel.deviceData!.traccar!.other.toString();
    String ignition="true";
    String enginehours="0h";
    String sat="0";


    if(other.contains("<ignition>")){
      const start = "<ignition>";
      const end = "</ignition>";
      final startIndex = other.indexOf(start);
      final endIndex = other.indexOf(end, startIndex + start.length);
      ignition = other.substring(startIndex + start.length, endIndex);
    }
    if(other.contains("<enginehours>")){
      const start = "<enginehours>";
      const end = "</enginehours>";
      final startIndex = other.indexOf(start);
      final endIndex = other.indexOf(end, startIndex + start.length);
      enginehours = other.substring(startIndex + start.length, endIndex);
    }
    if(other.contains("<sat>")){
      const start = "<sat>";
      const end = "</sat>";
      final startIndex = other.indexOf(start);
      final endIndex = other.indexOf(end, startIndex + start.length);
      sat = other.substring(startIndex + start.length, endIndex);
    }

    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 20),

      decoration: BoxDecoration(
        color: Color(0xffF8F7FC),
        /* borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 20,
                offset: const Offset(0.0, 10.0)
               // color: Colors.grey.withOpacity(0.5)
            )
          ]*/),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          // Container(
          //   margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
          //   height: 55,
          //   width: 50,
          //   child: Row(
          //       children: [
          //         Text('Filter',
          //             style: TextStyle(
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w400,
          //                 color: Color(0xff8E8E8E)
          //             )),
          //       ]
          //   ),
          // ),
          // Container(
          //   //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
          //   height: 55,
          //   width: 320,
          //   child: Row(
          //       children: [
          //         Expanded(
          //           child:Card(
          //               shape: RoundedRectangleBorder(
          //                 side: BorderSide(
          //                   color: Color(0xff284B69), //<-- SEE HERE
          //                 ),
          //                 borderRadius: BorderRadius.circular(5),
          //               ),
          //               elevation: 0,
          //               color: Color(0xffF8F7FC),
          //               child: Container(
          //                 //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //                   color:Color(0xffF8F7FC),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Center(
          //                         child: DropdownButtonHideUnderline(
          //                           child: DropdownButton(
          //                             hint: Text(
          //                               'Today',
          //                               style: TextStyle(
          //                                 fontSize: 14,
          //                                 color: Color(0xff0D3D65),
          //                               ),
          //                             ),
          //                             items: items
          //                                 .map((item) =>
          //                                 DropdownMenuItem<String>(
          //                                   value: item,
          //                                   child: Text(
          //                                     item,
          //                                     style: const TextStyle(
          //                                       fontSize: 12,
          //                                       color: Color(0xff0D3D65),
          //                                     ),
          //                                   ),
          //                                 ))
          //                                 .toList(),
          //                             value: selectedValue,
          //                             onChanged: (value) {
          //                               setState(() {
          //                                 selectedValue = value as String;
          //                               });
          //                             },
          //
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   )
          //               )),
          //         ),
          //       ]
          //   ),
          // ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
            height: 75,
            width: 345,
            child: Row(
                children: [
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('IME',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff284B69),
                                                  //height: 0.8,
                                                  // fontFamily: 'digital_font'
                                                  fontWeight: FontWeight.normal
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15,top: 5),
                                          child: Text(''+StaticVarMethod.imei,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8E8E8E),
                                                //height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/barcode.png",
                                          height: 30,width: 30)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Plate Number',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff284B69),
                                                // fontFamily: 'digital_font'

                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+StaticVarMethod.deviceName,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff8E8E8E),
                                                //fontWeight: FontWeight.bold,
                                                // height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ))
                  ),
                ]
            ),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
            height: 75,
            width: 345,
            child: Row(
                children: [
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Sim Number',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff284B69),
                                                // fontFamily: 'digital_font'

                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+devicemodel.deviceData!.simNumber.toString(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff8E8E8E),
                                                //fontWeight: FontWeight.bold,
                                                // height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ))
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Protocol',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff284B69),
                                                  //height: 0.8,
                                                  // fontFamily: 'digital_font'
                                                  fontWeight: FontWeight.normal
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+devicemodel!.protocol.toString(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8E8E8E),
                                                //height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/speed_meter.png",
                                          height: 20,width: 20)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                ]
            ),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
            height: 75,
            width: 345,
            child: Row(
                children: [
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Expiry Day',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff284B69),
                                                // fontFamily: 'digital_font'

                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+devicemodel.deviceData!.expirationDate.toString(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff8E8E8E),
                                                //fontWeight: FontWeight.bold,
                                                // height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/calendar.png",
                                          height: 20,width: 20)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Device Model',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff284B69),
                                                  //height: 0.8,
                                                  // fontFamily: 'digital_font'
                                                  fontWeight: FontWeight.normal
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+devicemodel.deviceData!.deviceModel.toString(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8E8E8E),
                                                //height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/device.png",
                                          height: 25,width: 25)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                ]
            ),
          ),
          Container(
            //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
            height: 75,
            width: 345,
            child: Row(
                children: [
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Internet',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff284B69),
                                                // fontFamily: 'digital_font'

                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+devicemodel!.online.toString(),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff8E8E8E),
                                                //fontWeight: FontWeight.bold,
                                                // height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/wifi.png",
                                          height: 25,width: 25)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      bottomLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2.0,
                                        offset:  Offset(0.5, 4.0)
                                    )
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          child: Text('Satellite',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xff284B69),
                                                  //height: 0.8,
                                                  // fontFamily: 'digital_font'
                                                  fontWeight: FontWeight.normal
                                              )),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5,left: 15,),
                                          child: Text(''+sat,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8E8E8E),
                                                //height: 1.7,
                                                //fontFamily: 'digital_font'
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                      child: Image.asset("assets/speedoicon/gps.png",
                                          height: 20,width: 20)),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                          ))
                  ),
                ]
            ),
          ),
//           Container(
//             //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
//             height: 75,
//             width: 170,
//             child: Row(
//                 children: [
//                   Expanded(
//                       child:Card(
// /*
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
// */
//                           color: Colors.white,
//                           child: Container(
//                             //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(5.0),
//                                       bottomLeft: Radius.circular(5.0),
//                                       topRight: Radius.circular(5.0),
//                                       bottomRight: Radius.circular(5.0)),
//                                   color: Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26,
//                                         blurRadius: 2.0,
//                                         offset:  Offset(0.5, 4.0)
//                                     )
//                                   ]
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           margin: EdgeInsets.only(left: 15),
//                                           child: Text('Engine Hours',
//                                               style: TextStyle(
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.normal,
//                                                 color: Color(0xff284B69),
//                                                 // fontFamily: 'digital_font'
//
//                                               )),
//                                         ),
//                                         Container(
//                                           margin: EdgeInsets.only(top: 5,left: 15,),
//                                           child: Text(''+enginehours.toString(),
//                                               style: TextStyle(
//                                                 fontSize: 11,
//                                                 color: Color(0xff8E8E8E),
//                                                 //fontWeight: FontWeight.bold,
//                                                 // height: 1.7,
//                                                 //fontFamily: 'digital_font'
//                                               )),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   ClipRRect(
//                                       borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                       child: Image.asset("assets/speedoicon/truck.png",
//                                           height: 25,width: 25)),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                 ],
//                               )
//                           ))
//                   ),
//                 ]
//             ),
//           ),

          Container(
            margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
            child:  BlocConsumer<KmandfuelHistoryBloc, KmandfuelHistoryState>(
              bloc : kmhistorybloc,
              listenWhen: (previous,current) => current is KmandfuelHistoryActionState,
              buildWhen: (previous,current) => current is !KmandfuelHistoryActionState,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                switch(state.runtimeType){
                  case KmandfuelHistoryFetchingLoadingState:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case KmandfuelHistoryFetchingSuccessfulState:
                    final successState= state as KmandfuelHistoryFetchingSuccessfulState;

                    startdate= successState.history.items!.first;
                    enddate= successState.history.items!.last;



                    startdate=startdate.show;
                    enddate=enddate.show;
                    // startdate=startdate['average_speed'];
                    print(startdate);
                    // var sumofspeed=value.items!.map((m) => m['average_speed'] as int).reduce((a, b) => a + b);

                    //  var result = value.items!.map((m) => m['average_speed']).reduce((a, b) => a + b) / value.items!.length;
                    // print(result);





                      top_speed=successState.history.topSpeed.toString();
                      move_duration=successState.history.moveDuration.toString();
                      stop_duration=successState.history.stopDuration.toString();
                      fuel_consumption=successState.history.fuelConsumption.toString();
                      distance_sum=successState.history.distanceSum.toString();
                      stopcount=((successState.history.items!.length /2)).toStringAsFixed(0);

                    num? avgspeed=0;
                    num? engineidle=0;
                    num? enginework=0;
                    for (var i = 0; i < successState.history.items!.length; i++) {
                      if(successState.history.items![i].averageSpeed !=null){
                        num? hjg= successState.history.items![i].averageSpeed;
                        avgspeed=avgspeed! + hjg! /successState.history.items!.length;
                      }
                      if(successState.history.items![i].engineIdle !=null){
                        num? hjg= successState.history.items![i].engineIdle;
                        engineidle=engineidle! + hjg!;
                      }
                      if(successState.history.items![i].engineWork !=null){
                        num? hjg= successState.history.items![i].engineWork;
                        enginework=enginework! + hjg!;
                      }




                      print(successState.history.items![i]);
                      print(avgspeed);
                    }
                  // var jhdj= successState.history.items![1].averageSpeed;
                  //  var result = successState.history.items!.map((m) => int.parse(m.averageSpeed.toString())).reduce((a, b) => a + b) / successState.history.items!.length;

                    print(successState);
                    return   Column(
                      children: [
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Route Start',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15,top: 5),
                                                        child: Text(''+startdate.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/route_end.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Route end',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15,top: 5),
                                                        child: Text(''+enddate.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/route_end.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Route end',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15,top: 5),
                                                        child: Text(''+enddate.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/route_end.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Today Km',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+successState.history.distanceSum.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/route_end.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Move Duration'+'',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+move_duration,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/car.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Stop Duration',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+stop_duration,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/hand.png",
                                                        height: 25,width: 25)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Stop  Count',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+stopcount.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/hand.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Top Speed',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+top_speed,
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/battery_sign.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Average'+' Speed',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+avgspeed.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/clock.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Overspeed Count',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text('0',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/clock.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Fuel'+' Consumption',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+fuel_consumption.toString(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/fuel_machine.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Fuel Cost',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(' 0',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/fuel_machine.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),

                        Container(
                          //  margin: EdgeInsets.fromLTRB(80, 1, 80, 1),
                          height: 75,
                          width: 345,
                          child: Row(
                              children: [
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Engine'+' Idle',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff284B69),
                                                              // fontFamily: 'digital_font'

                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+engineidle.toString() +' sec',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Color(0xff8E8E8E),
                                                              //fontWeight: FontWeight.bold,
                                                              // height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/engine.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                    child:Card(
/*
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
*/
                                        elevation: 0,
                                        color: Colors.white,
                                        child: Container(
                                          //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(5.0),
                                                    bottomLeft: Radius.circular(5.0),
                                                    topRight: Radius.circular(5.0),
                                                    bottomRight: Radius.circular(5.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 2.0,
                                                      offset:  Offset(0.5, 4.0)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 15),
                                                        child: Text('Engine Work',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Color(0xff284B69),
                                                                //height: 0.8,
                                                                // fontFamily: 'digital_font'
                                                                fontWeight: FontWeight.normal
                                                            )),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 5,left: 15,),
                                                        child: Text(''+enginework.toString() +' sec',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.normal,
                                                              color: Color(0xff8E8E8E),
                                                              //height: 1.7,
                                                              //fontFamily: 'digital_font'
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.all(Radius.circular(4)),
                                                    child: Image.asset("assets/speedoicon/engine.png",
                                                        height: 20,width: 20)),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            )
                                        ))
                                ),
                              ]
                          ),
                        ),
                      ],
                    );
                  case KmandfuelHistoryFetchingErrorState:
                    return Center(child: Text("No Data"),);

                  default:
                    return const SizedBox();
                }
                return Container();
              },
            ),
          ),




        ],
      ),
    );
  }




  void showReport1(int _selectedperiod,String currentday) {
    String fromDate;
    String toDate;
    String fromTime;
    String toTime;

    DateTime current = DateTime.now();

    String month;
    String day;
    if (current.month < 10) {
      month = "0" + current.month.toString();
    } else {
      month = current.month.toString();
    }

    if (current.day < 10) {
      day = "0" + current.day.toString();
    } else {
      day = current.day.toString();
    }

    if (_selectedperiod == 0) {
      String today;

      int dayCon = current.day + 1;
      if (dayCon <= 10) {
        today = "0" + dayCon.toString();
      } else {
        today = dayCon.toString();
      }

      var date = DateTime.parse("${current.year}-"
          "$month-"
          "$today "
          "00:00:00");
      fromDate = formatDateReport(DateTime.now().toString());
      toDate = formatDateReport(date.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";

      StaticVarMethod.fromdate = formatDateReport(DateTime.now().toString());
      StaticVarMethod.todate = formatDateReport(date.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else if (_selectedperiod == 1) {
      String yesterday;

      int dayCon = current.day - 1;
      if (current.day <= 10) {
        yesterday = "0" + dayCon.toString();
      } else {
        yesterday = dayCon.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else if (_selectedperiod == 2) {
      String yesterday;

      int dayCon = current.day - 2;
      if (current.day <= 10) {
        yesterday = "0" + dayCon.toString();
      } else {
        yesterday = dayCon.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    }
    else if (_selectedperiod == 3) {
      String yesterday;

      int dayCon = current.day - 3;
      if (current.day <= 10) {
        yesterday = "0" + dayCon.toString();
      } else {
        yesterday = dayCon.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    }
    else if (_selectedperiod == 2) {
      String sevenDay, currentDayString;
      int dayCon = current.day - current.weekday;
      int currentDay = current.day;
      if (dayCon < 10) {
        sevenDay = "0" + dayCon.abs().toString();
      } else {
        sevenDay = dayCon.toString();
      }
      if (currentDay < 10) {
        currentDayString = "0" + currentDay.toString();
      } else {
        currentDayString = currentDay.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$sevenDay "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$currentDayString "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else {
      String startMonth, endMoth;
      if (_selectedFromDate.month < 10) {
        startMonth = "0" + _selectedFromDate.month.toString();
      } else {
        startMonth = _selectedFromDate.month.toString();
      }

      if (_selectedToDate.month < 10) {
        endMoth = "0" + _selectedToDate.month.toString();
      } else {
        endMoth = _selectedToDate.month.toString();
      }

      String startHour, endHour;
      if (selectedFromTime.hour < 10) {
        startHour = "0" + selectedFromTime.hour.toString();
      } else {
        startHour = selectedFromTime.hour.toString();
      }

      String startMin, endMin;
      if (selectedFromTime.minute < 10) {
        startMin = "0" + selectedFromTime.minute.toString();
      } else {
        startMin = selectedFromTime.minute.toString();
      }

      if (selectedToTime.minute < 10) {
        endMin = "0" + selectedToTime.minute.toString();
      } else {
        endMin = selectedToTime.minute.toString();
      }

      if (selectedToTime.hour < 10) {
        endHour = "0" + selectedToTime.hour.toString();
      } else {
        endHour = selectedToTime.hour.toString();
      }

      String startDay, endDay;
      if (_selectedFromDate.day <= 10) {
        if (_selectedFromDate.day == 10) {
          startDay = _selectedFromDate.day.toString();
        } else {
          startDay = "0" + _selectedFromDate.day.toString();
        }
      } else {
        startDay = _selectedFromDate.day.toString();
      }

      if (_selectedToDate.day <= 10) {
        if (_selectedToDate.day == 10) {
          endDay = _selectedToDate.day.toString();
        } else {
          endDay = "0" + _selectedToDate.day.toString();
        }
      } else {
        endDay = _selectedToDate.day.toString();
      }

      var start = DateTime.parse("${_selectedFromDate.year}-"
          "$startMonth-"
          "$startDay "
          "$startHour:"
          "$startMin:"
          "00");

      var end = DateTime.parse("${_selectedToDate.year}-"
          "$endMoth-"
          "$endDay "
          "$endHour:"
          "$endMin:"
          "00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = formatTimeReport(start.toString());
      toTime = formatTimeReport(end.toString());

      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime = formatTimeReport(start.toString());
      StaticVarMethod.totime = formatTimeReport(end.toString());
    }

    print(fromDate);
    print(toDate);

    // Navigator.pop(context);

    getReport1(StaticVarMethod.deviceId,StaticVarMethod.fromdate,StaticVarMethod.fromtime,StaticVarMethod.todate,StaticVarMethod.totime,currentday);
    /* Navigator.pushNamed(context, "/reportList",
        arguments: ReportArguments(device['id'], fromDate, fromTime,
            toDate, toTime, device["name"], 0));*/

  }


  Future<void> getHistory(String deviceID, String fromDate,
      String fromTime, String toDate, String toTime, String currentday) async {
    final response = await http.get(Uri.parse(StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime&device_id=$deviceID"));
    if (response.statusCode == 200) {
      try {
        List<AllItems> list = [];
        var history = History.fromJson(json.decode(response.body));
        for (var i = 0; i < history.items!.length; i++) {
          for (var p in history.items![i].items ?? []) {
            list.add(p);
          }
        }
      } catch (Ex) {
        print(Ex);
        print("Error occurred");
        //History model = new  History();
        // return model;
      }
    } else {
      print(response.statusCode);
      /* List<History> list=[];
      return list;*/
      //History model = new  History();
      //return model;
    }
  }

  Future<PositionHistory?> getReport1(String deviceID, String fromDate,
      String fromTime, String toDate, String toTime, String currentday ) async {
    var kljkl="";
    final response = await http.get(Uri.parse(StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime&device_id=$deviceID")).timeout(const Duration(milliseconds: 500));
    print(response.request);
    if (response.statusCode == 200) {
      print(
          "dod${StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date=$fromDate&from_time=$fromTime&to_date=$toDate&to_time=$toTime&device_id=$deviceID"}");

      var decodedata=json.decode(response.body);
      var value = History.fromJson(decodedata);

      //var value= PositionHistory.fromJson(decodedata);
      if (value!.items?.length != 0)
      {
        /* value.items?.forEach((element) {
          var startdate= element['show'];
          var enddate= element['show'];
          element['items'].forEach((element) {
            element['show'].last;
            element['show'].last;
          });
        });*/

        for (var i = 0; i < value.items!.length; i++) {
          print(value.items![i]);
        }
        startdate= value.items!.first;
        enddate= value.items!.last;



        startdate=startdate['show'];
        enddate=enddate['show'];
       // startdate=startdate['average_speed'];
        print(startdate);
       // var sumofspeed=value.items!.map((m) => m['average_speed'] as int).reduce((a, b) => a + b);

      //  var result = value.items!.map((m) => m['average_speed']).reduce((a, b) => a + b) / value.items!.length;
       // print(result);




        setState(() {
          top_speed=value.topSpeed.toString();
          move_duration=value.moveDuration.toString();
          stop_duration=value.stopDuration.toString();
          fuel_consumption=value.fuelConsumption.toString();
          distance_sum=value.distanceSum.toString();
          stopcount=value.items!.length.toString();
        });


      }
      else
      {
        // _timer.cancel(),
        /*   AlertDialogCustom().showAlertDialog(
            context,
            'NoData',
            'Failed',
            'Ok');*/
      }
    } else {
      print(response.statusCode);
      return null;
    }
  }

}
