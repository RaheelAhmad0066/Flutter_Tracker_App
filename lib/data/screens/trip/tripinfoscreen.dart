import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maktrogps/bloc/history/bloc/history_bloc.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/gpsserver/datasources.dart';

import 'package:maktrogps/data/model/PlayBackRoute.dart';
import 'package:maktrogps/data/model/events.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:maktrogps/data/screens/playback.dart';


import 'package:maktrogps/mapconfig/CommonMethod.dart';

import 'package:http/http.dart' as http;

class tripinfoscreen extends StatefulWidget {

  @override
  _tripinfoscreenState createState() => _tripinfoscreenState();
}

class _tripinfoscreenState extends State<tripinfoscreen> {


  bool isLoading = true;

  HistoryBloc historybloc = HistoryBloc();

  @override
  initState() {
    historybloc.add(HistoryInitialFetchEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //return noNotificationScreen();
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(

          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
         title:  Text(''+StaticVarMethod.deviceName,
             style: TextStyle(color: Colors.black,fontSize: 15)),
         // title: Image.asset('assets/appsicon/trackon.png', height: 40),

        ),

        body: BlocConsumer<HistoryBloc, HistoryState>(
          bloc : historybloc,
          listenWhen: (previous,current) => current is HistoryActionState,
          buildWhen: (previous,current) => current is !HistoryActionState,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch(state.runtimeType){
              case HistoryFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case HistoryFetchingSuccessfulState:
                final successState= state as HistoryFetchingSuccessfulState;
                return Container(
                  child: ListView.builder(
                      itemCount: successState.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            child: listViewItems(successState.list[index],index)
                           // onTap: () => onTapped()
                        );
                      }),
                );
              default:
                return const SizedBox();
            }
            return Container();
          },
        ),

    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: Colors.white,

      title: Text("Notification", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }

  // Widget listView() {
  //   return ListView.builder(
  //       itemCount: driveList.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return GestureDetector(
  //             child: listViewItems(index),
  //             onTap: () => onTapped());
  //       });
  // }

  onTapped() async {
    /* Consts.DocId=approvalModel.DocId;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GetApproval(loginModel: loginModel)),
    );*/
  }


  Widget listViewItems(TripsItems model ,int index) {
    return (model.time != null)?Container(
        margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
        child: GestureDetector(
          onTap: () {

            String str1= model.show.toString().substring(0,10);
            String str2= model.show.toString().substring(11,19);

            String str3= model.left.toString().substring(0,10);
            String str4= model.left.toString().substring(11,19);
            StaticVarMethod.fromdate = str1;
            StaticVarMethod.fromtime = str2;
            StaticVarMethod.todate =str3 ;
            StaticVarMethod.totime = str4;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlaybackPage()),
            );

          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              color: Colors.white,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //prefixIcon(index),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 8, right: 30, top: 8, bottom: 15),

                        child: Column(
                          children: [
                            //DeleteIcon(index),
                            //message(index),
                            movinglistdesign(model, index),
                            const Divider(color: Colors.black),
                           // stoplistdesign(model),
                          ],
                        ),
                      ),
                    ),
                  ]
              )
          ),
        )
    ):Container();
  }


  Widget prefixIconinfo() {
    return
      Container(
        height: 55,
        width: 55,
        margin: EdgeInsets.only(top: 15, left: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image.asset(
            "assets/settingicon/aboutus.png", height: 55, width: 55),
        /* child: Icon(Icons.notifications,
          size: 25,
          color:Colors.grey.shade700),*/
      );
  }


  Widget movinglistdesign(TripsItems model,int index) {

    return Container(
      //margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Trip # "+ (index).toString(), style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                ),
                ),
                Text("Start:", style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                ),
              //  Text(formatTime(model.show.toString()),
                    Text(model.show.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text("Distance: " + model.distance.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Duration: " + model.time.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text("End:", style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                ),
                Text(model.left
                    .toString() /*+eventList[index].time.toString()*/,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),

              ]
          )
        ],
      ),
    );
  }

  Widget stoplistdesign(TripsItems model) {
    return Container(
      //margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text("Stopped:", style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.bold
                ),
                ),
                Text("Start:", style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                ),
                Text(
                  model.show.toString(), style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                ),
              ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Duration: " + model.time.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text("End:", style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
                ),
                Text(model.left
                    .toString() /*+eventList[index].time.toString()*/,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ]
          )
        ],
      ),
    );
  }


  Widget noNotificationScreen() {
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    final pageTitle = Padding(
      padding: EdgeInsets.only(top: 1.0, bottom: 30.0),
      child: Text(
        "Trips ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40.0,
        ),
      ),
    );

    final image = Image.asset("assets/images/empty.png");

    final notificationHeader = Container(
      padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
      child: Text(
        "No New Trips are available",
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24.0),
      ),
    );
    final notificationText = Text(
      "You currently do not have any unread Trips.",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        color: Colors.grey.withOpacity(0.6),
      ),
      textAlign: TextAlign.center,
    );

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 70.0,
          left: 30.0,
          right: 30.0,
          bottom: 30.0,
        ),
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            pageTitle,
            SizedBox(
              height: deviceHeight * 0.1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[image, notificationHeader, notificationText],
            ),
          ],
        ),
      ),
    );
  }


  _showProgress(bool status) {
    if (status) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: [
                CircularProgressIndicator(),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text('Loading ...')),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }
}
