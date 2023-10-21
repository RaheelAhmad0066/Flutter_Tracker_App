

import 'dart:async';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktrogps/config/apps/ecommerce/constant.dart';
import 'package:maktrogps/config/apps/food_delivery/global_style.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/gpsserver/model/commandmodel.dart';
import 'package:maktrogps/data/gpsserver/model/cmdmodel.dart';
import 'package:maktrogps/data/model/User.dart';
import 'package:maktrogps/data/screens/livetrackoriginal.dart';
import 'package:maktrogps/data/screens/playback.dart';
import 'package:maktrogps/data/screens/playbackselection.dart';

import 'package:maktrogps/data/screens/reports/kmdetail.dart';
import 'package:maktrogps/data/screens/reports/reportselection.dart';
import 'package:maktrogps/data/screens/reports/vehicle_info.dart';
import 'package:maktrogps/data/screens/signin.dart';
import 'package:maktrogps/ui/reusable/cache_image_network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maktrogps/data/gpsserver/datasources.dart';

import '../../mapconfig/CommonMethod.dart';
import '../model/Command.dart';


class lockscreenNew extends StatefulWidget {
  @override
  _lockscreenNewState createState() => _lockscreenNewState();
}

class _lockscreenNewState extends State<lockscreenNew> {


  List<Command> commands = [];

  List<String> commandsstr = [];

  String selectedcommands="";
  Timer? _timer;
  var _isLoading = true;



  @override
  void initState() {
    _isLoading = true;

    getCommands();
    super.initState();
  }


  void getCommands() {
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      _timer!.cancel();
      Iterable list;
      commandsstr.clear();
      gpsapis.getSavedCommands(StaticVarMethod.deviceId).then((value) => {
        if (value?.body != null)
          {
            list = json.decode(value!.body),
            print(list.length),
            list.forEach((element) {
              Command command = new Command();
              command.id = element["id"];
              command.value = element["type"];
              command.title = element["title"];

              commandsstr.add(command.value!);
              commands.add(command);
            }),
            setState(() {})
          }
      });

    });
  }

  void sendCommand(type) {
    Map<String, String> requestBody;

    requestBody = <String, String>{
      'id': "",
      'device_id': StaticVarMethod.deviceId,
      'type': type
    };

    print(requestBody.toString());

    gpsapis.sendCommands(requestBody).then((res) => {
      if (res.statusCode == 200)
        {
          Fluttertoast.showToast(
              msg: "Command Sent Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0),
          Navigator.of(context).pop()
        }
      else
        {
          Fluttertoast.showToast(
              msg: "Error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 16.0),
          Navigator.of(context).pop()
        }
    });
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
        //automaticallyImplyLeading: false,
        elevation: 0,
         iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),
        systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
        centerTitle: true,
        title: Text('Lock Screen', style: GlobalStyle.appBarTitle),
        backgroundColor: GlobalStyle.appBarBackgroundColor,
        //bottom: _reusableWidget.bottomAppBar(),
      ),
      body: ListView(
        children: [

          _createAccountInformation(),
          _buildmoreswitch(),
          _buildmoreManues(),
          commandControls(),
         // _Commandhistory(),
          //listView(),

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




                      String lock="engineStop";


                      sendCommand(lock);
                      //_launchURL("www.maktro.com/mgt/pay");
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

                      String unlock="engineResume";


                      sendCommand(unlock);
                    //  _launchURL("www.maktro.com/mgt/price");
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



  Widget commandControls() {

    return  Container(
      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 30),

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 20,
                offset: Offset.zero,
                color: Colors.grey.withOpacity(0.5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 10, left: 15, right: 15),
              padding: EdgeInsets.only(left: 10, right: 10),


              child:Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                //color: Colors.grey.shade900,
                //shadowColor: Colors.pink,
                child: Container(

                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: DropdownSearch(
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      items: commandsstr,
                      dropdownSearchDecoration: InputDecoration(
                        //labelText: "Location",
                        hintText: "Select Command",
                      ),
                      onChanged: (dynamic value) {
                        /* for (int i = 0; i < _reportliststr.length; i++) {
                      if (value != null) {
                        if (value=="") {

                          break;
                        }
                      }
                    }*/
                        setState(() {
                          selectedcommands = value;
                        });

                      },
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        cursorColor: Colors.red,
                      ),

                    )
                ),
              )
          ),

          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  sendCommand(selectedcommands);
                },
                child: Text('Send Command'),
              )),
          //   OutlinedButton.icon(
          //     onPressed: () {
          //       sendCommand(selectedcommands);
          //       // Fluttertoast.showToast(msg: 'Press Outline Button', toastLength: Toast.LENGTH_SHORT);
          //     },
          //     style: ButtonStyle(
          //         overlayColor: MaterialStateProperty.all(Colors.grey),
          //         shape: MaterialStateProperty.all(
          //             RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(26),
          //             )
          //         ),
          //         side: MaterialStateProperty.all(
          //           BorderSide(
          //               color: Colors.grey,
          //               width: 1.0
          //           ),
          //         )
          //     ),
          //     icon: Icon(
          //       Icons.file_copy_outlined,
          //       size: 24.0,color: Colors.grey,
          //     ),
          //     label: Text('Send Commands      ',style: TextStyle(
          //         color: Colors.grey)),
          //   ),
          // ),

        ],
      ),
    );

  }
//   Widget _Commandhistory(){
//     return Container(
//         margin: EdgeInsets.all(10),
//        // child:     Center(
//           child:
//         Text('Command History',  style: TextStyle(
//             fontSize: 17,height: 1.5,fontWeight: FontWeight.bold)),
//      //   )
//     );
//   }
//
//   Widget listView(){
//
//     return   Container(
//       height: MediaQuery.of(context).size.height / 1.5,
//       width: MediaQuery.of(context).size.width,
//       child: _isLoading == true
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         padding: EdgeInsets.only(bottom: 70),
//           itemCount: commandList.length,
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//                 child: listViewItems( index),
//                 onTap: () => onTapped());
//           }),
//     );
//     /*return ListView.builder(itemBuilder:(context,index){
//       return listViewItems(index);
//     },separatorBuilder: (context,index){
//       return Divider(height: 0);
//     }, itemCount: eventList.length);*/
//   }
//
//   onTapped() async {
//     /* Consts.DocId=approvalModel.DocId;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => GetApproval(loginModel: loginModel)),
//     );*/
//   }
//
//
//   Widget listViewItems(int index){
//     return Container(
//         margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
//         child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             elevation: 2,
//             color: Colors.white,
//             child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.only(left: 8,right: 5,top: 8,bottom: 15),
//
//                       child: Column(
//                         children: [
//                           //DeleteIcon(index),
//                           message(index),
//                           commandtext(index),
//                           timeAndDate(index),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]
//             )
//         )
//     );
//   }
//
// /*  Widget listViewItems(int index){
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           prefixIcon(index),
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.only(left: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   message(index),
//                   timeAndDate(index),
//                 ],
//               ),
//             ),
//           ),
//           DeleteIcon(index),
//         ],
//       ),
//     );
//   }*/
//
//   Widget prefixIconinfo(){
//     return
//       Container(
//         height: 55,
//         width: 55,
//         margin: EdgeInsets.only(top:15,left: 10),
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//         ),
//         child: Image.asset("assets/settingicon/aboutus.png", height: 55,width: 55),
//         /* child: Icon(Icons.notifications,
//           size: 25,
//           color:Colors.grey.shade700),*/
//       );
//   }
//
//
//
//   Widget message(int index){
//     double textsize=12;
//     return Container(
//       padding: EdgeInsets.only(right: 1,top: 10,bottom: 5),
//       child: RichText(
//         maxLines: 5,
//         textAlign: TextAlign.left,
//         overflow: TextOverflow.ellipsis,
//         text: TextSpan(
//             text:'Command send On ' +commandList[index].imei.toString() + ' Command Type ('+ commandList[index].commandtype.toString()+')',
//             style: TextStyle(
//               fontSize: textsize,
//               color: Colors.grey.shade700,
//               //fontWeight: FontWeight.bold
//             ),
//             children: [
//               /* TextSpan(
//                 text:eventList[index].message.toString() == "null" ? "" : eventList[index].message.toString(),
//                 style: TextStyle(
//
//                     fontWeight: FontWeight.w400),
//               )*/
//             ]
//         ),
//       ),
//     );
//   }
//
//   Widget commandtext(int index){
//     return Container(
//       //margin: EdgeInsets.only(top: 5),
//       padding: EdgeInsets.only(right: 10,bottom: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(commandList[index].command.toString(),style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey.shade700,
//           ),
//           ),
//
//         ],
//       ),
//     );
//   }
//   Widget timeAndDate(int index){
//     return Container(
//       //margin: EdgeInsets.only(top: 5),
//       padding: EdgeInsets.only(right: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(formatTime(commandList[index].time.toString()),style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey.shade700,
//           ),
//           ),
//           (commandList[index].status!.contains("green"))?
//           Image.asset("assets/images/cmddoubletickgreen.png", height: 20): Image.asset("assets/images/cmddoubletickred.png", height: 20),
//         ],
//       ),
//     );
//   }
//
//




}








