import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maktrogps/config/constant.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/devices.dart';
import 'package:maktrogps/data/model/loginModel.dart';
import 'package:maktrogps/data/model/product_model.dart';
import 'package:maktrogps/data/screens/historyscreen.dart';
import 'package:maktrogps/data/screens/livetrackoriginal.dart';
import 'package:maktrogps/data/screens/mainmapscreenoriginal.dart';
import 'package:maktrogps/data/screens/notificationscreen.dart';
import 'package:maktrogps/data/screens/optionsscreen/alloptions.dart';
import 'package:maktrogps/data/screens/playback.dart';
import 'package:maktrogps/data/screens/playbackscreen.dart';
import 'package:maktrogps/data/screens/playbackselection.dart';
import 'package:maktrogps/data/screens/reports/reportselection.dart';
import 'package:maktrogps/data/screens/reports/vehicle_info.dart';
import 'package:maktrogps/data/screens/testscreens/livelocation.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';
import 'package:maktrogps/ui/reusable/cache_image_network.dart';
import 'package:maktrogps/ui/reusable/global_function.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:maktrogps/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'commands/CommandWindow.dart';
import 'livetrack.dart';
import 'lockscreen.dart';
import 'lockscreenNew.dart';
import 'reports/kmdetail.dart';

class listscreenorininal extends StatefulWidget {

  @override
  _listscreen createState() => _listscreen();
}

class _listscreen extends State<listscreenorininal> with SingleTickerProviderStateMixin {


  // initialize global function and global widget
  final _globalFunction = GlobalFunction();
  final _globalWidget = GlobalWidget();
  final _shimmerLoading = ShimmerLoading();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PersistentBottomSheetController? _bottomSheetController;

  String filtertext="All";
  bool _loading = true;
  Timer? _timerDummy;
  final Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> markers = new Set();

  Color _color1 = Color(0xff777777);
  Color _color2 = Color(0xFF515151);
  Color _topSearchColor = Colors.white;
  List<deviceItems> _vehiclesData = [];
  List<deviceItems> _vehiclesData_sorted = [];
  List<deviceItems> _vehiclesData_duplicate = [];
  // _listKey is used for AnimatedList
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController _etSearch = TextEditingController();


  int _tabIndex = 0;

  GoogleMapController? _controller;
  bool _mapLoading = true;
  static Color primaryDark = const Color.fromARGB(255, 13, 61, 101);
  double _currentZoom = 14;

//  final LatLng _initialPosition = LatLng(-6.168033, 106.900467);

  Marker? _marker;

  late BitmapDescriptor _markerDirection;
  void _setSourceAndDestinationIcons() async {
    _markerDirection = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/direction.png');
  }



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


  @override
  void initState() {
    _setSourceAndDestinationIcons();
    _getData();
    _timerDummy = Timer.periodic(Duration(seconds: 10), (Timer t) => _getData());
    super.initState();

  }


  @override
  void dispose() {
    _timerDummy?.cancel();
    _etSearch.dispose();
    super.dispose();
  }

  // Future<void> _getData() async{
  //
  //   Fluttertoast.showToast(
  //       msg: 'Refresh ',
  //       toastLength: Toast.LENGTH_SHORT);
  //   gpsapis api=new gpsapis();
  //   var hash=StaticVarMethod.user_api_hash;
  //   _vehiclesData =await gpsapis.getDevicesList(hash);
  //   if (_vehiclesData.isNotEmpty) {
  //     _vehiclesData_duplicate.clear();
  //     _vehiclesData_sorted.clear();
  //     _vehiclesData_sorted.addAll(_vehiclesData);
  //
  //     if(filtertext !="All"){
  //       for (int i = 0; i < _vehiclesData_sorted.length; i++) {
  //         deviceItems model = _vehiclesData_sorted.elementAt(i);
  //         if(filtertext =="online"){
  //           if (model.online.toString().toLowerCase().contains(filtertext.toLowerCase()) ) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('online');
  //           }
  //         }/*else if(filtertext =="offline"){
  //           if (model.online.toString().toLowerCase().contains("ack") ||
  //               model.online.toString().toLowerCase().contains(filtertext.toLowerCase())) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('ack');
  //           }
  //         }*/
  //         else if(filtertext =="stoppedvehile"){
  //           if (model.online.toString().toLowerCase().contains("ack") ||
  //               model.online.toString().toLowerCase().contains(filtertext.toLowerCase())) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('stoppedvehile');
  //           }
  //         }/*else if(query =="idle"){
  //         if (model.online.toString().toLowerCase().contains("ack") ||
  //             model.speed.toString().toLowerCase().contains("0")) {
  //           _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //           print('idle');
  //         }
  //       }*/
  //         else if(filtertext =="offline"){
  //           if (/*model.stopDuration.toString().toLowerCase().contains("h")||*/
  //               model.online.toString().toLowerCase().contains(filtertext.toLowerCase())) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('offline');
  //           }
  //         }
  //         else if(filtertext =="expire"){
  //           if (model.time.toString().toLowerCase().contains("expire")) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('expire');
  //           }
  //         }
  //         else{
  //           if (model.name.toString().toLowerCase().contains(filtertext.toLowerCase()) /*||
  //                 model.devicedata!.first.imei!.contains(query.toLowerCase())*/) {
  //             _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
  //             print('item exists');
  //           }
  //         }
  //       }
  //     }else{
  //       _vehiclesData_duplicate.addAll(_vehiclesData);
  //     }
  //
  //     StaticVarMethod.devicelist=_vehiclesData;
  //     if (mounted) {
  //       setState(() {
  //         _loading = false;
  //       });
  //     }
  //
  //   } else {
  //     print("not available");
  //     _loading = false;
  //     _vehiclesData_duplicate.clear();
  //     _vehiclesData_sorted.clear();
  //     if (mounted) {
  //       setState(() {});
  //     }
  //
  //   }
  //
  // }

  Future<void> _getData() async {

    _runningVehicles = [];
    _idleVehicles = [];
    _stoppedVehicles = [];
    _inactiveVehicles = [];
    // this timer function is just for demo, so after 2 second, the shimmer loading will disappear and show the content
    // Fluttertoast.showToast(msg: 'Refresh ', toastLength: Toast.LENGTH_SHORT);
    gpsapis api = new gpsapis();
    var hash = StaticVarMethod.user_api_hash;
    _vehiclesData = await gpsapis.getDevicesList(hash);
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
                .contains(filtertext.toLowerCase())) {
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

      StaticVarMethod.devicelist = _vehiclesData;



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

        // if (mounted) {
        //   setState(() {});
        // }
      }
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    } else {
      print("not available");
      _loading = false;
      _vehiclesData_duplicate.clear();
      _vehiclesData_sorted.clear();
      if (mounted) {
        setState(() {});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 12);

    Widget? _child;
    if (_loading == true) {
      _child = const Center(child: CircularProgressIndicator());
    } else if (_vehiclesData_duplicate.isNotEmpty) {
      _child = new RefreshIndicator(
        onRefresh: refreshData,
        child: (_loading == true)
            ? _shimmerLoading.buildShimmerContent()
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
        automaticallyImplyLeading: false,
        elevation: 0,
        title: (_searchEnabled)
            ? Container(
          child: TextFormField(
            controller: _etSearch,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800/*Colors.white*/),
            onChanged: (value) {
              setState(() {
                print('text changed');
                if (value.isNotEmpty) {
                  filterSearchResults(value);
                } else {
                  _vehiclesData.clear();
                  filtertext = "All";
                  // setState(() {
                  _getData();
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
              hintStyle: TextStyle(fontSize: 16, color:Colors.grey.shade800 /*Colors.white*/),
              prefixIcon:
              Icon(Icons.search, color:Colors.black/*Colors.white*/, size: 18),
              suffixIcon: (_etSearch.text == '')
                  ? null
                  : GestureDetector(
                  onTap: () {
                    filtertext = "All";
                    //setState(() {
                    _getData();
                    _etSearch = TextEditingController(text: '');
                    _searchEnabled =
                    _searchEnabled == false ? true : false;
                    //  });
                  },
                  child: Icon(Icons.close,
                      color: Colors.grey[500], size: 16)),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        )
            : /*Center(child: Text("List of Vehicles")),*/ Image.asset('assets/appsicon/trackon.png', height: 40),
       // backgroundColor: themeDark,
        backgroundColor: Colors.grey.shade50,
        bottom: PreferredSize(
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.0,
                      )),
                  color: Colors.grey.shade200),
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
                color: Colors.grey.shade800/*Colors.white*/,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  filtertext = "All";
                  //setState(() {
                  _getData();
                  _etSearch = TextEditingController(text: '');
                  _searchEnabled = _searchEnabled == false ? true : false;
                });
              }),
        ],
      ),

      /*AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        */
      /*iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),*//*
        //systemOverlayStyle: SystemUiOverlayStyle.dark,
        // elevation: 0,
        title: Container(
          *//*decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[100]!,
                    width: 1.0,
                  )
              ),
            ),*//*
          // padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          //margin: EdgeInsets.fromLTRB(0, 15, 0, 12),
          //height: kToolbarHeight - 24,
          child: TextFormField(
            controller: _etSearch,
            //textAlignVertical: TextAlignVertical.bottom,
            // maxLines: 1,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            onChanged: (value) {
              setState(() {
                print('text changed');
                if (value.isNotEmpty) {
                  filterSearchResults(value);
                } else {
                  _vehiclesData.clear();
                  filtertext="All";
                  // setState(() {
                  _getData();
                  print("full list");
                  print(_vehiclesData.length);
                  //  });
                }
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              hintText: 'Search Vehicles',
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500],size: 18),
              suffixIcon: (_etSearch.text == '') ? null : GestureDetector(
                  onTap: () {
                    filtertext="All";
                    //setState(() {
                    _getData();
                    _etSearch = TextEditingController(text: '');
                    //  });
                  },
                  child: Icon(Icons.close, color: Colors.grey[500],size: 16)),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        ),
        *//*Container(
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => _topSearchColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )
                  ),
                ),
                onPressed: () {
                  Fluttertoast.showToast(msg: 'Click search', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(Icons.search, color: Colors.grey[500], size: 18,),
                    SizedBox(width: 8),
                    Text(
                      'Search product',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )
            ),
          ),*//*
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[200]!,
                        width: 1.0,
                      )
                  ),
                  color: Colors.grey.shade200
              ),
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
              )
            *//*ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: Text('Nearby'),
                  labelStyle: TextStyle(color: _isNearby?Colors.white:Colors.black),
                  selected: _isNearby,
                  onSelected: (bool selected) {
                    refreshData();
                    setState(() {
                      _isNearby = !_isNearby;
                    });
                  },
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.grey[200],
                  selectedColor: PRIMARY_COLOR,
                  checkmarkColor: Colors.white,
                ),
                SizedBox(width: 12),
                FilterChip(
                  label: Text('Best Seller'),
                  labelStyle: TextStyle(color: _isBestSeller?Colors.white:Colors.black),
                  selected: _isBestSeller,
                  onSelected: (bool selected) {
                    refreshData();
                    setState(() {
                      _isBestSeller = !_isBestSeller;
                    });
                  },
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.grey[200],
                  selectedColor: PRIMARY_COLOR,
                  checkmarkColor: Colors.white,
                ),
                SizedBox(width: 12),
                FilterChip(
                  label: Text('Promo'),
                  labelStyle: TextStyle(color: _isPromo?Colors.white:Colors.black),
                  selected: _isPromo,
                  onSelected: (bool selected) {
                    refreshData();
                    setState(() {
                      _isPromo = !_isPromo;
                    });
                  },
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.grey[200],
                  selectedColor: PRIMARY_COLOR,
                  checkmarkColor: Colors.white,
                ),
                SizedBox(width: 12),
                FilterChip(
                  label: Text('New Comers'),
                  labelStyle: TextStyle(color: _isNewComers?Colors.white:Colors.black),
                  selected: _isNewComers,
                  onSelected: (bool selected) {
                    refreshData();
                    setState(() {
                      _isNewComers = !_isNewComers;
                    });
                  },
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.grey[200],
                  selectedColor: PRIMARY_COLOR,
                  checkmarkColor: Colors.white,
                ),
                SizedBox(width: 12),
                FilterChip(
                  label: Text('Drink'),
                  labelStyle: TextStyle(color: _isDrink?Colors.white:Colors.black),
                  selected: _isDrink,
                  onSelected: (bool selected) {
                    refreshData();
                    setState(() {
                      _isDrink = !_isDrink;
                    });
                  },
                  elevation: 0,
                  pressElevation: 0,
                  backgroundColor: Colors.grey[200],
                  selectedColor: PRIMARY_COLOR,
                  checkmarkColor: Colors.white,
                ),
              ],
            ),*//*
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),

        ),

        actions: [

          IconButton(
              icon :Icon(Icons.refresh_sharp, color: _color1),
              //icon: _globalWidget.customNotifIcon(count: 8, notifColor: _color1, notifSize: 24, labelSize: 14),
              //icon: _globalWidget.customNotifIcon2(8, _color1),
              onPressed: () {
                _getData();
                *//* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),

               *//**//*   Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => BottomNavigation( loginModel: response)),
                        builder: (context) => NotificationsPage()),*//**//*

                  );*//*
                // Fluttertoast.showToast(msg: 'Click notification', toastLength: Toast.LENGTH_SHORT);
              }),
        ],
      ),*/
      body: _child,
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
/*
  Widget radioStar(String txt, int index) {
    return GestureDetector(
      onTap: () {

        setState(() {
          starIndex = index;
          _tabIndex = index;
          if(index ==0){
            filterSearchResults("All");
          }else if(index ==1){
            filterSearchResults("online");
          }
          else if(index ==2){
            filterSearchResults("stoppedvehile");
          }

          else if(index ==3){
            filterSearchResults("offline");
          }
          else if(index ==4){
            filterSearchResults("expire");
          }
        });
        Fluttertoast.showToast(msg: 'Click TabBar', toastLength: Toast.LENGTH_SHORT);
        print('idx : '+_tabIndex.toString());

      },
      child: Container(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: starIndex == index ? themeDark : Colors.white,
              border: Border.all(
                  width: 1.0,
                  color: starIndex == index ? themeDark : themeDark),
              borderRadius: BorderRadius.all(Radius.circular(7))),
          child: index == 0
              ? Text(txt, style: TextStyle(color: starIndex == index ? Colors.white : themeDark ))
              : Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(txt, style: TextStyle(color: starIndex == index ? Colors.white : themeDark )),
              SizedBox(width: 2),
              //Icon(Icons.star, color: starIndex == index ? Colors.white : Colors.yellow[700], size: 12),
            ],
          )),
    );
  }
*/

  Widget devicesListwidget(double boxImageSize) {
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
    filtertext = query;
    print("inside filter");
    _vehiclesData_duplicate.clear();
    if (query.isNotEmpty && query != "All") {
      for (int i = 0; i < _vehiclesData_sorted.length; i++) {
        deviceItems model = _vehiclesData_sorted.elementAt(i);

        if (filtertext == "Offline") {
          if (model.online.toString().toLowerCase().contains("offline") &&
              model.time.toString().toLowerCase().contains("not connected")) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('Offline');
          }
        }
        else if (query == "Running") {
          if (model.online.toString().toLowerCase().contains("online")) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('Running');
          }
        }
        else if(query =="Idle"){
          if (model.online.toString().toLowerCase().contains("ack") &&
              double.parse(model.speed.toString()) < 1.0) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('Idle');
          }
        }
        else if (query == "Stopped") {
          if (model.online
              .toString()
              .toLowerCase()
              .contains("offline") &&
              model.time.toString().toLowerCase() != "not connected") {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('Stopped');
          }
        }


        else if (query == "expire") {
          if (model.time.toString().toLowerCase().contains("expire")) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('expire');
          }
        }
        else {
          if (model.name.toString().toLowerCase().contains(query
              .toLowerCase()) /*||
                  model.devicedata!.first.imei!.contains(query.toLowerCase())*/
          ) {
            _vehiclesData_duplicate.add(_vehiclesData_sorted.elementAt(i));
            print('item exists');
          }
        }
      }

      setState(() {});
    } else {
      if (query == "All") {
        _vehiclesData_duplicate.addAll(_vehiclesData_sorted);
        print('All');
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
          padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
          margin: EdgeInsets.only(left: 5),

          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Fluttertoast.showToast(msg: 'Click ${productData.name}', toastLength: Toast.LENGTH_SHORT);
                },
                child: Row(
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
                          Row(children:[Container(
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
                          ), Spacer(), Text(''+
                              productData.name.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: themeDark
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )]),
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
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text('IMEI: '+
                                      productData.deviceData!.imei.toString(),
                                    style: TextStyle(
                                      fontSize: 9,
                                      //color: _color2
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Spacer(),
                                Text("Expire on",style: TextStyle(
                                    fontSize: 9,
                                    color: SOFT_GREY
                                ))
                              ]
                          ),


                          Row(children:[Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                // Icon(Icons.history_toggle_off, color: SOFT_GREY, size: 12),
                                Text((speed>0)?'Moving since: '+productData.stopDuration!:'Stopped since: '+productData.stopDuration!,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: statuscolor
                                    ))
                              ],
                            ),
                          ), Spacer(), Container(
                            margin: EdgeInsets.only(top: 5),
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
                ),
              ),
              // _buildGoogleMap(lat,lng,course,imei),
              /*Container(
              height: 80,
              child: GoogleMap(
                mapType:MapType.normal,
               */
              /* gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),)
                ].toSet(),*/
              /*
                initialCameraPosition: CameraPosition(
                  zoom: 14,
                  target: LatLng(lat,lng),

                ),

                //myLocationButtonEnabled: true,
               // markers: getmarkers(),
                onMapCreated: (GoogleMapController controller){
                  _mapController.complete(controller);
                },

                //zoomGesturesEnabled: true,
                //zoomControlsEnabled: true,
              ),
            ),*/
              /*Row(children: [
                InkWell(
                  onTap:(){


                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .10,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: [
                        Icon(Icons.notifications_sharp,
                            color: Colors.grey.shade200,
                            size: 22.0),
                        Text('Engine h',
                          style: TextStyle(
                              fontSize: 8),)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap:(){

                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .15,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: [
                        Icon(Icons.notifications_sharp,
                            color: Colors.grey.shade200,
                            size: 22.0),
                        Text('Odometer',
                          style: TextStyle(
                              fontSize: 8),)
                      ],
                    ),
                  ),
                ),
                // InkWell(
                //   onTap:(){
                //     Navigator.pushNamed(context, "/deviceDashboard", arguments: DeviceArguments(
                //         device['id'], device['name'], device));
                //   },
                //   child: Container(
                //     // decoration: BoxDecoration(
                //     //     border: Border(
                //     //       right: BorderSide(
                //     //           width: 0.5,
                //     //           color: Colors
                //     //               .grey),
                //     //     )
                //     // ),
                //     width: MediaQuery
                //         .of(context)
                //         .size
                //         .width * .25,
                //     height: 80,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment
                //           .center,
                //       mainAxisAlignment: MainAxisAlignment
                //           .center,
                //       children: [
                //         Icon(Icons.dashboard,
                //             color: CustomColor
                //                 .primaryColor,
                //             size: 22.0),
                //         Text('Dashboard',
                //           style: TextStyle(
                //               fontSize: 12),)
                //       ],
                //     ),
                //   ),
                // ),
                InkWell(
                  onTap:(){

                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .10,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: [
                        Icon(Icons.notifications_sharp,
                            color: Colors.grey.shade200,
                            size: 22.0),
                        Text("Reports",
                          style: TextStyle(
                              fontSize: 8),)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap:(){

                  },
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .10,
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: [
                        Icon(Icons.notifications_sharp,
                            color: Colors.grey.shade200,
                            size: 22.0),
                        Text('Lock',
                          style: TextStyle(
                              fontSize: 8),)
                      ],
                    ),
                  ),
                ),
              ]),*/


              (productData.sensors != null)?
              Container(
                height: 60,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productData.sensors!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(left: 4.0, right: 8,top: 25),
                        child: Container(
                          // padding: EdgeInsets.all(8),

                            child:   Column(
                                children: <Widget>[
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'ignition'
                                      ? Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'odometer'
                                      ? Image.asset("assets/sensorsicon/speedometeron.png", height: imageSize,width: imageSize)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'battery'
                                      ? Icon(
                                    FontAwesomeIcons.batteryFull, size: 16,color:Colors.grey.shade400,) :

                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'charge'
                                      ? Icon(
                                    Icons.battery_charging_full, size: 16,color:Colors.grey.shade400,)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'engine lock'
                                      ? Icon(
                                    Icons.hourglass_bottom_rounded, size: 16,color:Colors.grey.shade400,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gps'
                                      ? Icon(
                                    Icons.gps_fixed_outlined, size: 16,color:Colors.grey.shade400,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gsm'
                                      ? Image.asset("assets/sensorsicon/connectedon.png", height: imageSize,width: imageSize):
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'moving'
                                      ? Icon(Icons.moving_outlined, size: 16,color:Colors.grey.shade400,) :
                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'gps starting km'
                                      ? Icon(
                                    Icons.gps_fixed_outlined, size: 16,color:Colors.grey.shade400,) :

                                  productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'temp'
                                      ? Icon(
                                    FontAwesomeIcons.temperatureLow, size: 16,color:Colors.grey.shade400,)
                                      : productData.sensors![index].type
                                      .toString()
                                      .toLowerCase() ==
                                      'engine_hours'
                                      ? Icon(Icons.alarm, size: 16,color:Colors.grey.shade400,)
                                      : Icon(Icons.charging_station, size: 16,color:Colors.grey.shade400,),
                                  //Icon(Icons.engineering,size:imageSize),
                                  // Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize),
                                  Text(productData.sensors![index].name.toString(),  style: TextStyle(
                                      fontSize: 7,height: 1.5, color: SOFT_GREY)),
                                  Text("${productData.sensors![index].value.toString()}",  style: TextStyle(
                                      fontSize: 7,height: 1, color: SOFT_GREY))
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
                  margin: EdgeInsets.only(top: 16),
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
                                      builder: (context) => livetrack()),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  child:   Column(
                                      children: <Widget>[
                                        //Icon(Icons.engineering,size:imageSize),
                                        Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize),
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
                //margin: EdgeInsets.only(top: 12),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => livetrack()),
                              );
                              //Fluttertoast.showToast(msg: 'Item has been added to Shopping Cart');
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 30)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child:Row(
                                children: <Widget>[
                                  Image.asset("assets/images/mylocationcolor.png", height: imageSize,width: imageSize),
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


                              _timerDummy?.cancel();



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
                                    Size(0, 30)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child:Row(
                                children: <Widget>[
                                  Image.asset("assets/images/icons8-play-100.png", height: imageSize,width: imageSize),
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
                                    Size(0, 30)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: SOFT_GREY,
                                      width: 0.5
                                  ),
                                )
                            ),
                            child:Row(
                                children: <Widget>[
                                  //Icon(Icons.info_outline, size: imageSize,color: Colors.red,),
                                  Image.asset("assets/images/icons8-info-popup-100.png", height: imageSize,width: imageSize),
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
                        _timerDummy?.cancel();
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
                                child: _showDeliveryPopup()
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
                                width: 1, color: Colors.grey[300]!)),
                        child: Icon(Icons.app_settings_alt_outlined,
                            color: _color1, size: 20),
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



  Widget _showDeliveryPopup(){
    double imageSize = MediaQuery.of(context).size.width/17;
    return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
      return Container(
          margin: EdgeInsets.only(left: 10,right: 10, bottom: 140),
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
                child: Container(
                  margin: EdgeInsets.only(top: 12,),
                  /* width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10)
              ),*/
                  child:  Text(''+StaticVarMethod.deviceName,  style: TextStyle(
                      fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold)),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => livetrack()),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/movingdurationicon.png", height: imageSize,width: imageSize),
                                        Text('Live Map',  style: TextStyle(
                                            fontSize: 12,height: 2))
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/icons8-bar-chart-100.png", height: imageSize,width: imageSize),
                                        Text('KM Detail',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
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

                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:BorderRadius.all(Radius.circular(15)),
                                    // borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 1.0,
                                        //offset: const Offset(0.0, 10.0),
                                      ),
                                    ],
                                  ),
                                  // color: Colors.white,
                                  //color: Color(0x99FFFFFF),
                                  child:   Column(
                                      children: <Widget>[
                                        Image.asset("assets/images/icons8-play-100.png", height: imageSize,width: imageSize),
                                        Text('Playback',  style: TextStyle(
                                            fontSize: 12,height: 2.0))
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1.0,
                                    //offset: const Offset(0.0, 10.0),
                                  ),
                                ],
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/icons8-bar-chart-100.png", height: imageSize,width: imageSize),
                                    Text(' Reports ',  style: TextStyle(
                                        fontSize: 12,height: 2.0))
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CommandWindowPage()),
                            // );

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1.0,
                                    //offset: const Offset(0.0, 10.0),
                                  ),
                                ],
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/icons8-play-100.png", height: imageSize,width: imageSize),
                                    Text('  Lock  ',  style: TextStyle(
                                        fontSize: 12,height: 2.0))
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1.0,
                                    //offset: const Offset(0.0, 10.0),
                                  ),
                                ],
                              ),
                              // color: Colors.white,
                              //color: Color(0x99FFFFFF),
                              child:   Column(
                                  children: <Widget>[
                                    Image.asset("assets/images/icons8-info-popup-100.png", height: imageSize,width: imageSize),
                                    Text(' Car Info ',  style: TextStyle(
                                        fontSize: 12,height: 2.0))
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

  //
  // Widget _buildGoogleMap() {
  //   return
  //     Container(
  //       height: 80,
  //       child:GoogleMap(
  //         mapType: MapType.normal,
  //         trafficEnabled: false,
  //         compassEnabled: false,
  //         rotateGesturesEnabled: true,
  //         scrollGesturesEnabled: true,
  //         tiltGesturesEnabled: true,
  //         zoomControlsEnabled: false,
  //         zoomGesturesEnabled: true,
  //         myLocationButtonEnabled: false,
  //         myLocationEnabled: true,
  //         mapToolbarEnabled: false,
  //         markers: Set<Marker>.of(_allMarker.values),
  //         initialCameraPosition: CameraPosition(
  //           target: _initialPosition,
  //           zoom: _currentZoom,
  //         ),
  //         onCameraMove: _onGeoChanged,
  //         onCameraIdle: (){
  //           if(_isBound==false && _doneListing==true) {
  //             _isBound = true;
  //             CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
  //             this._controller.moveCamera(u2).then((void v){
  //               _check(u2,this._controller);
  //             });
  //           }
  //         },
  //         onMapCreated: (GoogleMapController controller) {
  //           _controller = controller;
  //
  //           // we use timer for this demo
  //           // in the real application, get all marker from database
  //           // Get the marker from API and add the marker here
  //           _timerDummy = Timer(Duration(seconds: 0), () {
  //
  //             setState(() {
  //               _mapLoading = false;
  //
  //               // add all marker here
  //               /*   for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
  //
  //               if(StaticVarMethod.devicelist[i].lat != 0) {
  //
  //                   var color;
  //                   if(StaticVarMethod.devicelist[i].online!.contains('online')){
  //                     color=Colors.green;
  //                   }else if(StaticVarMethod.devicelist[i].speed! > 0){
  //                     color=Colors.green;
  //                   }else{
  //                     color=Colors.red;
  //                   }
  //                   double lat = StaticVarMethod.devicelist[i].lat as double;
  //                   double lng = StaticVarMethod.devicelist[i].lng as double;
  //                   //double angle =  StaticVarMethod.devicelist[i].course as double;
  //                   LatLng position = LatLng(lat, lng);
  //                   _latlng.add(position);
  //                   _createImageLabel(label: StaticVarMethod.devicelist[i].name.toString(), imageIcon: _iconFacebook,course :StaticVarMethod.devicelist[i].course.toDouble(),color: color).then((BitmapDescriptor customIcon) {
  //                       setState(() {
  //                       _mapLoading = false;
  //                     _allMarker[MarkerId(i.toString())] = Marker(
  //                     markerId: MarkerId(i.toString()),
  //                     position: position,
  //                     //rotation: 0.0,
  //                     infoWindow: InfoWindow(
  //                         title: 'This is marker ' + (i + 1).toString()),
  //                     onTap: () {
  //                       Fluttertoast.showToast(
  //                           msg: 'Click marker ' + (i + 1).toString(),
  //                           toastLength: Toast.LENGTH_SHORT);
  //                     },
  //                     icon:  customIcon
  //                   );
  //                   });
  //                   });
  //                   if (i == StaticVarMethod.devicelist.length - 1) {
  //                     _doneListing = true;
  //                   }
  //
  //               }
  //
  //
  //           }*/
  //               updateMarker();
  //               // zoom to all marker
  //               if(_isBound==false && _doneListing==true) {
  //                 _isBound = true;
  //                 CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 100);
  //                 this._controller.moveCamera(u2).then((void v){
  //                   _check(u2,this._controller);
  //                 });
  //               }
  //               _mapLoading = false;
  //             });
  //
  //           });
  //         },
  //         onTap: (pos){
  //           print('currentZoom : '+_currentZoom.toString());
  //         },
  //       ),
  //     );
  // }
  //
  // updateMarker(){
  //
  //   Fluttertoast.showToast(
  //       msg: 'Click marker ' + ( 1).toString(),
  //       toastLength: Toast.LENGTH_SHORT);
  //   //_allMarker.clear();
  //   for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
  //
  //     if(StaticVarMethod.devicelist[i].lat != 0) {
  //
  //       var color;
  //       var label;
  //
  //       if(StaticVarMethod.devicelist[i].speed!.toInt() > 0){
  //         color=Colors.green;
  //         label= StaticVarMethod.devicelist[i].name.toString() + '('+StaticVarMethod.devicelist[i].speed!.toString()+' km)';
  //       }
  //       else  if(StaticVarMethod.devicelist[i].online!.contains('online')){
  //         color=Colors.green;
  //         label= StaticVarMethod.devicelist[i].name.toString();
  //
  //       }else{
  //         color=Colors.red;
  //         label= StaticVarMethod.devicelist[i].name.toString();
  //       }
  //       double lat = StaticVarMethod.devicelist[i].lat as double;
  //       double lng = StaticVarMethod.devicelist[i].lng as double;
  //       //double angle =  StaticVarMethod.devicelist[i].course as double;
  //       LatLng position = LatLng(lat, lng);
  //       _latlng.add(position);
  //       _createImageLabel(label: label,course :StaticVarMethod.devicelist[i].course.toDouble(),color: color).then((BitmapDescriptor customIcon) {
  //         if (mounted) {
  //           setState(() {
  //             _mapLoading = false;
  //             _allMarker[MarkerId(i.toString())] = Marker(
  //                 markerId: MarkerId(i.toString()),
  //                 position: position,
  //                 //rotation: 0.0,
  //                 infoWindow: InfoWindow(
  //                     title: 'This is marker ' + (i + 1).toString()),
  //                 onTap: () {
  //                   Fluttertoast.showToast(
  //                       msg: 'Click marker ' + (i + 1).toString(),
  //                       toastLength: Toast.LENGTH_SHORT);
  //                 },
  //                 anchor: Offset(0.5, 0.5),
  //                 icon:  customIcon
  //             );
  //           });
  //         }
  //
  //       });
  //       if (i == StaticVarMethod.devicelist.length - 1) {
  //         _doneListing = true;
  //       }
  //
  //     }
  //
  //
  //   }
  // }
  //
  // Set<Marker> getmarkers()  {
  //
  //
  // /*  return await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),
  //       "assets/icons/igniton.png"
  //   );*/
  // /*  for(int mrk = 0; mrk < vehicleList.length; mrk++){
  //     _setMarkerIcon() async {
  //       if(vehicleList[mrk].ignition == true){
  //         _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),
  //             "assets/icons/igniton.png"
  //         );
  //       } else if(vehicleList[mrk].ignition == true && vehicleList[mrk].motion == false){
  //         _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),
  //             "assets/icons/ignitidle.png"
  //         );
  //       } else if(vehicleList[mrk].ignition != true){
  //         _markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),
  //             "assets/icons/ignitoff.png"
  //         );
  //
  //       }
  //
  //
  //       return _markerIcon;
  //     }
  //     if(vehicleList[mrk].ignition == true && vehicleList[mrk].motion == false){
  //       markers.add(
  //           Marker(
  //             markerId: MarkerId(vehicleList[mrk].location.toString()),
  //             position: LatLng(vehicleList[mrk].latitude!.toDouble(), vehicleList[mrk].longitude!.toDouble()),
  //             icon:  _idlemarkerIcon,
  //             rotation: vehicleList[mrk].heading!.toDouble(),
  //             infoWindow: InfoWindow(
  //               title: vehicleList[mrk].location,
  //             ),
  //           )
  //       );
  //     }
  //     else if(vehicleList[mrk].ignition == true && vehicleList[mrk].motion == true){
  //       markers.add(
  //           Marker(
  //             markerId: MarkerId(vehicleList[mrk].location.toString()),
  //             position: LatLng(vehicleList[mrk].latitude!.toDouble(), vehicleList[mrk].longitude!.toDouble()),
  //             icon:  _markerIcon,
  //             rotation: vehicleList[mrk].heading!.toDouble(),
  //             infoWindow: InfoWindow(
  //               title: vehicleList[mrk].location,
  //             ),
  //           )
  //       );
  //     }
  //     else if(vehicleList[mrk].ignition != true) {
  //       markers.add(
  //           Marker(
  //
  //             markerId: MarkerId(vehicleList[mrk].location.toString()),
  //             position: LatLng(vehicleList[mrk].latitude!.toDouble(), vehicleList[mrk].longitude!.toDouble()),
  //             icon:  _offmarkerIcon,
  //             rotation: vehicleList[mrk].heading!.toDouble(),
  //             infoWindow: InfoWindow(
  //               title: vehicleList[mrk].location,
  //             ),
  //           )
  //       );
  //     }
  //
  //
  //   }*/
  //
  //  /* markers.add(
  //       Marker(
  //         markerId: MarkerId(vehicleList[mrk].location.toString()),
  //         position: LatLng(vehicleList[mrk].latitude!.toDouble(), vehicleList[mrk].longitude!.toDouble()),
  //         icon:  _idlemarkerIcon,
  //         rotation: vehicleList[mrk].heading!.toDouble(),
  //         infoWindow: InfoWindow(
  //           title: vehicleList[mrk].location,
  //         ),
  //       )
  //   );*/
  //   return markers;
  // }
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
    setState(() {
      _vehiclesData.clear();
      _loading = true;
      _getData();
    });
  }
}
