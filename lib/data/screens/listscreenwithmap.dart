import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maktrogps/bottom_navigation/bottom_navigation.dart';
import 'package:maktrogps/config/constant.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/User.dart';
import 'package:maktrogps/data/model/devices.dart';
import 'package:maktrogps/data/model/loginModel.dart';
import 'package:maktrogps/data/model/product_model.dart';
import 'package:maktrogps/data/screens/historyscreen.dart';
import 'package:maktrogps/data/screens/livetrack.dart';
import 'package:maktrogps/data/screens/mainmapscreen.dart';
import 'package:maktrogps/data/screens/notificationscreen.dart';
import 'package:maktrogps/data/screens/optionsscreen/alloptions.dart';
import 'package:maktrogps/data/screens/playback.dart';
import 'package:maktrogps/data/screens/playbackscreen.dart';
import 'package:maktrogps/data/screens/playbackselection.dart';
import 'package:maktrogps/data/screens/reports/kmdetail.dart';
import 'package:maktrogps/data/screens/reports/reportselection.dart';
import 'package:maktrogps/data/screens/reports/vehicle_info.dart';
import 'package:maktrogps/data/screens/settingscreens/privacypolicy.dart';
import 'package:maktrogps/data/screens/settingscreens/termsandconditions.dart';
import 'package:maktrogps/data/screens/signin.dart';
import 'package:maktrogps/ui/reusable/global_function.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:maktrogps/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

import '../../mvvm/view_model/objects.dart';
import 'LiveMapScreen/LiveMapScreen.dart';
import 'commands/CommandWindow.dart';
import 'lockscreen.dart';
import 'lockscreenNew.dart';

class listscreen extends StatefulWidget {

  var currentTab;
  static String? currentFilter;

  listscreen({super.key, this.currentTab});

  @override
  _listscreen createState() => _listscreen();
}

class _listscreen extends State<listscreen> with SingleTickerProviderStateMixin {


  // initialize global function and global widget
  final _globalFunction = GlobalFunction();
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showgooglemap=true;
  PersistentBottomSheetController? _bottomSheetController;

  String filtertext="All";
  bool _loading = true;
  Timer? _timer;
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = new Set();

  Color _color1 = Color(0xff777777);
  Color _color2 = Color(0xFF515151);



  Color _topSearchColor = Colors.white;
  List<deviceItems> _vehiclesData = [];
  List<deviceItems> devicesList = [];
  List<deviceItems> _vehiclesData_sorted = [];
  List<deviceItems> _vehiclesData_duplicate = [];

  List<mapcontrollers> listcontroller=[];
  // _listKey is used for AnimatedList
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController _etSearch = TextEditingController();


  int _tabIndex = 0;

  GoogleMapController? _controller;
  Map<MarkerId, Marker> _allMarker = {};
  bool _mapLoading = true;

  double _currentZoom = 14;

//  final LatLng _initialPosition = LatLng(-6.168033, 106.900467);

  Marker? _marker;

  late BitmapDescriptor _markerDirection;
  late BitmapDescriptor _markerDirectiongreen;

  String iconred="assets/images/direction.png";
  Future<BitmapDescriptor> _setSourceAndDestinationIcons(String path) async {
    Uint8List markerIcon = await getBytesFromAsset(path, 80);
    // _markerDirection = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration(devicePixelRatio: 200),
    //     path);
    _markerDirection = await  BitmapDescriptor.fromBytes(markerIcon);

    return _markerDirection;
  }
  Future<BitmapDescriptor> _setSourceAndDestinationIconsgreen(String path) async {
    _markerDirectiongreen = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.1),
        path);

    return _markerDirectiongreen;
  }
  static Color primaryDark = const Color.fromARGB(255, 13, 61, 101);

  List<String> carstatusList = [
    'All ',
    'Running',
    'Stopped' ,

    'Idle',
    'Offline',
    'Expired'
  ];
  int starIndex = 0;
  Color CHARCOAL = Color(0xFF515151);
  bool _searchEnabled = false;
  List<deviceItems> _inactiveVehicles = [];
  List<deviceItems> _runningVehicles = [];
  List<deviceItems> _idleVehicles = [];
  List<deviceItems> _stoppedVehicles = [];

  late ObjectStore objectStore;
  @override
  void initState() {

    super.initState();

  }



  @override
  void dispose() {
    if(_timer != null){
      _timer!.cancel();
    }
    _etSearch.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    objectStore = Provider.of<ObjectStore>(context);
    _vehiclesData = objectStore.objects;

    _runningVehicles = [];
    _idleVehicles = [];
    _stoppedVehicles = [];
    _inactiveVehicles = [];
    if (_vehiclesData.isNotEmpty) {
      _vehiclesData_duplicate.clear();
      _vehiclesData_sorted.clear();
      _vehiclesData_sorted.addAll(_vehiclesData);

      if (filtertext != "All") {
        for (int i = 0; i < _vehiclesData_sorted.length; i++) {
          deviceItems model = _vehiclesData_sorted.elementAt(i);
          if (filtertext == "Offline") {
            if (model.online.toString().toLowerCase().contains("offline") &&
                model.time.toString().toLowerCase().contains("not connected")) {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('Offline');
            }
          }
          else if (filtertext == "Running") {
            if (model.online
                .toString()
                .toLowerCase()
                .contains("online")) {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('online');
            }
          }
          else if (filtertext == "Idle") {
            if (model.online.toString().toLowerCase().contains("ack") &&
                double.parse(model.speed.toString()) < 1.0) {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('Idle');
            }
          }
          else if (filtertext == "Stopped") {
            if (model.online
                .toString()
                .toLowerCase()
                .contains("offline") &&
                model.time.toString().toLowerCase() != "not connected") {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('stoppedvehile');
            }
          }

          else if (filtertext == "Expired") {
            if (model.time.toString().toLowerCase().contains("expire")) {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('expire');
            }
          }

          else {
            if (model.name.toString().toLowerCase().contains(filtertext
                .toLowerCase()) /*||
                  model.devicedata!.first.imei!.contains(query.toLowerCase())*/
            ) {
              _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
              print('item exists');
            }
          }
        }
      } else {
        _vehiclesData_duplicate.addAll(_vehiclesData);
      }

      StaticVarMethod.devicelist=_vehiclesData;

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
      _loading = false;
      // if (mounted) {
      //   setState(() {
      //     _loading = false;
      //   });
      // }

    } else {
      print("not available");
      _loading = false;
      _vehiclesData_duplicate.clear();
      _vehiclesData_sorted.clear();

    }


    final double boxImageSize = (MediaQuery.of(context).size.width / 12);

    print("list Builder");
    Widget? _child;
    if (_loading == true) {
      _child = const Center(child: CircularProgressIndicator());
    } else if (_vehiclesData_duplicate.isNotEmpty) {
      _child = new RefreshIndicator(
        onRefresh: refreshData,
        child: (_loading == true)
            ? CircularProgressIndicator()
            : devicesListwidget(boxImageSize),
      );
    } else if (_vehiclesData_duplicate.isEmpty) {
      _child = new RefreshIndicator(
        onRefresh: refreshData,
        child: (_loading == true)
            ? _shimmerLoading.buildShimmerContent()
            : Container(),
      );
    }

    return Scaffold(
      key:  _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(

       // leading: const DrawerWidget(),
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: (_searchEnabled)
            ? Container(
          child: TextFormField(
            controller: _etSearch,
            style: TextStyle(fontSize: 16, color: /*Colors.grey.shade800*/_topSearchColor),
            onChanged: (value) {
              setState(() {
                print('text changed');
                if (value.isNotEmpty) {
                  filterSearchResults(value);
                } else {
                  _vehiclesData.clear();
                  filtertext = "All";
                  // setState(() {
                  //_getData();
                  print("full list");
                  print(_vehiclesData.length);
                  //  });
                }
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: true,
              hintText: 'Enter device name or IMEI',
              hintStyle: TextStyle(fontSize: 16, color:/*Colors.grey.shade800*/ _topSearchColor),
              prefixIcon:
              Icon(Icons.search, color:/*Colors.black*/_topSearchColor, size: 18),
              suffixIcon: (_etSearch.text == '')
                  ? null
                  : GestureDetector(
                  onTap: () {
                    filtertext = "All";
                    //setState(() {
                    //_getData();
                    _etSearch = TextEditingController(text: '');
                    _searchEnabled =
                    _searchEnabled == false ? true : false;
                    //  });
                  },
                  child: Icon(Icons.close,
                      color: /*Colors.grey[500]*/_topSearchColor, size: 14)),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: /*Colors.grey[200]*/_topSearchColor!)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: /*Colors.grey[200]*/_topSearchColor!),
              ),
            ),
          ),
        )
            : Center(child: Text("List of Vehicles",   style: TextStyle(
            //color: Colors.grey[900],
            color: _topSearchColor,
            fontSize: 12,
            fontWeight: FontWeight.normal),
        )),
        /*Image.asset('assets/appsicon/btplloginlogo.png', height: 40)*/
       // backgroundColor: Colors.blue.shade900,
        backgroundColor: themeDark,
        bottom: PreferredSize(
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: /*Colors.grey[200]*/_topSearchColor!,
                        width: 1.0,
                      )),
                  color: /*Colors.grey.shade200*/_topSearchColor),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: kToolbarHeight,
              child: ListView(
                //padding: EdgeInsets.all(16),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(carstatusList.length, (index) {
                        return radioStar(carstatusList[index], index);
                      }),
                    ),
                  ),
                ],
              )),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        actions: [
          IconButton(
              icon: Icon(
                (_searchEnabled) ? Icons.clear_rounded : Icons.search,
                color: /*Colors.grey.shade800*/_topSearchColor,
                size: 25,
              ),
              onPressed: () {
                setState(() {
                  filtertext = "All";
                  //setState(() {
                  //_getData();
                  _etSearch = TextEditingController(text: '');
                  _searchEnabled = _searchEnabled == false ? true : false;
                });
              }),
        ],
      ),

      body: devicesListwidget(boxImageSize),
    );
  }

  Widget radioStar(String txt, int index) {

    Color statuscolor= Colors.white;
    if (index == 0) {
      txt= txt+'('+_vehiclesData.length.toString()+')';
    } else if (index == 1) {
      statuscolor= Colors.green.shade100;
      txt= txt+'('+_runningVehicles.length.toString()+')';
    } else if (index == 2) {
      statuscolor= Colors.red.shade100;
      txt= txt+'('+_stoppedVehicles.length.toString()+')';
    }
    else if (index == 3) {
      statuscolor= Colors.yellow.shade100;
      txt= txt+'('+_idleVehicles.length.toString()+')';
    }
    else if (index == 4) {
      statuscolor= Colors.blue.shade100;
      txt= txt+'('+_inactiveVehicles.length.toString()+')';

    }
    return GestureDetector(
      onTap: () {
        setState(() {
          starIndex = index;
          _tabIndex = index;
          if (index == 0) {
            filterSearchResults("All");
          } else if (index == 1) {
            filterSearchResults("Running");
          } else if (index == 2) {
            filterSearchResults("Stopped");
          }
          else if(index ==3){
            filterSearchResults("Idle");
          }
          else if (index == 4) {
            filterSearchResults("Offline");
          } else if (index == 5) {
            filterSearchResults("expire");
          }
        });
        Fluttertoast.showToast(
            msg: 'Click TabBar', toastLength: Toast.LENGTH_SHORT);
        print('idx : ' + _tabIndex.toString());
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: starIndex == index ? primaryDark : statuscolor,
              border: Border.all(
                  width: 1.8,
                  color: starIndex == index
                      ? primaryDark
                      : primaryDark),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: index == 0
              ? Text(txt,
              style: TextStyle(
                  color: starIndex == index
                      ? Colors.white
                      : primaryDark))
              : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(txt,
                  style: TextStyle(
                      color: starIndex == index
                          ? Colors.white
                          : primaryDark)),
              SizedBox(width: 2),
              //Icon(Icons.star, color: starIndex == index ? Colors.white : Colors.yellow[700], size: 12),
            ],
          )),
    );
  }

  Widget devicesListwidget(double boxImageSize) {


    return ListView.builder(
      primary: false,
      physics: const AlwaysScrollableScrollPhysics (),
      itemCount: _vehiclesData_duplicate.length,
      itemBuilder: (context, index) => _buildItem(_vehiclesData_duplicate[index], boxImageSize, index),

    );

    return ScrollablePositionedList.builder(
      key: _listKey,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 120),
      itemCount: _vehiclesData_duplicate.length,
      itemBuilder: (context, index) => _buildItem(_vehiclesData_duplicate[index], boxImageSize, index),
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );
    /*AnimatedList(
      key: _listKey,
      initialItemCount: _vehiclesData_duplicate.length,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index, animation) {
        return _buildItem(_vehiclesData_duplicate[index], boxImageSize, animation, index);
      },
    );*/
  }

  void filterSearchResults(String query) {


    filtertext=query;
    print("inside filter");
    _vehiclesData_duplicate.clear();
    if (query.isNotEmpty && query !="All") {


      for (int i = 0; i < _vehiclesData_sorted.length; i++) {
        deviceItems model = _vehiclesData_sorted.elementAt(i);


        if(query =="online"){
          if (model.online.toString().toLowerCase().contains(query.toLowerCase()) ) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('online');
          }
        }else if(query =="stoppedvehile"){
          if (model.online.toString().toLowerCase().contains("ack") ||
              model.online.toString().toLowerCase().contains(query.toLowerCase())) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('stoppedvehile');
          }
        }/*else if(query =="idle"){
          if (model.online.toString().toLowerCase().contains("ack") ||
              model.speed.toString().toLowerCase().contains("0")) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('idle');
          }
        }*/
        else if(query =="offline"){
          if (/*model.stopDuration.toString().toLowerCase().contains("h")||*/
              model.online.toString().toLowerCase().contains(query.toLowerCase())) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('offline');
          }
        }
        else if(query =="expire"){
          if (model.time.toString().toLowerCase().contains("expire")) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('expire');
          }
        }
        else{
          if (model.name.toString().toLowerCase().contains(query.toLowerCase()) /*||
                  model.devicedata!.first.imei!.contains(query.toLowerCase())*/) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('item exists');
          }
        }

      }

     // setState(() {
        refreshData();
      //});
    }
    else{
      if(query =="All"){
        _vehiclesData_duplicate.addAll(_vehiclesData_sorted);
        print('All');
        refreshData();
      }
    }
  }
  Color randomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);

  Widget _buildItem(deviceItems productData, boxImageSize, index){
    double imageSize = MediaQuery.of(context).size.width/25;
    double lat =productData.lat!.toDouble();
    double lng = productData.lng!.toDouble();
    double course = productData.course!.toDouble();
    int speed = productData.speed!.toInt();
    String imei = productData.deviceData!.imei.toString();
    String carstatus = productData.online!.toString();
    Color statuscolor=Colors.red;
    if(speed >0){
      statuscolor=Colors.green;
    }else{
      statuscolor=Colors.red;
    }
    return  Container(
      margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
      //padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),

        ),
        elevation: 2,
        color: statuscolor,
        child: Container(
          decoration: BoxDecoration(
            /*border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 1.0,
                  )
              ),*/
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
         // padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
         // margin: EdgeInsets.only(left: 5),

          child: Stack(
            children: [
              googlemap(lat,lng,course,imei,speed),
              GestureDetector(
                onTap: (){
                  Fluttertoast.showToast(msg: 'Click ${productData.name}', toastLength: Toast.LENGTH_SHORT);
                },
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
                    // margin: EdgeInsets.only(left: 5),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*  ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                        child:Image.asset("assets/rotatingicon/2.png", height: boxImageSize,width: boxImageSize)),*/
                        /*    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: (carstatus.contains("online"))? Colors.green.withOpacity(0.3):randomColor().withOpacity(0.3),

                        borderRadius: BorderRadius.all(Radius.circular(30)),

                      ),
                      child:Image.asset("assets/rotatingicon/2.png", height: boxImageSize,width: boxImageSize)
                    ),
                    //child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: productData.image)),
                    SizedBox(
                      width: 10,
                    ),*/
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Row(children:[Text("Some Data"), Spacer(), Text("Some Data")]),
                              Row(
                                  children:[
                                    Text(''+
                                        productData.name.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                     Spacer(),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text('IMEI: '+
                                          productData.deviceData!.imei.toString(),
                                        style: TextStyle(
                                          shadows:  <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 1.0),
                                             // blurRadius:3.0,
                                              color: Colors.white
                                              //color: Color.fromARGB(255, 255, 255, 255),
                                            ),

                                          ],
                                          fontSize: 9,
                                          //color: _color2
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                              ),
                              /*Container(
                            margin: EdgeInsets.only(top: 5),
                            child: (productData.speed! > 0) ? BlinkText(
                              ''+productData.speed.toString() +' KM/H',
                              style: TextStyle(fontSize: 20.0, color: Colors.greenAccent,
                                  fontFamily: 'digital_font'),
                              endColor: Colors.orange,
                            )
                                : Text(productData.speed.toString() +' KM/H',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'digital_font',
                                  //fontWeight: FontWeight.bold,

                                )),
                          ),*/

                              Row(
                                  children:[
                                    Text((speed>0)?'Moving since: '+productData.stopDuration!:'Stopped since: '+productData.stopDuration!,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: statuscolor
                                        )),

                                    Spacer(),
                                    Text("Expire on",style: TextStyle(
                                        fontSize: 9,
                                        color: SOFT_GREY
                                    ))
                                  ]
                              ),


                              Row(children:[
                                Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Row(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(top: 5),
                                        child: (productData.speed! > 0) ? BlinkText(
                                          ''+productData.speed.toString() +' KM/H',
                                          style: TextStyle(
                                              fontSize: 20.0, color: Colors.greenAccent,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'digital_font',
                                            shadows:  <Shadow>[
                                              Shadow(
                                                  offset: Offset(1.0, 1.0),
                                                  // blurRadius:3.0,
                                                  color: Colors.white
                                                //color: Color.fromARGB(255, 255, 255, 255),
                                              ),

                                            ],
                                          ),
                                          endColor: Colors.orange,
                                        )
                                            : Text(productData.speed.toString() +' KM/H',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'digital_font',
                                              //fontWeight: FontWeight.bold,

                                            )),
                                      ),
                                      // Icon(Icons.history_toggle_off, color: SOFT_GREY, size: 12),

                                    ],
                                  ),
                                ), Spacer(), Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Text(productData.time.toString(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: SOFT_GREY
                                      )),
                                )]),


                              /*  Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text('('+Jiffy(productData.time).fromNow()+')', style: TextStyle(
                                      fontSize: 11,
                                      color: SOFT_GREY
                                  ))
                                ],
                              ),
                            ),*/


                            ],
                          ),
                        )
                      ],
                    )),
              ),
              // _buildGoogleMap(lat,lng,course,imei),




              (productData.sensors != null)?
              Container(
                margin: EdgeInsets.only(top: 145,left: 30,right: 30),
                height: 44,
                child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: productData.sensors!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 8,top: 10),
                        child: Container(
                          // padding: EdgeInsets.all(8),

                            child:   Column(
                                children: <Widget>[
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'ignition'
                                      ? Image.asset("assets/saftyappicon/ignintion.png", height: imageSize,width: imageSize)
                                  // ? Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize,color: themeDark,)
                                      :     productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'engine'
                                      ? Image.asset("assets/saftyappicon/ignintion.png", height: imageSize,width: imageSize)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'sat'
                                      ? Image.asset("assets/saftyappicon/sattelite.png", height: imageSize,width: imageSize)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'odometer'
                                      ? Image.asset("assets/saftyappicon/odomenetr.png", height: imageSize,width: imageSize)
                                      //? Image.asset("assets/sensorsicon/speedometeron.png", height: imageSize,width: imageSize)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'battery'
                                      ? Image.asset("assets/saftyappicon/battery.png", height: imageSize,width: imageSize,):
                                 // Icon(FontAwesomeIcons.batteryFull, size: 16,color:themeDark,) :

                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'charge'
                                      ? Image.asset("assets/saftyappicon/charge_icon.png", height: imageSize,width: imageSize,)
                                     // ? Icon(Icons.battery_charging_full, size: 16,color:themeDark,)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'engine lock'
                                      ? Icon(
                                    Icons.hourglass_bottom_rounded, size: 16,color:themeDark,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gps'
                                      ? Icon(
                                    Icons.gps_fixed_outlined, size: 16,color:themeDark,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gsm'
                                      ? Image.asset("assets/saftyappicon/gsmicon.png", height: imageSize,
                                      width: imageSize,color: themeDark,):
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'moving'
                                      ? Icon(Icons.moving_outlined, size: 16,color:themeDark,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gps starting km'
                                      ? Icon(
                                    Icons.gps_fixed_outlined, size: 16,color:themeDark,) :

                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'temp'
                                      ? Icon(
                                    FontAwesomeIcons.temperatureLow, size: 16,color:themeDark,)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'engine_hours'
                                      ? Icon(Icons.alarm, size: 16,color:themeDark,)
                                   : Image.asset("assets/saftyappicon/mileage.png", height: imageSize,
                                    width: imageSize,color: themeDark),
                                      //: Icon(Icons.charging_station, size: 16,color:themeDark,),
                                  //Icon(Icons.engineering,size:imageSize),
                                  // Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize),
                                  Text(productData.sensors![index].name.toString(),  style: TextStyle(
                                      fontSize: 7,height: 1.5, color: themeDark)),
                                  Text("${productData.sensors![index].value.toString()}",  style: TextStyle(
                                      fontSize: 7,height: 1, color: themeDark))
                                ]
                            )
                        ),
                        /* Column(
                              children: [
                                Text(productData.sensors![index].name.toString(),
                                  style: TextStyle(fontSize: 8, color:Colors.grey.shade400,),),
                                Text(" : ${productData.sensors![index].value.toString()}",
                                  style: TextStyle(fontSize: 8,color:Colors.grey.shade400),),
                              ],
                            ),*/
                      );
                    }),
              )
                  :Container(
                  margin: EdgeInsets.only(top: 145),

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
                                  padding: EdgeInsets.all(8),

                                  child:   Column(
                                      children: <Widget>[
                                        //Icon(Icons.engineering,size:imageSize),
                                        Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize,color:themeDark),
                                        Text('Ignition',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY)),
                                        /*  Text('On',  style: TextStyle(
                                            fontSize: 7,height: 1, color: SOFT_GREY))*/
                                      ]
                                  )
                              ),
                            ),


                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  /*  decoration: new BoxDecoration(
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
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/sensorsicon/locationon.png", height: imageSize,width: imageSize),
                                        Text('GPS',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY))
                                      ]
                                  )
                              ),
                            ),
                          ],

                        ),
                      ),
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
                                  padding: EdgeInsets.all(8),

                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/sensorsicon/speedometeron.png", height: imageSize,width: imageSize),
                                        Text('Odometer',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => vehicle_info()),
                                );

                                //_onMapTypeButtonPressed();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  /*  decoration: new BoxDecoration(
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
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/sensorsicon/connectedon.png", height: imageSize,width: imageSize),
                                        Text('GSM Level',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                  padding: EdgeInsets.all(8),

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
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/sensorsicon/hour24on.png", height: imageSize,width: imageSize),
                                        Text('Eng Hour',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => vehicle_info()),
                                );

                                //_onMapTypeButtonPressed();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  /* decoration: new BoxDecoration(
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
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/sensorsicon/batteryon.png", height: imageSize,width: imageSize),
                                        Text('Battery',  style: TextStyle(
                                            fontSize: 7,height: 1.5, color: SOFT_GREY))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 175),
                child: Row(
                  children: [

                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              StaticVarMethod.deviceName=productData.name.toString();
                              StaticVarMethod.deviceId=productData.id.toString();
                              StaticVarMethod.lat=productData.lat!.toDouble();
                              StaticVarMethod.lng=productData.lng!.toDouble();
                              StaticVarMethod.imei=productData.deviceData!.imei.toString();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => livetrack()),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveMapScreen()),
                              );

                              //Fluttertoast.showToast(msg: 'Item has been added to Shopping Cart');
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 0)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.transparent,
                                     // width: 1.0
                                  ),
                                )
                            ),
                            child:Row(

                                children: <Widget>[
                                  Image.asset("assets/listviewicon/livetrackicon.png", height: 12,width: 12),
                                  SizedBox(width: 10,),
                                  Text('  Live Track',  style: TextStyle(
                                      fontSize: 9, color: SOFT_GREY))
                                ]
                            )
                          /*Text(
                              'Live Track',
                              style: TextStyle(
                                  color: SOFT_GREY,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center,
                            )*/
                        )

                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {


                              //_timerDummy?.cancel();



                              StaticVarMethod.deviceName=productData.name.toString();
                              StaticVarMethod.deviceId=productData.id.toString();
                              StaticVarMethod.imei=productData.deviceData!.imei.toString();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => playbackselection()),
                              );
                              //Fluttertoast.showToast(msg: 'Item has been added to Shopping Cart');
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 0)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child:Row(
                                children: <Widget>[
                                  Image.asset("assets/listviewicon/playback.png", height: 12,width: 12),
                                  SizedBox(width: 10,),
                                  Text('  Playback',  style: TextStyle(
                                      fontSize: 9, color: SOFT_GREY))
                                ]
                            )
                          /*child: Text(
                              'Playback',
                              style: TextStyle(
                                  color: SOFT_GREY,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center,
                            )*/
                        )

                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Expanded(
                        child:OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => vehicle_info()),
                              );
                              //Fluttertoast.showToast(msg: 'Item has been added to Shopping Cart');
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 0)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.transparent,
                                      width: 0.5
                                  ),
                                )
                            ),
                            child:Row(
                                children: <Widget>[
                                  //Icon(Icons.info_outline, size: imageSize,color: Colors.red,),
                                  Image.asset("assets/listviewicon/dashboard.png", height: 12,width: 12),
                                  SizedBox(width: 10,),
                                  Text(' Dashboard',  style: TextStyle(
                                      fontSize: 9, color: SOFT_GREY))
                                ]
                            )
                          /* child: Text(
                              'Dashboard',
                              style: TextStyle(
                                  color: SOFT_GREY,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center,
                            )*/
                        )
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {

                        StaticVarMethod.deviceName=productData.name.toString();
                        StaticVarMethod.deviceId=productData.id.toString();
                        StaticVarMethod.imei=productData.deviceData!.imei.toString();
                        StaticVarMethod.simno=productData.deviceData!.simNumber.toString();
                        StaticVarMethod.lat=productData.lat!.toDouble();
                        StaticVarMethod.lng=productData.lng!.toDouble();
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => alloptionsPage())
                        );*/


                        /* _bottomSheetController = _scaffoldKey.currentState!.showBottomSheet(
                              (_) => Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width,
                               child: _showDeliveryPopup(),
                          ),
                          backgroundColor: Colors.transparent,

                        );*/

                        showModalBottomSheet<void>(
                          context: context,
                          //isDismissible: false,
                          //barrierColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return  Container(
                              //color: Colors.transparent,
                                height: MediaQuery.of(context).size.height / 2.0,
                                child: _showbottomPopup()
                            );
                          },
                        );

                        /*   Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SimpleMarkerAnimationExample())
                        );*/

                        //showPopupDeleteFavorite(index, boxImageSize);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: Colors.white)),
                        child:Image.asset("assets/listviewicon/appsetting.png", height: 15,width: 15),

                        /*Icon(Icons.app_settings_alt_outlined,
                            color: _color1, size: 20),*/
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  Widget googlemap(lat,lng,course,imei,speed){

    String iconpath = "assets/speedoicon/assets_images_markers_m_2_grn.png";
    //String iconpath = devicelist.icon!.path.toString();
    if(speed > 0){
      iconpath =  "assets/speedoicon/assets_images_markers_m_2_grn.png";

      if(StaticVarMethod.pref_static!.get(imei.toString())!=null)
        iconpath =  "assets/speedoicon/"+StaticVarMethod.pref_static!.get(imei.toString()).toString()+"grn.png";

    }
    else{
      iconpath =  "assets/speedoicon/assets_images_markers_m_2_red.png";
      if(StaticVarMethod.pref_static!.get(imei.toString())!=null)
        iconpath =  "assets/speedoicon/"+StaticVarMethod.pref_static!.get(imei.toString()).toString()+"red.png";
    }
    return FutureBuilder<BitmapDescriptor>(
        future: _setSourceAndDestinationIcons(iconpath),
        builder: (context, AsyncSnapshot<BitmapDescriptor> snapshot) {
          if (snapshot.hasData) {
            return (showgooglemap)?Container(
                height: 150,
                //width: size.width,
                child: GoogleMap(
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  mapToolbarEnabled: false,
                  padding: EdgeInsets.all(200),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    zoom: 10,
                    target: LatLng(lat!, lng!),
                  ),

                  markers:
                  <Marker>{
                    _allMarker[MarkerId(imei)] = Marker(
                        markerId: MarkerId(imei),
                        rotation: course!,
                        icon:(speed! > 0)? snapshot.data! :snapshot.data! ,
                        position: LatLng(lat!, lng!))
                    //   })
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _onMapCreated(controller,imei);
                  },

                )):Container();
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
  void _onMapCreated(GoogleMapController controller,imei) {
    mapcontrollers model=mapcontrollers(ctrl: controller, imei: imei);
    listcontroller.add(model);
  }


  Widget _showbottomPopup(){
    double imageSize = MediaQuery.of(context).size.width/17;
    return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
      return Container(
          margin: EdgeInsets.only(left: 0,right: 0, bottom: 0,top: 160),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /* Center(
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),*/
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12,left: 15),
                      /* width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10)
              ),*/
                      child:  Text(''+StaticVarMethod.deviceName,  style: TextStyle(
                          fontSize: 13, color: Color(0xff8E8E8E),fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),

              ),




              Container(
                  margin: EdgeInsets.only(top: 12, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => livetrack()),
                                // );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveMapScreen()),
                                );

                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/livetracking.png", height: imageSize,width: imageSize),
                                        Text('Live tracking',  style: TextStyle(
                                            fontSize: 10,height: 2,color: Color(0xff8E8E8E),))
                                      ]
                                  )
                              ),
                            ),


                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => vehicle_info()),
                                );

                                //_onMapTypeButtonPressed();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/speedoicon/car.png", height: imageSize,width: imageSize),
                                        Text('Vehicle info Info',  style: TextStyle(
                                          fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {

                                //_onMapTypeButtonPressed();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/locationicon.png", height: imageSize,width: imageSize),
                                        Text(' Trip Info ',  style: TextStyle(
                                          fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => lockscreenNew()),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/lock.png",
                                            height: imageSize,width: imageSize,color: Color(0xff0D3D65),),
                                        Text('lock',  style: TextStyle(
                                          fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                      ]
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),

              Row(
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
                                  builder: (context) => kmdetail()),
                            );
                          },
                          child: Container(
                              padding: EdgeInsets.all(8),

                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:BorderRadius.all(Radius.circular(15)),
                                // borderRadius: BorderRadius.circular(8),
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/speedoicon/speed_meter.png", height: imageSize,width: imageSize),
                                    Text('KM Summary',  style: TextStyle(
                                      fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),),)
                                  ]
                              )
                          ),
                        ),
                      ],

                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {


                          },
                          child: Container(
                              padding: EdgeInsets.all(8),

                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:BorderRadius.all(Radius.circular(15)),
                                // borderRadius: BorderRadius.circular(8),
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/speedoicon/engine.png", height: imageSize,width: imageSize),
                                    Text('Engine Hours',  style: TextStyle(
                                      fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                  ]
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              padding: EdgeInsets.all(3),

                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/signals.png", height: imageSize,width: imageSize),
                                    Text('Sensors Duration',  style: TextStyle(
                                      fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                  ]
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => reportselection()),
                            );
                          },
                          child: Container(
                              padding: EdgeInsets.all(8),

                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:BorderRadius.all(Radius.circular(15)),
                                // borderRadius: BorderRadius.circular(8),
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/graph.png", height: imageSize,width: imageSize),
                                    Text(' Report ',  style: TextStyle(
                                      fontSize: 10,height: 2.0,color: Color(0xff8E8E8E),))
                                  ]
                              )
                          ),
                        ),
                      ],

                    ),
                  ),
                ],
              )
            ],
          )
      );
    });
  }




  // add marker
  Set<Marker> getmarkers(double lat, double lng,double course,String imei)  {
    // void _addMarker(double lat, double lng,int index) {
    LatLng position = LatLng(lat, lng);

    // set initial marker
    markers.add( Marker(
      markerId: MarkerId(imei),
      anchor: Offset(0.5, 0.5),
      position: position,
      rotation: course,
      /*  infoWindow: InfoWindow(title: 'This is marker 1'),
      onTap: () {
        Fluttertoast.showToast(msg: 'Click marker', toastLength: Toast.LENGTH_SHORT);
      },*/
      icon: _markerDirection,
    )
    );

    if(_controller!=null){
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15));
    }



    return markers;
  }
  /*void _recenterall(){
    CameraUpdate u2=CameraUpdate.newLatLngBounds(LatLngBounds([]), 50);
    this._controller!.moveCamera(u2).then((void v){
      _check(u2,this._controller!);
    });
  }*/

  /* start additional function for camera update
  - we get this function from the internet
  - if we don't use this function, the camera will not work properly (Zoom to marker sometimes not work)
  */
  void _check(CameraUpdate u, GoogleMapController c) async {
    c.moveCamera(u);
    _controller!.moveCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      _check(u, c);
  }

  // when the Google Maps Camera is change, get the current position
  void _onGeoChanged(CameraPosition position) {
    _currentZoom = position.zoom;
  }


  // build google maps to used inside widget
  Widget _buildGoogleMap(double lat, double lng ,double course,String imei) {
    return Container(
        height: 200,
        child:GoogleMap(
          mapType: MapType.normal,
          trafficEnabled: false,
          //compassEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          markers: getmarkers(lat, lng,course,imei),
          //markers: Set.of((_marker != null) ? [_marker!] : []),
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: _currentZoom,
          ),
          // onCameraMove: _onGeoChanged,
          onCameraMove: (cameraPosition) {
            lat = cameraPosition.target.longitude; //gets the center longitude
            lng = cameraPosition.target.latitude;   //gets the center lattitude
          },
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            //_timerDummy = Timer(Duration(milliseconds: 300), () {
            setState(() {
              _mapLoading = true;

              _controller!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17));
              Fluttertoast.showToast(msg: '_controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17));', toastLength: Toast.LENGTH_SHORT);
              /* Future.delayed(Duration(seconds: 1), () async {
              GoogleMapController controller = await _mapController.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 17.0,
                  ),
                ),
              );
            });*/
              /*_controller?.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target:LatLng(lat, lng), zoom: 17)
                  //17 is new zoom level
                )
            );*/


              /*CameraUpdate u2 = CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: 15));

            this._controller.moveCamera(u2).then((void v) {
              _check(u2, this._controller);
            });*/
              //getmarkers(lat, lng,index);
              //_addMarker(lat, lng,index);
            });
            //  });
          },
          onTap: (pos){
            print('currentZoom : '+_currentZoom.toString());
          },
        )
    );
  }


  void showPopupDeleteFavorite(index, boxImageSize) {
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('No', style: TextStyle(color: SOFT_BLUE))
    );
    Widget continueButton = TextButton(
        onPressed: () {
          int removeIndex = index;
          var removedItem = _vehiclesData.removeAt(removeIndex);
          // This builder is just so that the animation has something
          // to work with before it disappears from view since the original
          // has already been deleted.
          AnimatedListRemovedItemBuilder builder = (context, animation) {
            // A method to build the Card widget.
            return _buildItem(removedItem, boxImageSize, removeIndex);
          };
          _listKey.currentState!.removeItem(removeIndex, builder);

          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'Item has been deleted from your favorite', toastLength: Toast.LENGTH_SHORT);
        },
        child: Text('Yes', style: TextStyle(color: SOFT_BLUE))
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text('Delete Favorite', style: TextStyle(fontSize: 18),),
      content: Text('Are you sure to delete this item from your Favorite ?', style: TextStyle(fontSize: 13, color: _color1)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future refreshData() async {

    // _vehiclesData.clear();
    // _vehiclesData=StaticVarMethod.devicelist;
    //
    // setState(() {
    //   _loading = true;
    // });
    //
    //
    //  // _getData();
    // Future.delayed(const Duration(milliseconds: 200), () {
    //   setState(() {
    //     _loading = false;
    //   });
    // });


  }
}




class mapcontrollers {
  GoogleMapController ctrl;
  String imei;

  mapcontrollers({required this.ctrl, required this.imei});
}



