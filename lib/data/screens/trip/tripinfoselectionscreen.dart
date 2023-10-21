import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maktrogps/config/custom_image_assets.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/screens/trip/tripinfoscreen.dart';
import 'package:maktrogps/mapconfig/CommonMethod.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;
import 'package:maktrogps/utils/Consts.dart';
import 'package:intl/intl.dart';


class tripinfoselectionscreen extends StatefulWidget {
  @override
  _reportselection createState() => _reportselection();
}

class _reportselection extends State<tripinfoselectionscreen> {
  // initialize global widget

  bool _doneListing = false;
  bool _val = false;
  bool _val1 = false;
  bool _val2 = false;
  var startdate;
  var enddate;
  var starttime;
  var endtime;
  //date time hepers
  int _selectedperiod = 0;


  List<String> _reportliststr = ["General information","Drives and stops","Geofence in/out","Events","Work hours daily"];

  List<String> _devicesListstr=[];
  String _selectedReport = "";

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

  String? _chosenValueduratrion;
  String? _chosenValue1;
  @override
  void initState() {

    super.initState();
    getdeviesList();


  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getdeviesList() async {
    _devicesListstr.clear();

    for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
      _devicesListstr.add(StaticVarMethod.devicelist.elementAt(i).name!);
    }

    setState(() {

    });

    /*  if (locationList.isEmpty) {

      }*/

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F7FC),
      appBar: AppBar(
        elevation: 0,
        title: Text(''+StaticVarMethod.deviceName,
            style: TextStyle(color: Colors.white,fontSize: 15)),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: <Widget>[
          // action button

        ],
        backgroundColor: Color(0xff0D3D65),
      ),//_globalWidget.globalAppBar(),
      body: Stack(
        children: [

          reportControls(),

        ],
      ),
    );
  }



  Widget reportControls() {

    return  Container(
      padding: EdgeInsets.only(left: 18,right: 15,top: 10,bottom: 30),

      decoration: BoxDecoration(
          color: Color(0xffF8F7FC),
          borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20) ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Container(
            margin: EdgeInsets.fromLTRB(12, 1, 0, 1),
            color:Color(0xffF8F7FC),
            height: 30,
            width: 50,
            child: Row(
                children: [
                  Text('Stops',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8E8E8E)
                      )),
                ]
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 0),
            //padding: EdgeInsets.only(left: 10, right: 10),
            height: 43,
            width: 310,
            decoration: BoxDecoration(
              color: Color(0xffF8F7FC),
              border: Border.all(width: 1.5, color: Color(0xff284B69),),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:Card(
/*
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff284B69), //<-- SEE HERE
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
*/
                elevation: 0,
                color: Color(0xffF8F7FC),
                //color: Colors.grey.shade900,
                //shadowColor: Colors.pink,
                child: Container(
                  color: Color(0xffF8F7FC),
                  padding: EdgeInsets.only(left: 90, right: 90,bottom: 0,),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: DropdownButton<String>(
                        isDense: false,
                        icon: Icon(Icons.keyboard_arrow_down_sharp),
                        value: _chosenValueduratrion,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),
                        items: <String>[
                          '1 min',
                          '2 min',
                          '5 min',
                          '10 min',
                          '30 min',
                          '1 Hours',
                          '5 Hours',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "1 min",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _chosenValueduratrion = value!;
                          });
                        },
                      ),
                    ),
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(12, 1, 0, 1),
            color: Color(0xffF8F7FC),
            height: 30,
            width: 50,
            child: Row(
                children: [
                  Text('Filter',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8E8E8E)
                      )),
                ]
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 0),
            //padding: EdgeInsets.only(left: 10, right: 10),
            height: 43,
            width: 310,
            decoration: BoxDecoration(
              color: Color(0xffF8F7FC),
              border: Border.all(width: 1.5, color: Color(0xff284B69),),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:Card(
/*
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xff284B69), //<-- SEE HERE
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
*/
                elevation: 0,
                color: Color(0xffF8F7FC),
                //color: Colors.grey.shade900,
                //shadowColor: Colors.pink,
                child: Container(
                  color: Color(0xffF8F7FC),
                  padding: EdgeInsets.only(left: 70, right: 70,bottom: 0,),
                  child: DropdownButtonHideUnderline(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: DropdownButton<String>(
                        isDense: false,
                        icon: Icon(Icons.keyboard_arrow_down_sharp),
                        value: _chosenValue1,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),
                        items: <String>[
                         // 'Last Hour',
                          'Today',
                          'Yesterday',
                          'Before 2 Days',
                         // 'Before 3 Days',
                          'This Week',
                          'Last Week',
                          //'This Month',
                         // 'Last Month',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            "Today",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onChanged: (String? value) {
                          if(value.toString().contains("Today")){
                            _selectedperiod=1;
                          }else if(value.toString().contains("Yesterday")){
                            _selectedperiod=2;
                          }
                          else if(value.toString().contains("Before 2 Days")){
                            _selectedperiod=3;
                          }else if(value.toString().contains("This Week")){
                            _selectedperiod=4;
                          }else if(value.toString().contains("Last Week")){
                            _selectedperiod=5;
                          }
                          setState(() {
                            print(value.toString());
                          });
                        },
                      ),
                    ),
                  ),
                )),
          ),


          Container(
            margin: EdgeInsets.fromLTRB(12, 2, 0, 1),
            color: Color(0xffF8F7FC),
            height: 30,

            child: Row(
                children: [
                  Text('Select Custom DateTime from',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8E8E8E)
                      )),
                ]
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 0, left: 10, right: 0,bottom: 2,),
              padding: EdgeInsets.only(top: 2,left: 2 ),
              height: 45,
              width: 310,
              decoration: BoxDecoration(
                color: Color(0xffF8F7FC),
                border: Border.all(width: 1.5, color: Color(0xff284B69),),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8F7FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                   // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () => _selectFromDate(
                    context, setState),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        formatReportDate(
                            _selectedFromDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xff8E8E8E),)),
                    ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        child: Image.asset("assets/speedoicon/calendar1.png",
                            height: 20,width: 20,
                          color: Color(0xff8E8E8E),)),

                  ],
                ),
              )),

          Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 0),
              padding: EdgeInsets.only(top: 2,left: 2 ),
              height: 45,
              width: 310,
              decoration: BoxDecoration(
                color: Color(0xffF8F7FC),
                border: Border.all(width: 1.5, color: Color(0xff284B69),),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8F7FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () {setState(() {
                  _fromTime(context);  });

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        formatReportTime(
                            selectedFromTime),
                        style: TextStyle(
                          backgroundColor: Color(0xffF8F7FC),
                          fontSize: 11,
                          color: Color(0xff8E8E8E),)),
                    ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        child: Image.asset("assets/speedoicon/clock1.png",
                            height: 20,width: 20,
                        color: Color(0xff8E8E8E),)),

                  ],
                ),
              )),
//////to time and date
          Container(
            margin: EdgeInsets.fromLTRB(12, 2, 0, 1),
            color: Color(0xffF8F7FC),
            height: 30,
            child: Row(
                children: [
                  Text('Select Custom Datetime TO',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff8E8E8E)
                      )),
                ]
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 0, left: 10, right: 0,bottom: 2,),
              padding: EdgeInsets.only(top: 2,left: 2 ),
              height: 45,
              width: 310,
              decoration: BoxDecoration(
                color: Color(0xffF8F7FC),
                border: Border.all(width: 1.5, color: Color(0xff284B69),),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8F7FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () => _selectToDate(
                    context, setState),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        formatReportDate(
                            _selectedToDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xff8E8E8E),)),
                    ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        child: Image.asset("assets/speedoicon/calendar1.png",
                          height: 20,width: 20,
                          color: Color(0xff8E8E8E),)),

                  ],
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 0),
              padding: EdgeInsets.only(top: 2,left: 2 ),
              height: 45,
              width: 310,
              decoration: BoxDecoration(
                color: Color(0xffF8F7FC),
                border: Border.all(width: 1.5, color: Color(0xff284B69),),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8F7FC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () {setState(() {
                  _toTime(context);  });

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        formatReportTime(
                            selectedToTime),
                        style: TextStyle(
                          backgroundColor: Color(0xffF8F7FC),
                          fontSize: 11,
                          color: Color(0xff8E8E8E),)),
                    ClipRRect(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4)),
                        child: Image.asset("assets/speedoicon/clock1.png",
                          height: 20,width: 20,
                          color: Color(0xff8E8E8E),)),

                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 70, left: 10, right: 0),
            height: 45,
            width: 310,
            child: Row(
              children: [

                Expanded(
                    child:OutlinedButton(
                        onPressed: () {
                          showReport();
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size(0, 45)
                          ),
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) => Color(0xff0D3D65),
                          ),
                          overlayColor: MaterialStateProperty.all(Colors.transparent,),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(
                                color: Color(0xff0D3D65),
                                width: 1.0
                            ),
                          ),
                        ),
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                          textAlign: TextAlign.center,
                        )
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }



  //date time picker
  Future<void> _selectFromDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedFromDate)
      setState(() {
        _selectedFromDate = picked;
      });
  }

  Future<void> _selectToDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedToDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedToDate)
      setState(() {
        _selectedToDate = picked;
      });
  }

  Future<Null> _fromTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime:selectedFromTime,

    );
    if (picked != null && picked != selectedFromTime)
      setState(() {
        selectedFromTime = picked;
        var hour= selectedFromTime.hour;
        var minute= selectedFromTime.minute;
        fromTime ="$hour:$minute:00";
        print(fromTime);
        //var formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
  }

  Future<Null> _toTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime:selectedToTime,

    );
    if (picked != null && picked != selectedToTime)
      setState(() {
        selectedToTime = picked;
        var hour= selectedToTime.hour;
        var minute= selectedToTime.minute;
        toTime ="$hour:$minute:00";
        //  TimeOfDayFormat.H_colon_mm.toString();
        //var formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
  }

  void showReport() {
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

    if (_selectedperiod == 1) {
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
    } else if (_selectedperiod == 2) {
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
    } else if (_selectedperiod == 3) {
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

    //Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => tripinfoscreen()),
    );
    // getReport(StaticVarMethod.deviceId,StaticVarMethod.fromdate,StaticVarMethod.fromtime,StaticVarMethod.todate,StaticVarMethod.totime);
    /* Navigator.pushNamed(context, "/reportList",
        arguments: ReportArguments(device['id'], fromDate, fromTime,
            toDate, toTime, device["name"], 0));*/

  }


}

