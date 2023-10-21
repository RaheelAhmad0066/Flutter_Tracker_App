import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:blinking_text/blinking_text.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maktrogps/config/apps/ecommerce/global_style.dart';
import 'package:maktrogps/config/custom_image_assets.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/screens/livetrackoriginal.dart';
import 'package:maktrogps/data/screens/playbackselection.dart';
import 'package:maktrogps/data/screens/reports/vehicle_info.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constant.dart';
import '../../mvvm/view_model/objects.dart';
import '../model/devices.dart';
import 'livetrack.dart';

class mainmapscreen extends StatefulWidget {
  @override
  _mainmapscreen createState() => _mainmapscreen();
}

class _mainmapscreen extends State<mainmapscreen> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late GoogleMapController _controller;
  bool _mapLoading = true;
  Timer? _timerDummy;

  bool _showMarker = true;
  bool _showTitle = true;
  double _currentZoom = 14;

  LatLng _initialPosition = LatLng(35.168033, 74.900467);
  Location currentLocation = Location();
  Set<Marker> _markers = {};
  /* List<LatLng> _markerList = [];*/

  Map<MarkerId, Marker> _allMarker = {};
  List<LatLng> _latlng = [];
  bool _isBound = false;
  bool _doneListing = false;
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  bool isshowvehicledetail = false;
  var _trafficButtonColor = Colors.grey[700];
  bool isshowvehiclecount = true;

  List<deviceItems> _inactiveVehicles = [];
  List<deviceItems> _runningVehicles = [];
  List<deviceItems> _idleVehicles = [];
  List<deviceItems> _stoppedVehicles = [];

  List<deviceItems> devicesList = [];
  late ObjectStore objectStore;
  @override
  void initState() {
    super.initState();

  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
/*
  Future<Null> _initImage() async {
    final ByteData dataElderly =
    await rootBundle.load('assets/images/direction.png');
    _iconFacebook = await _loadImage(Uint8List.view(dataElderly.buffer));
  }

  Future<ui.Image> _loadImage(List<int> img) async {
    final IMG.Image image = IMG.decodeImage(img)!;
    final IMG.Image resized = IMG.copyResize(image, width: _iconFacebookSize.toInt());
    final List<int> resizedBytes = IMG.encodePng(resized);

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(resizedBytes), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }*/

  Future<BitmapDescriptor> _createImageLabel(
      {String iconpath = '',
      String label = 'label',
      double fontSize = 20,
      double course = 0,
      Color color = Colors.red,
      bool showtitle = true}) async {
    /*ui.PictureRecorder recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    CustomImageAssets imageLabeling = CustomImageAssets(imageLabel: label, imageData: imageIcon, fontSize: fontSize, labelColor: Colors.pinkAccent);

    final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout();

    double rotateRadian = (pi/180.0)*80;
   // canvas.rotate(rotateRadian);
    // label
    imageLabeling.paint(canvas, Size(textPainter.size.width + 30, textPainter.size.height + 25));
    // image
    final ui.Image image = await recorder.endRecording().toImage(
        textPainter.size.width.toInt() + 30,
        textPainter.size.height.toInt() + 35 + _iconFacebookSize.toInt());
    final ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    Uint8List data = byteData.buffer.asUint8List();*/
    //assets/images/direction.png
    //iconpath=StaticVarMethod.baseurlall+"/"+iconpath;

    return getMarkerIcon(iconpath, label, color, course, showtitle);
  }

  /* start additional function for camera update
  - we get this function from the internet
  - if we don't use this function, the camera will not work properly (Zoom to marker sometimes not work)
  */
  void _check(CameraUpdate u, GoogleMapController c) async {
    c.moveCamera(u);
    _controller.moveCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      _check(u, c);
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  // when the Google Maps Camera is change, get the current position
  void _onGeoChanged(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  @override
  Widget build(BuildContext context) {

    objectStore = Provider.of<ObjectStore>(context);
    devicesList = objectStore.objects;

    StaticVarMethod.devicelist=devicesList;
    _runningVehicles = [];
    _idleVehicles = [];
    _stoppedVehicles = [];
    _inactiveVehicles = [];
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
    updateMarker();
    print("Map Builder");
    return Scaffold(
      backgroundColor: Colors.white,
      /*  appBar: AppBar(
         automaticallyImplyLeading: false,
         elevation: 0,
      */ /* iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),*/ /*
      //systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      centerTitle: false,
      title: Center( child:Text("Map Screen")*/ /*Image.asset('assets/appsicon/btplloginlogo.png', height: 40)*/ /*) ,
      backgroundColor: Colors.blue.shade900,
      //bottom: _reusableWidget.bottomAppBar(),
    ),*/ //_globalWidget.globalAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),
          // Positioned(
          //   top: 80,
          //   left: 16,
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         _showMarker = (_showMarker) ? false : true;
          //         for (int a = 0; a < _allMarker.length; a++) {
          //           if (_allMarker[MarkerId(a.toString())] != null) {
          //             _allMarker[MarkerId(a.toString())] =
          //                 _allMarker[MarkerId(a.toString())]!.copyWith(
          //               visibleParam: _showMarker,
          //             );
          //           }
          //         }
          //       });
          //     },
          //     child: Container(
          //       padding: EdgeInsets.all(5),
          //       width: 36,
          //       height: 36,
          //       decoration: new BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.rectangle,
          //         // borderRadius: BorderRadius.circular(8),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black26,
          //             blurRadius: 10.0,
          //             offset: const Offset(0.0, 10.0),
          //           ),
          //         ],
          //       ),
          //       // color: Colors.white,
          //       //color: Color(0x99FFFFFF),
          //       child: (_showMarker)
          //           ? Image.asset("assets/nepalicon/poi_default.png",
          //               height: 20, width: 20)
          //           : Image.asset("assets/nepalicon/poi_outline.png",
          //               height: 20,
          //               width:
          //                   20), /*Icon(
          //         (_showMarker)
          //             ? Icons.location_on
          //             : Icons.location_off,
          //         color: Colors.grey[700],
          //         size: 20,
          //       ),*/
          //     ),
          //   ),
          // ),
          Positioned(
            top: 120,
            right: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTitle = (_showTitle) ? false : true;
                  updateMarker();
                });
              },
              child: Container(
                padding: EdgeInsets.all(6),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  //borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: (_showTitle)
                    ? Image.asset("assets/nepalicon/car_with_name.png",
                        height: 25, width: 25)
                    : Image.asset("assets/nepalicon/car_without_name.png",
                        height: 25, width: 25),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 16,

            child: GestureDetector(
              onTap: () async {
                //  _recenterall();
              },
              child: Container(
                  padding: EdgeInsets.all(5),


                  decoration: new BoxDecoration(
                    color: Colors.transparent,

                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 1.0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          isshowvehiclecount = isshowvehiclecount == false ? true : false;
                          _filterdata("All");
                          setState(() {

                          });
                        },
                        child: Container(
                            height: 25,
                            width: 110,
                            alignment: Alignment.center,
                            //margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.only(left: 7,),
                                      decoration: BoxDecoration(
                                        color: ( Colors.grey.shade300),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child:ClipRRect(

                                          child: Image.asset(
                                            "assets/sensorsicon/dot.png",
                                            height: 10,
                                            width: 10,
                                          )
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('All',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 10,)),
                                  ],
                                ),
                                Text(devicesList.length.toString()+'   ' ,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,fontSize: 10,)),                              ],
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      (isshowvehiclecount)?Column(
                        children: [
                          GestureDetector(
                            onTap: (){

                              _filterdata("Running");
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                                height: 25,
                                width: 100,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                //margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom:
                                        BorderSide(color: Colors.grey.shade400, width: 0.8))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(

                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(left: 7,),
                                          decoration: BoxDecoration(
                                            color: ( Color(0xff24A651)),
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child:ClipRRect(
                                              child: Image.asset(
                                                "assets/sensorsicon/dot.png",
                                                height: 10,
                                                width: 10,
                                                color: Color(0xff24A651),
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Running',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 10,)),
                                        SizedBox(width: 20),
                                        Text(/*'17'+*/ _runningVehicles.length.toString()+'   ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 10,)),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: (){
                              _filterdata("Idle");
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                                height: 25,
                                width: 100,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                //margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom:
                                        BorderSide(color: Colors.grey.shade400, width: 0.8))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(

                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(left: 7,),
                                          decoration: BoxDecoration(
                                            color: ( Color(0xffF03B3B)),
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child:ClipRRect(
                                              child: Image.asset(
                                                "assets/sensorsicon/dot.png",
                                                height: 10,
                                                width: 10,
                                                color: Colors.yellow,

                                               // color: Color(0xffF03B3B),
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Idle',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 10,)),
                                      ],
                                    ),
                                    Text(/*'13   '*/_idleVehicles.length.toString()+'   ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 10,)),
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: (){
                              _filterdata("Stopped");
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                                height: 25,
                                width: 100,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                //margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom:
                                        BorderSide(color: Colors.grey.shade400, width: 0.8))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(

                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(left: 7,),
                                          decoration: BoxDecoration(
                                            color: ( Color(0xffF03B3B)),
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child:ClipRRect(
                                              child: Image.asset(
                                                "assets/sensorsicon/dot.png",
                                                height: 10,
                                                width: 10,
                                                color: Color(0xffF03B3B),
                                              //  color: Color(0xff04ACEB),
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Stop',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 10,)),
                                      ],
                                    ),
                                    Text(/*'30   '*/_stoppedVehicles.length.toString()+'   ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 10,)),
                                  ],
                                )),
                          ),
                          GestureDetector(
                            onTap: (){
                              _filterdata("Inactive");
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                                height: 25,
                                width: 100,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                //margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom:
                                        BorderSide(color: Colors.grey.shade400, width: 0.8))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(

                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(left: 7,),
                                          decoration: BoxDecoration(
                                            color: ( Color(0xff818181)),
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child:ClipRRect(
                                              child: Image.asset(
                                                "assets/sensorsicon/dot.png",
                                                height: 10,
                                                width: 10,
                                                color: Color(0xff818181),
                                              )
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Nodate',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,fontSize: 10,)),
                                      ],
                                    ),
                                    Text(/*'0   '*/_inactiveVehicles.length.toString()+'   ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,fontSize: 10,)),
                                  ],
                                )),
                          ),
                        ],
                      ):Container(),
                    ],
                  )
              ),
            ),
          ),
    /*      Positioned(
            top: 80,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _trafficEnabledPressed();
              },
              child: Container(
                padding: EdgeInsets.all(6),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  //borderRadius:BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight:Radius.circular(8)),
                  //borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),

                child: (_trafficEnabled)
                    ? Image.asset("assets/nepalicon/traffic-lights-active.png",
                        height: 25, width: 25)
                    : Image.asset("assets/nepalicon/traffic-lights.png",
                        height: 25, width: 25),

              ),
            ),
          ),
          Positioned(
            top: 120,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _onMapTypeButtonPressed();
              },
              child: Container(
                  padding: EdgeInsets.all(6),
                  width: 36,
                  height: 36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),

                  child: Image.asset("assets/nepalicon/roadmap.png",
                      height: 25,
                      width:
                          25)
                  ),
            ),
          ),
          Positioned(
            top: 160,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                getLocation();
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  width: 36,
                  height: 36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                    // borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  //color: Color(0x99FFFFFF),
                  child: Image.asset("assets/nepalicon/my_location.png",
                      height: 25, width: 25)),
            ),
          ),
          Positioned(
            bottom: 160,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                var currentZoomLevel = await _controller.getZoomLevel();

                currentZoomLevel = currentZoomLevel + 2;
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: currentZoomLevel,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(6),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  // borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(
                  Icons.zoom_in,
                  color: Colors.grey[700],
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                var currentZoomLevel = await _controller.getZoomLevel();
                currentZoomLevel = currentZoomLevel - 2;
                if (currentZoomLevel < 0) currentZoomLevel = 0;
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: currentZoomLevel,
                    ),
                  ),
                );

              },
              child: Container(
                  padding: EdgeInsets.all(6),
                  width: 36,
                  height: 36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    // borderRadius:BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight:Radius.circular(8)),
                    //borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  //color: Color(0x99FFFFFF),
                  child: Image.asset("assets/nepalicon/zoom_out.png",
                      height: 25, width: 25)

                  ),
            ),
          ),



          Positioned(
            bottom: 160,
            left: 16,
            child: GestureDetector(
              onTap: () async {

              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  width: 36,
                  height: 36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    //borderRadius:BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight:Radius.circular(8)),
                    //borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  //color: Color(0x99FFFFFF),
                  child: Center(child: Text("$_start" + "s"))),
            ),
          ),
          Positioned(
            bottom: 120,
            left: 16,
            child: GestureDetector(
              onTap: () async {
                _recenterall();

              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  width: 36,
                  height: 36,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    //borderRadius:BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight:Radius.circular(8)),
                    //borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  //color: Color(0x99FFFFFF),
                  child: Image.asset("assets/nepalicon/refresh.png",
                      height: 25, width: 25)),
            ),
          ),*/
          (isshowvehicledetail) ? _buildItem() : Container(),
          /*Positioned(
            top: 60,
            left: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {

                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                color: Color(0x99FFFFFF),
                child: Icon(
                  (_showMarker)
                      ? Icons.location_on
                      : Icons.location_off,
                  color: Colors.grey[700],
                  size: 26,
                ),
              ),
            ),
          ),*/
          (_mapLoading)
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),

    );
  }

  void _filterdata(String val) async {
    _allMarker.clear();
    StaticVarMethod.devicelist=[];
    if(val.contains("All")){
      StaticVarMethod.devicelist=devicesList;
    }else if(devicesList.isNotEmpty){
      for (int i = 0; i < devicesList.length; i++) {
        deviceItems model = devicesList.elementAt(i);

        if (val.contains("Inactive") && model.online.toString().toLowerCase().contains("offline") &&
            model.time.toString().toLowerCase().contains("not connected")) {
          StaticVarMethod.devicelist.add(devicesList.elementAt(i));
        } else if (val.contains("Running") && model.online.toString().toLowerCase().contains("online")) {
          StaticVarMethod.devicelist.add(devicesList.elementAt(i));
        } else if (val.contains("Idle") && model.online.toString().toLowerCase().contains("ack") &&
            double.parse(model.speed.toString()) < 1.0) {
          StaticVarMethod.devicelist.add(devicesList.elementAt(i));
        } else if (val.contains("Stopped") && model.online
            .toString()
            .toLowerCase()
            .contains("offline") &&
            model.time.toString().toLowerCase() != "not connected") {
          StaticVarMethod.devicelist.add(devicesList.elementAt(i));
        }
      }
    }

    if (mounted) {
      setState(() {
        updateMarker();
      });
    }

  }

  Widget _buildItem() {
    double imageSize = MediaQuery.of(context).size.width / 25;
    var devicelist = StaticVarMethod.devicelist
        .where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei))
        .single;

    double lat = devicelist.lat!.toDouble();
    double lng = devicelist.lng!.toDouble();
    double course = devicelist.course!.toDouble();
    int speed = devicelist.speed!.toInt();
    String imei = devicelist.deviceData!.imei.toString();
    String carstatus = devicelist.online!.toString();

   // String address=getAddress(lat,lng);
    Color statuscolor = Colors.red;
    if (speed > 0) {
      statuscolor = Colors.green;
    } else {
      statuscolor = Colors.red;
    }
    return Positioned(
        top: 40,
        right: 0,
        left: 0,
        child: Align(
            alignment: Alignment.bottomCenter,
            //left: 16,
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 0, 3, 0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  color: Colors.white,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        prefixIcon(devicelist.speed, devicelist.stopDuration, statuscolor),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            padding: EdgeInsets.fromLTRB(10, 2, 10, 0),
                            margin: EdgeInsets.only(left: 5),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: 'Click ${devicelist.name}',
                                        toastLength: Toast.LENGTH_SHORT);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Row(children:[Text("Some Data"), Spacer(), Text("Some Data")]),

                                            Container(
                                             margin:
                                            EdgeInsets.only(top: 12),
                                              child:
                                              //Center(
                                                 Text(
                                                '' + devicelist.name.toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                    Colors.blue.shade900),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                           //   )
                                        ),

                                            Row(children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.all(5),

                                                decoration: BoxDecoration(
                                                  color: statuscolor,
                                                  borderRadius:
                                                  BorderRadius.all(Radius.circular(10.0)),
                                                ),
                                               // color: statuscolor,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        (speed > 0)
                                                            ? 'Moving since: ' +
                                                            devicelist
                                                                .stopDuration!
                                                            : 'Stopped since: ' +
                                                            devicelist
                                                                .stopDuration!,
                                                        style: TextStyle(
                                                            fontSize: 14,

                                                            color: Colors.white))
                                                  ],
                                                ),
                                              ),

                                            ]),

                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 8,top: 12,bottom: 15),

                                                      child: Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              address = "Loading....";
                                                              setState(() {});
                                                              getAddress(lat,lng);
                                                            },
                                                            child:
                                                            RichText(
                                                              maxLines: 5,
                                                              textAlign: TextAlign.left,
                                                              overflow: TextOverflow.ellipsis,
                                                              text: TextSpan(
                                                                  text:address,
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.grey.shade700,
                                                                    //fontWeight: FontWeight.bold
                                                                  ),
                                                                  children: [
                                                                    /* TextSpan(
                text:eventList[index].message.toString() == "null" ? "" : eventList[index].message.toString(),
                style: TextStyle(

                    fontWeight: FontWeight.w400),
              )*/
                                                                  ]
                                                              ),
                                                            ),/*Text(address,
                                                  style: TextStyle(
                                                      fontSize: 12, color: Colors.blue),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis)*/
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                              /*Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  'Loc: ' +address,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    //color: _color2
                                                  ),
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),*/
                                            ]),

                                            /*Row(children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        (speed > 0)
                                                            ? 'Moving since: ' +
                                                                devicelist
                                                                    .stopDuration!
                                                            : 'Stopped since: ' +
                                                                devicelist
                                                                    .stopDuration!,
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color: statuscolor))
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                    devicelist.time.toString(),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: SOFT_GREY)),
                                              )
                                            ]),*/
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        postfixIcon(devicelist.name, devicelist.id,lat, lng, imei ),
                      ])),
            )));
  }


  Widget postfixIcon(name,id,lat, lng, imei) {
    return Container(
      //width: 40,
        margin: EdgeInsets.only(top: 40, right: 10),

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  StaticVarMethod.deviceName=name.toString();
                  StaticVarMethod.deviceId=id.toString();
                  StaticVarMethod.lat=lat;
                  StaticVarMethod.lng=lng;
                  StaticVarMethod.imei=imei.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => livetrack()),
                  );
                },
                child:   Image.asset("assets/nepalicon/live_tracking.png", height: 30,width: 30),
              ),
          /*    Text("Live",
                  style: TextStyle(
                      fontSize: 12,
                      //fontWeight: FontWeight.bold,
                      color: statuscolor)),*/
            ])

      /* child: Icon(Icons.notifications,
          size: 25,
          color:Colors.grey.shade700),*/
    );
  }
  Widget prefixIcon(speed, stopDuration, statuscolor) {
    return Container(
        //width: 40,
        margin: EdgeInsets.only(top: 30, left: 10),

            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("" + speed.toString(),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: statuscolor)),
                  Text("KM/H",
                      style: TextStyle(
                          fontSize: 12,
                          //fontWeight: FontWeight.bold,
                          color: statuscolor)),
            ])

        /* child: Icon(Icons.notifications,
          size: 25,
          color:Colors.grey.shade700),*/
        );
  }

  late Timer _timer;
  int _start = 10;

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           _start = 10;
  //           // timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _trafficEnabledPressed() {
    setState(() {
      _trafficEnabled = _trafficEnabled == false ? true : false;
      _trafficButtonColor =
          _trafficEnabled == false ? Colors.grey[700] : Colors.blue;
    });
  }

  void _recenterall() {
    CameraUpdate u2 =
        CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
    this._controller.moveCamera(u2).then((void v) {
      _check(u2, this._controller);
    });
  }

  void getLocation() async {
    final Uint8List markIcons =
        await getImages("assets/nepalicon/globe.png", 100);
    var location = await currentLocation.getLocation();

    _controller
        ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
      zoom: 12.0,
    )));
     setState(() {
      _markers.add(Marker(markerId: MarkerId('Home'),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0)
      ));
    });
    /*  currentLocation.onLocationChanged.listen((LocationData loc){

      _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      setState(() {
        _markers.add(Marker(markerId: MarkerId('Home'),
            icon: BitmapDescriptor.fromBytes(markIcons),
            position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
        ));
      });
    });*/
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: _currentMapType,
      trafficEnabled: _trafficEnabled,
      compassEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      markers: Set<Marker>.of(_allMarker.values),
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: _currentZoom,
      ),
      onCameraMove: _onGeoChanged,
      onCameraIdle: () {
        if (_isBound == false && _doneListing == true) {
          _isBound = true;
          CameraUpdate u2 =
              CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
          this._controller.moveCamera(u2).then((void v) {
            _check(u2, this._controller);
          });
        }
      },
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;

        // we use timer for this demo
        // in the real application, get all marker from database
        // Get the marker from API and add the marker here
        _timerDummy = Timer(Duration(seconds: 0), () {
          setState(() {
            _mapLoading = false;

            // add all marker here
            /*   for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {

                if(StaticVarMethod.devicelist[i].lat != 0) {

                    var color;
                    if(StaticVarMethod.devicelist[i].online!.contains('online')){
                      color=Colors.green;
                    }else if(StaticVarMethod.devicelist[i].speed! > 0){
                      color=Colors.green;
                    }else{
                      color=Colors.red;
                    }
                    double lat = StaticVarMethod.devicelist[i].lat as double;
                    double lng = StaticVarMethod.devicelist[i].lng as double;
                    //double angle =  StaticVarMethod.devicelist[i].course as double;
                    LatLng position = LatLng(lat, lng);
                    _latlng.add(position);
                    _createImageLabel(label: StaticVarMethod.devicelist[i].name.toString(), imageIcon: _iconFacebook,course :StaticVarMethod.devicelist[i].course.toDouble(),color: color).then((BitmapDescriptor customIcon) {
                        setState(() {
                        _mapLoading = false;
                      _allMarker[MarkerId(i.toString())] = Marker(
                      markerId: MarkerId(i.toString()),
                      position: position,
                      //rotation: 0.0,
                      infoWindow: InfoWindow(
                          title: 'This is marker ' + (i + 1).toString()),
                      onTap: () {
                        Fluttertoast.showToast(
                            msg: 'Click marker ' + (i + 1).toString(),
                            toastLength: Toast.LENGTH_SHORT);
                      },
                      icon:  customIcon
                    );
                    });
                    });
                    if (i == StaticVarMethod.devicelist.length - 1) {
                      _doneListing = true;
                    }

                }


            }*/
            updateMarker();
            // zoom to all marker
            if (_isBound == false /*&& _doneListing==true*/) {
              _isBound = true;
              CameraUpdate u2 = CameraUpdate.newLatLngBounds(
                  _boundsFromLatLngList(_latlng), 100);
              this._controller.moveCamera(u2).then((void v) {
                _check(u2, this._controller);
              });
            }
            _mapLoading = false;
          });
        });
      },
      onTap: (pos) {
        print('currentZoom : ' + _currentZoom.toString());
      },
    );
  }

  updateMarker() {
    /* Fluttertoast.showToast(
        msg: 'Click marker ' + ( 1).toString(),
        toastLength: Toast.LENGTH_SHORT);*/

    _initialPosition = LatLng(devicesList[0].lat!.toDouble(),
        devicesList[0].lng!.toDouble());
    //_allMarker.clear();
    for (int i = 0; i < devicesList.length; i++) {
      if (devicesList[i].lat != 0) {
        var color;
        var label;

        String iconpath = 'assets/tbtrack/truck_toprunning.png';
        if (devicesList[i].speed!.toInt() > 0) {
          iconpath = 'assets/tbtrack/truck_toprunning.png';
          color = Colors.green;
          label = devicesList[i].name.toString() +
              '(' +
              devicesList[i].speed!.toString() +
              ' km)';
          if(StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString())!=null)
            iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString()).toString()+"toprunning.png";

        } else if (devicesList[i].online!.contains('online')) {
          iconpath = 'assets/tbtrack/truck_toprunning.png';
          color = Colors.green;
          label = devicesList[i].name.toString();
          if(StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString())!=null)
            iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString()).toString()+"toprunning.png";

        } else {
          iconpath = 'assets/tbtrack/truck_topstop.png';

          color = Colors.red;
          label = devicesList[i].name.toString();

          if(StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString())!=null)
            iconpath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(devicesList[i].deviceData!.imei.toString()).toString()+"topstop.png";

        }
        double lat = devicesList[i].lat as double;
        double lng = devicesList[i].lng as double;
        // String iconpath = devicesList[i].icon!.path.toString();
        //double angle =  devicesList[i].course as double;
        LatLng position = LatLng(lat, lng);
        _latlng.add(position);
        _createImageLabel(
                iconpath: iconpath,
                label: label,
                course: devicesList[i].course.toDouble(),
                color: color,
                showtitle: _showTitle)
            .then((BitmapDescriptor customIcon) {

              _mapLoading = false;
              _allMarker[MarkerId(i.toString())] = Marker(
                  markerId: MarkerId(i.toString()),
                  position: position,
                  //rotation: 0.0,
                  // infoWindow: InfoWindow(
                  //    title: 'This is marker ' + (i + 1).toString()),
                  onTap: () {
                    _initialPosition =
                        LatLng(position.latitude, position.longitude);
                    StaticVarMethod.imei = StaticVarMethod
                        .devicelist[i].deviceData!.imei
                        .toString();
                    setState(() {
                      isshowvehicledetail = true;
                    });
              /*      Fluttertoast.showToast(
                        msg: 'Click marker ' + (i + 1).toString(),
                        toastLength: Toast.LENGTH_SHORT);*/
                  },
                  anchor: Offset(0.5, 0.5),
                  icon: customIcon);


        });
        // setState(() {
        //
        // });
        if (i == devicesList.length - 1) {
          _doneListing = true;
        }
      }
    }
  }


  String address = "Clik here for address!";
  String getAddress(lat, lng) {

    if (lat != null) {
      gpsapis.getGeocoder(lat, lng).then((value) => {
        if (value != null)
          {
            address = value.body,
            setState(() {}),
          }
        else
          {address = "Address not found"}
      });
    } else {
      address = "Address not found";
    }
    print(address);
    return address;
  }
}

Future<BitmapDescriptor> getMarkerIcon(String imagePath, String infoText,
    Color color, double rotateDegree, bool _showTitle) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  //size
  Size canvasSize = Size(700.0, 220.0);
  Size markerSize = Size(120.0, 120.0);
  late TextPainter textPainter;
  if (_showTitle) {
    // Add info text
    textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: infoText,
      style:
          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: color),
    );
    textPainter.layout();
  }

  final Paint infoPaint = Paint()..color = Colors.white;
  final Paint infoStrokePaint = Paint()..color = color;
  final double infoHeight = 70.0;
  final double strokeWidth = 2.0;

  //final Paint markerPaint = Paint()..color = color.withOpacity(0);
  final double shadowWidth = 30.0;

  final Paint borderPaint = Paint()
    ..color = color
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  final double imageOffset = shadowWidth * .5;

  canvas.translate(
      canvasSize.width / 2, canvasSize.height / 2 + infoHeight / 2);

  // Add shadow circle
  // canvas.drawOval(
  //     Rect.fromLTWH(-markerSize.width / 2, -markerSize.height / 2,
  //         markerSize.width, markerSize.height),
  //     markerPaint);
  // // Add border circle
  // canvas.drawOval(
  //     Rect.fromLTWH(
  //         -markerSize.width / 2 + shadowWidth,
  //         -markerSize.height / 2 + shadowWidth,
  //         markerSize.width - 2 * shadowWidth,
  //         markerSize.height - 2 * shadowWidth),
  //     borderPaint);

  // Oval for the image
  Rect oval = Rect.fromLTWH(
      -markerSize.width / 2 + .5 * shadowWidth,
      -markerSize.height / 2 + .5 * shadowWidth,
      markerSize.width - shadowWidth,
      markerSize.height - shadowWidth);

  //save canvas before rotate
  canvas.save();

  double rotateRadian = (pi / 180.0) * rotateDegree;

  //Rotate Image
  canvas.rotate(rotateRadian);

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  ui.Image image;
  // Add image
  // if(imagePath.contains("arrow-ack.png")){
  image = await getImageFromPath(imagePath);
  // image = await getImageFromPath("assets/images/direction.png");
  /* }else{
    image = await getImageFromPathUrl(imagePath);

  }*/

  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitHeight);

  canvas.restore();
  if (_showTitle) {
    // Add info box stroke
    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromLTRBR(
              -textPainter.width / 2 - infoHeight / 2,
              -canvasSize.height / 2 - infoHeight / 2 + 1,
              textPainter.width / 2 + infoHeight / 2,
              -canvasSize.height / 2 + infoHeight / 2 + 1,
              Radius.circular(35.0)))
          ..moveTo(-15, -canvasSize.height / 2 + infoHeight / 2 + 1)
          ..lineTo(0, -canvasSize.height / 2 + infoHeight / 2 + 25)
          ..lineTo(15, -canvasSize.height / 2 + infoHeight / 2 + 1),
        infoStrokePaint);

    //info info box
    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromLTRBR(
              -textPainter.width / 2 - infoHeight / 2 + strokeWidth,
              -canvasSize.height / 2 - infoHeight / 2 + 1 + strokeWidth,
              textPainter.width / 2 + infoHeight / 2 - strokeWidth,
              -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth,
              Radius.circular(32.0)))
          ..moveTo(-15 + strokeWidth / 2,
              -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth)
          ..lineTo(
              0, -canvasSize.height / 2 + infoHeight / 2 + 25 - strokeWidth * 2)
          ..lineTo(15 - strokeWidth / 2,
              -canvasSize.height / 2 + infoHeight / 2 + 1 - strokeWidth),
        infoPaint);
    textPainter.paint(
        canvas,
        Offset(
            -textPainter.width / 2,
            -canvasSize.height / 2 -
                infoHeight / 2 +
                infoHeight / 2 -
                textPainter.height / 2));

    canvas.restore();
  }

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(canvasSize.width.toInt(), canvasSize.height.toInt());

  // Convert image to bytes
  final ByteData? byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List? uint8List = byteData?.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List!);
}

/*
Future<BitmapDescriptor> getMarkerIconwithTitle(String imagePath,String infoText,Color color,double rotateDegree) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  //size
  Size canvasSize = Size(700.0,220.0);
  Size markerSize = Size(80.0,80.0);

  // Add info text
  TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
  textPainter.text = TextSpan(
    text: infoText,
    style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600, color: color),
  );
  textPainter.layout();

  final Paint infoPaint = Paint()..color = Colors.white;
  final Paint infoStrokePaint = Paint()..color = color;
  final double infoHeight = 70.0;
  final double strokeWidth = 2.0;

  final Paint markerPaint = Paint()..color = color.withOpacity(.5);
  final double shadowWidth = 30.0;

  final Paint borderPaint = Paint()..color = color..strokeWidth=2.0..style = PaintingStyle.stroke;

  final double imageOffset = shadowWidth*.5;

  canvas.translate(canvasSize.width/2, canvasSize.height/2+infoHeight/2);

  // Add shadow circle
  canvas.drawOval(Rect.fromLTWH(-markerSize.width/2, -markerSize.height/2, markerSize.width, markerSize.height), markerPaint);
  // Add border circle
  canvas.drawOval(Rect.fromLTWH(-markerSize.width/2+shadowWidth, -markerSize.height/2+shadowWidth, markerSize.width-2*shadowWidth, markerSize.height-2*shadowWidth), borderPaint);

  // Oval for the image
  Rect oval = Rect.fromLTWH(-markerSize.width/2+.5* shadowWidth, -markerSize.height/2+.5*shadowWidth, markerSize.width-shadowWidth, markerSize.height-shadowWidth);

  //save canvas before rotate
  canvas.save();

  double rotateRadian = (pi/180.0)*rotateDegree;

  //Rotate Image
  canvas.rotate(rotateRadian);

  // Add path for oval image
  canvas.clipPath(Path()
    ..addOval(oval));

  // Add image
  ui.Image image = await getImageFromPath(imagePath);
  paintImage(canvas: canvas,image: image, rect: oval, fit: BoxFit.fitHeight);

  canvas.restore();

  // Add info box stroke
  canvas.drawPath(Path()..addRRect(RRect.fromLTRBR(-textPainter.width/2-infoHeight/2, -canvasSize.height/2-infoHeight/2+1, textPainter.width/2+infoHeight/2, -canvasSize.height/2+infoHeight/2+1,Radius.circular(35.0)))
    ..moveTo(-15, -canvasSize.height/2+infoHeight/2+1)
    ..lineTo(0, -canvasSize.height/2+infoHeight/2+25)
    ..lineTo(15, -canvasSize.height/2+infoHeight/2+1)
      , infoStrokePaint);

  //info info box
  canvas.drawPath(Path()..addRRect(RRect.fromLTRBR(-textPainter.width/2-infoHeight/2+strokeWidth, -canvasSize.height/2-infoHeight/2+1+strokeWidth, textPainter.width/2+infoHeight/2-strokeWidth, -canvasSize.height/2+infoHeight/2+1-strokeWidth,Radius.circular(32.0)))
    ..moveTo(-15+strokeWidth/2, -canvasSize.height/2+infoHeight/2+1-strokeWidth)
    ..lineTo(0, -canvasSize.height/2+infoHeight/2+25-strokeWidth*2)
    ..lineTo(15-strokeWidth/2, -canvasSize.height/2+infoHeight/2+1-strokeWidth)
      , infoPaint);
  textPainter.paint(
      canvas,
      Offset(
          - textPainter.width / 2,
          -canvasSize.height/2-infoHeight/2+infoHeight / 2 - textPainter.height / 2
      )
  );

  canvas.restore();

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt()
  );

  // Convert image to bytes
  final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List? uint8List = byteData?.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List!);
}
*/

Future<ui.Image> getImageFromPath(String imagePath) async {
  //File imageFile = File(imagePath);
  var bd = await rootBundle.load(imagePath);
  Uint8List imageBytes = Uint8List.view(bd.buffer);

  final Completer<ui.Image> completer = new Completer();

  ui.decodeImageFromList(imageBytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<ui.Image> getImageFromPathUrl(String imagePath) async {
  //File imageFile = File(imagePath);
  final response = await http.Client().get(Uri.parse(imagePath));
  final bytes = response.bodyBytes;
//  var bd = await rootBundle.load(imagePath);
  //Uint8List imageBytes = Uint8List.view(bd.buffer);

  final Completer<ui.Image> completer = new Completer();

  ui.decodeImageFromList(bytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}
