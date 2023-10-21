import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:maktrogps/bloc/kmandfuelhistory/bloc/kmandfuelhistory_bloc.dart';
import 'package:maktrogps/config/constant.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/devices.dart';
import 'package:maktrogps/data/model/history.dart';
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
import 'package:maktrogps/data/screens/trip/tripinfoselectionscreen.dart';
import 'package:maktrogps/data/screens/vehicle_dasboard.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';
import 'package:maktrogps/ui/reusable/cache_image_network.dart';
import 'package:maktrogps/ui/reusable/global_function.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:maktrogps/ui/reusable/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../mvvm/view_model/objects.dart';
import 'LiveMapScreen/LiveMapScreen.dart';
import 'commands/CommandWindow.dart';
import 'livetrack.dart';
import 'lockscreen.dart';
import 'lockscreenNew.dart';
import 'reports/kmdetail.dart';

class listscreen extends StatefulWidget {

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
    'All Vehicle',
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

  late SharedPreferences prefs;
  late ObjectStore objectStore;

  KmandfuelHistoryBloc kmhistorybloc = KmandfuelHistoryBloc();
  @override
  void initState() {
    kmhistorybloc.add(KmandfuelHistoryInitialFetchEvent());
    checkPreference();
    _setSourceAndDestinationIcons();
    super.initState();

  }
  void checkPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
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

      StaticVarMethod.devicelist = _vehiclesData;


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

    return
      Scaffold(
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
              hintStyle: TextStyle(fontSize: 16, color:Colors.grey.shade800 /*Colors.white*/),
              prefixIcon:
              Icon(Icons.search, color:Colors.black/*Colors.white*/, size: 18),
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
            : /*Center(child: Text("List of Vehicles")),*/ Image.asset(StaticVarMethod.listimageurl, height: 40),
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
              padding: EdgeInsets.fromLTRB(5, 5, 10, 10),
             // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 90,
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
          preferredSize: Size.fromHeight(90),
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
                 // _getData();
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
    Color iconcolor= Color(0xffA01490);
    var txt1="(0)";
    if (index == 0) {
      txt= txt;
      txt1=_vehiclesData.length.toString();
      iconcolor= Color(0xffA01490);
    } else if (index == 1) {
      statuscolor= Colors.green.shade100;
      txt= txt;
      txt1= _runningVehicles.length.toString();
      iconcolor= Color(0xff40d30f);
    } else if (index == 2) {
      statuscolor= Colors.red.shade100;
      txt= txt;
      txt1= _stoppedVehicles.length.toString();
      iconcolor= Colors.red;
    }
    else if (index == 3) {
      statuscolor= Colors.yellow.shade100;
      txt= txt;
      txt1= _idleVehicles.length.toString();
      iconcolor=Color(0xffffda07);
    }
    else if (index == 4) {
      statuscolor= Colors.blue.shade100;
      txt= txt;
      txt1= _inactiveVehicles.length.toString();
      iconcolor= Colors.blue;
    }
    else if (index == 5) {
      statuscolor= Colors.grey.shade100;
      txt= txt;
      txt1= '0';
      iconcolor= Colors.grey;
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

      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 15, 0, 10),
            padding: EdgeInsets.only(bottom: 5),
            height: 55,
            width: 57,
            decoration:  BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 5,
                  )
                ],
                color: Color(0xffEFEDF8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text(txt1,
                    style: TextStyle(
                      color: starIndex == index
                          ? Colors.blue
                          : primaryDark,
                      fontSize: 10,fontWeight: FontWeight.bold)),
                SizedBox(height: 5,),
                Text(txt,
                    style: TextStyle(
                      color: starIndex == index
                          ? Colors.blue
                          : primaryDark,
                      fontSize: 10,))

                // index == 0
                //     ? Text(txt,
                //     style: TextStyle(
                //       color: starIndex == index
                //           ? Colors.blue
                //           : primaryDark,
                //       fontSize: 10,))
                //     : Wrap(
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     Text(txt,
                //         style: TextStyle(
                //           color: starIndex == index
                //               ? Colors.blue
                //               : primaryDark,
                //           fontSize: 10,)),
                //     SizedBox(width: 2) ,
                //     //Icon(Icons.star, color: starIndex == index ? Colors.white : Colors.yellow[700], size: 12),
                //   ],
                // ),
              ],
            ),

          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child:
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              height: 35,
              width: 35,
              decoration:  BoxDecoration(
                  color: iconcolor.withOpacity(0.4),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(100),
                  )),
              child:  Container(
                margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                height: 17,
                width: 17,
                decoration:  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff477d78),//.withOpacity(0.6),
                        blurRadius: 15,
                      )
                    ],
                    color: iconcolor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                      topRight: Radius.circular(100),
                      topLeft: Radius.circular(100),
                    )),
                child:Image(image: AssetImage('assets/tbtrack/carup.png',),
                  color:Colors.white,),

              ),
            ),


          )
        ],
      ),
      /*Container(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: starIndex == index ? primaryDark : statuscolor,
              border: Border.all(
                  width: 1.8,
                  color: Color(0xffFFFFFF)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child:
          index == 0
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
              SizedBox(width: 2) ,
              //Icon(Icons.star, color: starIndex == index ? Colors.white : Colors.yellow[700], size: 12),
            ],
          )
      ),*/
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

    String iconpath = 'assets/tbtrack/truck_sidestop.png';
    if (productData.speed!.toInt() > 0) {
      iconpath = 'assets/tbtrack/truck_siderunning.png';

      if(StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString())!=null)
        iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString()).toString()+"siderunning.png";

    }
    else if (productData.online.toString().toLowerCase().contains("ack") &&
        double.parse(productData.speed.toString()) < 1.0) {
      iconpath = 'assets/tbtrack/truck_sideidle.png';

      if(StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString())!=null)
        iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString()).toString()+"_sideidle.png";

    }
    else if (productData.online!.contains('online')) {
      iconpath = 'assets/tbtrack/truck_siderunning.png';

      if(StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString())!=null)
        iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString()).toString()+"siderunning.png";

    } else {
      iconpath = 'assets/tbtrack/truck_sidestop.png';



      if(StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString())!=null)
        iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(productData.deviceData!.imei.toString()).toString()+"sidestop.png";

    }
    return   GestureDetector(
        onTap: (){


          _timerDummy?.cancel();
          StaticVarMethod.deviceName=productData.name.toString();
          StaticVarMethod.deviceId=productData.id.toString();
          StaticVarMethod.imei=productData.deviceData!.imei.toString();
          StaticVarMethod.simno=productData.deviceData!.simNumber.toString();
          StaticVarMethod.lat=productData.lat!.toDouble();
          StaticVarMethod.lng=productData.lng!.toDouble();
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
      Fluttertoast.showToast(msg: 'Click ${productData.name}', toastLength: Toast.LENGTH_SHORT);
    },
    child:Container(
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
            color: Color(0xffEFEEF8),
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
                    // ClipRRect(
                    //   borderRadius: BorderRadius.all(Radius.circular(10)),
                    //
                    //   child:Image.asset("assets/rotatingicon/2.png", height: boxImageSize,width: boxImageSize)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top:0),
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              // color: (carstatus.contains("online"))? Colors.green.withOpacity(0.3):Colors.red.withOpacity(0.3),

                              borderRadius: BorderRadius.all(Radius.circular(15)),

                            ),
                            child:Image.asset(iconpath,
                                height: 80,width: 80)
                        ),

                        Row(
                            children:[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 15),
                                child:  Image.asset("assets/tbtrack/outlinedcircle.png",
                                    height: 8,width: 8),
                              ),
                              Container(
                                height:30 ,
                                width: 60,
                                child: Text(''+
                                    productData.deviceData!.name.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff494C60),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),


                              /*Text("Expire on",style: TextStyle(
                                  fontSize: 9,
                                  color: SOFT_GREY
                              )
                              )*/
                            ]
                        ),
                        /*Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 2, 0),
                              child:  Image.asset("assets/tbtrack/outlinedcircle.png",
                                  height: 6,width: 6),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                              child:  Text(
                                ('UP14KT2816'),
                                style: TextStyle(
                                    //fontFamily: "Sans",
                                    color: Colors.black,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),*/
                        /*Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 5, 0),
                          child:  Text(
                            ('(35)'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff494C60),
                                fontSize: 12),
                          ),
                        ),*/
                      ],
                    ),

                    //child: buildCacheNetworkImage(width: boxImageSize, height: boxImageSize, url: productData.image)),
                    SizedBox(
                      width: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          height:140,
                          width: 70,
                          //color:Colors.yellowAccent,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 11, 0, 5),
                                  child:  Text('LAST PACKET',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,

                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                                  child:  Text('Today Km',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,
                                      height: 3,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                  child:    Text('FUEL',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,
                                      height: 2,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child:  Text('SPEED',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,
                                      height: 2,
                                    ),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                                  child:   Text('SINCE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,
                                      height: 2,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          height:140,
                          width: 10,
                          // color:Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child:  Image.asset("assets/tbtrack/fillcircle.png",
                                      height: 6,width: 6,color:Color(0xff7E3885)),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 2, 0, 3),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Image.asset("assets/tbtrack/fillcircle.png",
                                    height: 6,width: 6,color:Color(0xffE83F82)),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 3),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Image.asset("assets/tbtrack/fillcircle.png",
                                    height: 6,width: 6,color:Color(0xff26C090)),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 3),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Image.asset("assets/tbtrack/fillcircle.png",
                                    height: 6,width: 6,color:Color(0xffBD712E)),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 0),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(2, 1, 0, 3),
                                  child:  Image.asset("assets/tbtrack/ellipse.png",
                                      height: 2.5,width: 2.5,color:Colors.black26),
                                ),
                                Image.asset("assets/tbtrack/fillcircle.png",
                                    height: 6,width: 6,color:Color(0xffA731F7)),
                              ]
                          ),
                        ),
                        Container(
                          height:140,
                          width: 75,
                          // color:Colors.greenAccent,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:  EdgeInsets.fromLTRB(0, 10, 10, 0),
                                  // padding:  EdgeInsets.fromLTRB(5, 11, 10, 0),
                                  child:  Text(productData.time.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,
                                      height: 0,
                                    ),
                                  ),
                                ),

                                // Container(
                                //   margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                //   child:  BlocConsumer<KmandfuelHistoryBloc, KmandfuelHistoryState>(
                                //     bloc : kmhistorybloc,
                                //     listenWhen: (previous,current) => current is KmandfuelHistoryActionState,
                                //     buildWhen: (previous,current) => current is !KmandfuelHistoryActionState,
                                //     listener: (context, state) {
                                //       // TODO: implement listener
                                //     },
                                //     builder: (context, state) {
                                //       switch(state.runtimeType){
                                //         case KmandfuelHistoryFetchingLoadingState:
                                //           return const Center(
                                //             child: CircularProgressIndicator(),
                                //           );
                                //         case KmandfuelHistoryFetchingSuccessfulState:
                                //           final successState= state as KmandfuelHistoryFetchingSuccessfulState;
                                //           return   Text( successState.history.distanceSum.toString() +' km',
                                //               style: TextStyle(
                                //                 fontSize: 10,
                                //                 color: Colors.black45,
                                //
                                //               ),
                                //           );
                                //         default:
                                //           return const SizedBox();
                                //       }
                                //       return Container();
                                //     },
                                //   ),
                                // ),

                                kmandfueldetail(productData.id),
                                // Container(
                                //   margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                //   child:   Text(' km',
                                //     style: TextStyle(
                                //       fontSize: 10,
                                //       color: Colors.black45,
                                //
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                //   child:    Text('0.00',
                                //     style: TextStyle(
                                //       fontSize: 10,
                                //       color: Colors.black45,
                                //
                                //     ),
                                //   ),
                                // ),


                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                  child:  Text(speed.toString()+' km/h',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,

                                    ),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                  child:   Text(productData.stopDuration.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45,

                                    ),
                                  ),
                                ),
                              ]
                            //Row(children:[Text("Some Data"), Spacer(), Text("Some Data")]),
                            /*   Row(children:[
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: (productData.speed! > 0) ? BlinkText(
                                    ''+productData.speed.toString() +' KM/H',
                                    style: TextStyle(fontSize: 12.0, color: Colors.greenAccent,
                                      //fontFamily: 'digital_font'
                                    ),
                                    endColor: Colors.orange,
                                  )
                                      : Text(productData.speed.toString() +' KM/H',
                                      style: TextStyle(
                                        fontSize: 12,
                                        //fontFamily: 'digital_font',
                                        //fontWeight: FontWeight.bold,

                                      )),
                                ),

                                Text(''+
                                    productData.name.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: themeDark
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ]
                              ), *//*Container(
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
                          ),*//*
                              *//*Row(
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
                          ),*//*
                              Row(children:[Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    // Icon(Icons.history_toggle_off, color: SOFT_GREY, size: 12),
                                    Text((speed>0)?'Moving since: '+productData.stopDuration!:
                                    'Stopped since: '+productData.stopDuration!,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: statuscolor
                                        ))
                                  ],
                                ),
                              ),


                                Container(margin: EdgeInsets.only(top: 5),
                                  child: Text(productData.time.toString(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: SOFT_GREY
                                      )),
                                )]),*/


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

                          ) ,
                        ),

                        (productData.sensors!.isNotEmpty)?
                        Container(
                             height:140,
                             width: 60,
                          child: ListView.builder(

                              scrollDirection: Axis.vertical,
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
                          height:140,
                          width: 42,
                          //color:Colors.blue,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child:  Image.asset("assets/tbtrack/frozen.png",
                                      height: 15,width: 15,color:Colors.black38
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child:  Image.asset("assets/tbtrack/battery.png",
                                    height: 18,width: 18,//color:Colors.black38
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child:  Image.asset("assets/tbtrack/signal.png",
                                    height: 15,width: 15,//color:Colors.black38
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    //color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child:  Image.asset("assets/tbtrack/circle.png",
                                      height: 20,width: 20,color:Colors.black38
                                  ),
                                ),

                              ]
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/tbtrack/fillcircle.png",
                      height: 6,width: 6,color:Color(0xffE83F82)),
                  SizedBox(width: 5,),
                  addressLoad(lat.toString(), lng.toString()),

                ],
              ),

              // _buildGoogleMap(lat,lng,course,imei),

            ],
          ),
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
                                    //  builder: (context) => livetrack()),
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
                                        Text('   Live Map   ',  style: TextStyle(
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
                                        Text('   Mileage   ',  style: TextStyle(
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
                                        Text('   Playback   ',  style: TextStyle(
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
                                    Text('    Reports    ',  style: TextStyle(
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
                                    Text('      Lock      ',  style: TextStyle(
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

                                 // builder: (context) => tripinfoselectionscreen()),
                                 // builder: (context) => vehicle_info()),
                                builder: (context) => vehicle_dasboard()),

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
                                    Text('Vehicle Info',  style: TextStyle(
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
  //                   }else if(productData.speed! > 0){
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
  //       if(productData.speed!.toInt() > 0){
  //         color=Colors.green;
  //         label= StaticVarMethod.devicelist[i].name.toString() + '('+productData.speed!.toString()+' km)';
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
    // setState(() {
    //   _vehiclesData.clear();
    //   _loading = true;
    //   //_getData();
    // });
  }

  Widget kmandfueldetail(int deviceId){
    var dev=deviceId;
    return FutureBuilder<History>(
        future: gpsapis.getHistory(deviceId),
        builder: (context, AsyncSnapshot<History> snapshot) {
          if (snapshot.hasData) {

            return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                    child:   Text(snapshot.data!.distanceSum.toString()+' km',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black45,

                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                    child:    Text('0.00',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black45,

                      ),
                    ),
                  ),
                ],
            );
          } else {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                  child:   Text('0 km',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black45,

                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                  child:    Text('0.00',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black45,

                    ),
                  ),
                ),],
            );
          }
        }
    );
  }
  Widget addressLoad(String lat,String lng){
    return FutureBuilder<String>(
        future: gpsapis.geocode(lat, lng),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {

           return Container(
              //color: Colors.red,
              height:35 ,
              width: 310,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child:Text(
                (snapshot.data!.replaceAll('"', '')),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Popins",
                    fontSize: 9),
              ),
            );
            // return Text(snapshot.data!.replaceAll('"', ''),
            //   style: TextStyle(
            //       color: Colors.black,
            //       fontFamily: "Popins",
            //       fontSize: 9),);
          } else {
            return Text("loading...");
          }
        }
    );
  }
}
