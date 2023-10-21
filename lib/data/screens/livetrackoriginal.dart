import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:location/location.dart';

import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/mapconfig/CommonMethod.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;
import 'package:http/http.dart' as http;
import 'package:flutter_animarker/flutter_map_marker_animation.dart';

import '../../utils/MapUtils.dart';
import 'browser_module_old/browser.dart';
class livetrackoriginal extends StatefulWidget {
  @override
  _livetrack createState() => _livetrack();
}

class _livetrack extends State<livetrackoriginal>{
  // initialize global widget
  final _globalWidget = GlobalWidget();

  GoogleMapController? _controller;
  bool _mapLoading = true;
  bool _statusbarLoading = true;

  Timer? _timerDummy;

  bool _showMarker = true;

  double _currentZoom = 15;

  LatLng _initialPosition = LatLng(StaticVarMethod.lat,StaticVarMethod.lng);

  /* List<LatLng> _markerList = [];*/

  Map<MarkerId, Marker> _allMarker = {};
  List<LatLng> _latlng = [];
  bool _isBound = false;
  bool _doneListing = false;
  late ui.Image _iconFacebook;
  double _iconFacebookSize=40;
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  var _trafficButtonColor = Colors.grey[700];
  Location currentLocation = Location();


  ////////////////////////////////////////////

  var kStartPosition;
  var kSantoDomingo;
  var kMarkerId = MarkerId('MarkerId1');
  var kDuration = Duration(seconds: 1);
  var kLocations = [];
  var markers = <MarkerId, Marker>{};
  var controller = Completer<GoogleMapController>();
  var stream;


  @override
  void initState() {
/*    _markerList.add(LatLng(-6.168033, 106.900467));
    _markerList.add(LatLng(-6.164770, 106.900630));
    _markerList.add(LatLng(-6.158637, 106.906376));*/
    //_initImage();
    super.initState();
    startLocation();
    _timerDummy = Timer.periodic(Duration(seconds: 20), (Timer t) => _getData());
  }
  Future<void> _getData() async{
    gpsapis api=new gpsapis();
    var hash=StaticVarMethod.user_api_hash;
    StaticVarMethod.devicelist =await gpsapis.getDevicesList(hash);
    //updateMarker();

    /*   setState(() {

      });*/
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
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

  Future<BitmapDescriptor> _createImageLabel({String iconpath="assets/images/direction.png",String label='label', double fontSize=20,double course=0, Color color=Colors.red}) async {
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
    iconpath=StaticVarMethod.baseurlall+"/"+iconpath;
    return getMarkerIcon(iconpath,label,color,course);
  }

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
    return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  // when the Google Maps Camera is change, get the current position
  void _onGeoChanged(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(''+StaticVarMethod.deviceName,
            style: TextStyle(color: Colors.black,fontSize: 15)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          // action button

        ],
        backgroundColor: Colors.white,
      ),//_globalWidget.globalAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),


          Positioned(
            top: 60,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _onMapTypeButtonPressed();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child:   Icon(Icons.map_rounded,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _trafficEnabledPressed();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(Icons.traffic_outlined,
                  color: _trafficButtonColor,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(

            top: 140,
            right: 16,
            child: GestureDetector(
              onTap: () async {

                var location = await currentLocation.getLocation();
                String url ="https://www.google.com/maps/dir/?api=1&destination="
                    + (StaticVarMethod.lat.toString() + ","
                        + StaticVarMethod.lng.toString()) + "&travelmode=walking";
                // String url ="https://www.google.com/maps/dir/?api=1&destination="
                //     + ("31.5121208" + ","
                //         + "74.3189183") + "&travelmode=walking";
                // https://www.google.com/maps/dir/31.5121208,74.3189183/31.5082421,74.315528/@31.5101906,74.3150513,17z/data=!3m1!4b1!4m2!4m1!3e2
                // final url="https://www.google.com/maps/dir/"+ StaticVarMethod.lat.toString() + ","+ StaticVarMethod.lng.toString() + "/"+location.latitude.toString()+","+location.longitude.toString()+"/@"+location.latitude.toString()+","+location.longitude.toString()+",15z/data=!4m2!4m1!3e0";
                //  final url ='https://www.google.streetview:cbll=${StaticVarMethod.lat},${StaticVarMethod.lng}';
                /*    if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }*/

                MapUtils.openMap(url);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Browser(
                //           dashboardName: "Distance",
                //           dashboardURL: url,
                //         )));

              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(Icons.social_distance_rounded,
                  color: Colors.grey[700],
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(

            top: 180,
            right: 16,
            child: GestureDetector(
              onTap: () async {

                final url ='https://www.google.com/maps/search/?api=1&query=${StaticVarMethod.lat},${StaticVarMethod.lng}';
                /*   if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }*/
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Browser(
                          dashboardName: "Location",
                          dashboardURL: url,
                        )));

              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(FontAwesomeIcons.locationArrow,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ),

          Positioned(

            top: 220,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                final url ='https://maps.google.com/maps?q=&layer=c&cbll=${StaticVarMethod.lat},${StaticVarMethod.lng}&cbp=11,0,0,0,0,';
                /*      if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }*/

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Browser(
                          dashboardName: "Street View",
                          dashboardURL: url,
                        )));

              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(FontAwesomeIcons.streetView,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ),

/*          Positioned(
            bottom: 340,
            left: 16,
            child: GestureDetector(
              onTap: () {
                _onMapTypeButtonPressed();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  // borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child:   Icon(Icons.map,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            left: 16,
            child: GestureDetector(
              onTap: () {
                _trafficEnabledPressed();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius:BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight:Radius.circular(8)),
                  //borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      //blurRadius: 10.0,
                      // offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(Icons.traffic_outlined,
                  color: _trafficButtonColor,
                  size: 25,
                ),
              ),
            ),
          ),*/

          Positioned(
            top: 260,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                var currentZoomLevel = await _controller!.getZoomLevel();

                currentZoomLevel = currentZoomLevel + 2;
                _controller!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: currentZoomLevel,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child:   Icon(Icons.zoom_in,
                  color: Colors.grey[700],
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(

            top: 300,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                var currentZoomLevel = await _controller!.getZoomLevel();
                currentZoomLevel = currentZoomLevel - 2;
                if (currentZoomLevel < 0) currentZoomLevel = 0;
                _controller!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: currentZoomLevel,
                    ),
                  ),
                );
                /*setState(() {
                  _showMarker = (_showMarker) ? false : true;
                  for (int a = 0; a < _allMarker.length; a++) {
                    if(_allMarker[MarkerId(a.toString())]!=null){
                      _allMarker[MarkerId(a.toString())] =
                          _allMarker[MarkerId(a.toString())]!.copyWith(
                            visibleParam: _showMarker,
                          );
                    }
                  }
                });*/
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(Icons.zoom_out,
                  color: Colors.grey[700],
                  size: 30,
                ),
              ),
            ),
          ),

          Positioned(
            top: 340,
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
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child:   Icon(Icons.my_location,
                  color: Colors.black26,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(

            top: 380,
            right: 16,
            child: GestureDetector(
              onTap: () async {

                _recenterall();
                /*setState(() {
                  _showMarker = (_showMarker) ? false : true;
                  for (int a = 0; a < _allMarker.length; a++) {
                    if(_allMarker[MarkerId(a.toString())]!=null){
                      _allMarker[MarkerId(a.toString())] =
                          _allMarker[MarkerId(a.toString())]!.copyWith(
                            visibleParam: _showMarker,
                          );
                    }
                  }
                });*/
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  // borderRadius:BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8)),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      // blurRadius: 10.0,
                      //offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                // color: Colors.white,
                //color: Color(0x99FFFFFF),
                child: Icon(Icons.refresh,
                  color: Colors.black26,
                  size: 25,
                ),
              ),
            ),
          ),
          (_mapLoading)?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):SizedBox.shrink(),

          (_statusbarLoading)?_showStatusPopup():Container()
        ],
      ),
      /* floatingActionButton: FabCircularMenu(
            fabColor: Colors.white,
            ringColor: Colors.black54,
            ringWidth: 100,
            fabSize: 40,
            animationCurve: Cubic(6.785, 6.135, 6.15, 8.86),

            children: <Widget>[
              IconButton(icon: Icon(Icons.home, color: Colors.white), onPressed: () {
                Fluttertoast.showToast(msg: 'Home Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
              IconButton(icon: Icon(Icons.add, color: Colors.black), onPressed: () {
                Fluttertoast.showToast(msg: 'Add Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
              IconButton(icon: Icon(Icons.edit, color: Colors.black), onPressed: () {
                Fluttertoast.showToast(msg: 'Edit Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
              IconButton(icon: Icon(Icons.notifications, color: Colors.black), onPressed: () {
                Fluttertoast.showToast(msg: 'Notification Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
              IconButton(icon: Icon(Icons.camera, color: Colors.black), onPressed: () {
                Fluttertoast.showToast(msg: 'Camera Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
              IconButton(icon: Icon(Icons.photo, color: Colors.black), onPressed: () {
                Fluttertoast.showToast(msg: 'Photo Pressed', toastLength: Toast.LENGTH_SHORT);
              }),
            ]
        )*/
    );
  }

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
  void _recenterall(){
    CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
    this._controller!.moveCamera(u2).then((void v){
      _check(u2,this._controller!);
    });
  }

  void getLocation() async{
    var location = await currentLocation.getLocation();

    _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(location.latitude ?? 0.0,location.longitude?? 0.0),
      zoom: 12.0,
    )));

  }


  // build google maps to used inside widget
  Widget _buildGoogleMap() {
    return Animarker(
      //curve: Curves.bounceOut,
      //rippleRadius: 0.2,
      useRotation: false,
      shouldAnimateCamera: true,
      duration: Duration(milliseconds: 5000),
      mapId: controller.future
          .then<int>((value) => value.mapId), //Grab Google Map Id
      markers: markers.values.toSet(),
      child: GoogleMap(
          mapType: _currentMapType,
          trafficEnabled: _trafficEnabled,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: _currentZoom,
          ),
          onMapCreated: (gController) {


            //updateMarker();
             //newLocationUpdate();
            _controller = gController;
            stream.forEach((value) => newLocationUpdate());
            controller.complete(gController);
            //Complete the future GoogleMapController
          }),
    );
  }

  void startLocation() {

    var devicelist= StaticVarMethod.devicelist.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;

    lati = devicelist.lat!.toDouble();
    lngi = devicelist.lng!.toDouble();

    LatLng position = LatLng(lati, lngi);
    kStartPosition= LatLng(lati, lngi);
    kSantoDomingo = CameraPosition(target: kStartPosition, zoom: 15);
    kLocations.add(LatLng(lati, lngi));

    stream = Stream.periodic(kDuration, (count) => kLocations[count]).take(100);

  }
  void newLocationUpdate() {

/*    Fluttertoast.showToast(
        msg: 'Click marker ' + ( 1).toString(),
        toastLength: Toast.LENGTH_SHORT);*/
    //_allMarker.clear();
    var devicelist= StaticVarMethod.devicelist.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;

    //  for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {


    // if(devicelist.deviceData!.imei!.contains(StaticVarMethod.imei)) {

    var color;
    var label;

    if(devicelist.speed!.toInt() > 0){
      color=Colors.green;
      label= devicelist.name.toString() + '('+devicelist.speed!.toString()+' km)';
    }
    else  if(devicelist.online!.contains('online')){
      color=Colors.green;
      label= devicelist.name.toString();

    }else{
      color=Colors.red;
      label= devicelist.name.toString();
    }
    lati = devicelist.lat!.toDouble();
    lngi = devicelist.lng!.toDouble();
    String iconpath = devicelist.icon!.path.toString();

    //double angle =  devicelist.course as double;
    LatLng position = LatLng(lati, lngi);
    kLocations.add(LatLng(lati, lngi));
    _latlng.add(position);
    //_animatedMapMove(position,15);
    _createImageLabel(iconpath: iconpath,label: label,course :devicelist.course.toDouble(),color: color).then((BitmapDescriptor customIcon) {

      _mapLoading = false;
    fUpdateTime=devicelist.time.toString();
    fspeed=devicelist.speed.toString();
    ftotalDistance=devicelist.totalDistance.toString();
    fstopDuration=devicelist.stopDuration.toString();
    //if(kLocations.length>1){
    var marker = RippleMarker(
        markerId: kMarkerId,
        position: position,
        ripple: false,
        icon: customIcon,
        anchor: Offset(0.55, 0.55),
        onTap: () {
          print('Tapped! $position');
        });
        if(mounted){
          setState(() => markers[kMarkerId] = marker);
        }
   // }
  });
  }

  // build google maps to used inside widget
  Widget _buildGoogleMap2() {
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
      padding:  EdgeInsets.only(bottom: 200),
      markers: Set<Marker>.of(_allMarker.values),
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: _currentZoom,
      ),
      onCameraMove: _onGeoChanged,
      onCameraIdle: (){
        if(_isBound==false && _doneListing==true) {
          _isBound = true;
          CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
          this._controller!.moveCamera(u2).then((void v){
            _check(u2,this._controller!);
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
            if(_isBound==false && _doneListing==true) {
              _isBound = true;
              CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 100);
              this._controller!.moveCamera(u2).then((void v){
                _check(u2,this._controller!);
              });
            }
            _mapLoading = false;
          });

        });
      },
      onTap: (pos){
        print('currentZoom : '+_currentZoom.toString());
      },
    );
  }
  late double lati;
  late double lngi;
  String fUpdateTime = 'Not Found';
  String fspeed ='Not Found';
  String ftotalDistance ='Not Found';
  String fstopDuration ='Not Found';

  updateMarker(){

   /* Fluttertoast.showToast(
        msg: 'Click marker ' + ( 1).toString(),
        toastLength: Toast.LENGTH_SHORT);*/
    //_allMarker.clear();
    var devicelist= StaticVarMethod.devicelist.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;

    //  for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {


    // if(devicelist.deviceData!.imei!.contains(StaticVarMethod.imei)) {

    var color;
    var label;

    if(devicelist.speed!.toInt() > 0){
      color=Colors.green;
      label= devicelist.name.toString() + '('+devicelist.speed!.toString()+' km)';
    }
    else  if(devicelist.online!.contains('online')){
      color=Colors.green;
      label= devicelist.name.toString();

    }else{
      color=Colors.red;
      label= devicelist.name.toString();
    }
    lati = devicelist.lat!.toDouble();
    lngi = devicelist.lng!.toDouble();
    String iconpath = devicelist.icon!.path.toString();

    //double angle =  devicelist.course as double;
    LatLng position = LatLng(lati, lngi);
    _latlng.add(position);
    _createImageLabel(iconpath: iconpath,label: label,course :devicelist.course.toDouble(),color: color).then((BitmapDescriptor customIcon) {
      if (mounted) {
        setState(() {
          _mapLoading = false;
          fUpdateTime=devicelist.time.toString();
          fspeed=devicelist.speed.toString();
          ftotalDistance=devicelist.totalDistance.toString();
          fstopDuration=devicelist.stopDuration.toString();
          _allMarker[MarkerId(devicelist.id.toString())] = RippleMarker(
            markerId: MarkerId(devicelist.id.toString()),
            position: position,
            ripple: true,
            anchor: Offset(0.5, 0.5),
            //rotation: 0.0,
            /*infoWindow: InfoWindow(
                title: 'This is marker '),*/
            onTap: () {

              setState(() {
                _statusbarLoading = (_statusbarLoading) ? false : true;
              });
              /* showModalBottomSheet<void>(
                context: context,
                //isDismissible: false,
                barrierColor: Colors.transparent,

                builder: (BuildContext context) {
                  return  Container(
                    height: 200,

                    child: _showDeliveryPopup()
                  );
                },
              );*/
              /* Fluttertoast.showToast(
                  msg: 'Click marker ',
                  toastLength: Toast.LENGTH_SHORT);*/
            },

            icon: customIcon,
            //icon: BitmapDescriptor.defaultMarker,
            // icon:  BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),"assets/icons/ignitidle.png"),
          );

          //_animatedMapMove(position,15);
          _controller!.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lati, lngi), 17));
        });
      }

    });


    //  }


    //  }
  }

  Widget _showStatusPopup() {

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 40),

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
                //  margin: EdgeInsets.fromLTRB(6, 1, 6, 1),

                child: Row(
                    children: [
                      Expanded(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/icons8-location-100.png", height: 30,width: 30)),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8,right: 30,top: 8,bottom: 15),

                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  address = "Loading....";
                                                  setState(() {});
                                                  getAddress(lati,lngi);
                                                },
                                                child:
                                                RichText(
                                                  maxLines: 5,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                      text:address,
                                                      style: TextStyle(
                                                        fontSize: 12,
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

                                    ],
                                  )
                              ))
                      )
                    ]
                ),
              ),
              Container(
                //margin: EdgeInsets.fromLTRB(12, 6, 12, 6),

                child: Row(
                    children: [
                      Expanded(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(6, 6, 1, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/speedometer1.png", height: 25,width: 25)),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /* Text(
                                              '_productData[index].name',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.blue
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),*/
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(' '+fspeed + ' KM/H',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'digital_font'
                                                  )),
                                            ),
                                            Container(
                                              // margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  /*Icon(Icons.location_on,
                                                      color: Colors.blue, size: 12),*/
                                                  Text(' Speed',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        height: 1.5,
                                                        //color: Colors.blue
                                                        fontWeight: FontWeight.bold,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            /*  Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  // _globalWidget.createRatingBar(rating: _productData[index].rating!, size: 12),
                                                  Text('(tests)', style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.blue
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(' '+'Sale',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.blue
                                                  )),
                                            ),*/
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                          )
                      ),
                      Expanded(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/stopdurationicon.png", height: 25,width: 25)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // margin: EdgeInsets.only(top: 5),
                                              child: Text(''+fstopDuration,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      //height: 0.8,
                                                      // fontFamily: 'digital_font'
                                                      fontWeight: FontWeight.bold
                                                  )),
                                            ),
                                            Container(
                                              // margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  /*Icon(Icons.location_on,
                                                      color: Colors.blue, size: 12),*/
                                                  Text('Duration',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        //color: Colors.blue
                                                        fontWeight: FontWeight.bold,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ))
                      ),

                    ]
                ),
              ),
              Container(
                //margin: EdgeInsets.fromLTRB(12, 6, 12, 6),

                child: Row(
                    children: [

                      Expanded(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/icons8-clock-100.png", height: 25,width: 25)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // margin: EdgeInsets.only(top: 5),
                                              child: Text(''+fUpdateTime,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      height: 0.8,
                                                      fontFamily: 'digital_font'
                                                    // fontWeight: FontWeight.bold
                                                  )),
                                            ),
                                            Container(
                                              // margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  /*Icon(Icons.location_on,
                                                      color: Colors.blue, size: 12),*/
                                                  Text('Last Update',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        height: 1.6,
                                                        //color: Colors.blue
                                                        fontWeight: FontWeight.bold,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ))
                      ),
                      Expanded(
                          child:Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/routeicon.png", height: 25,width: 25)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /* Text(
                                              '_productData[index].name',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.blue
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),*/
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(''+ftotalDistance,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'digital_font'
                                                  )),
                                            ),
                                            /*  Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.location_on,
                                                      color: Colors.blue, size: 12),
                                                  Text(' ',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.blue
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  // _globalWidget.createRatingBar(rating: _productData[index].rating!, size: 12),
                                                  Text('(tests)', style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.blue
                                                  ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(' '+'Sale',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.blue
                                                  )),
                                            ),*/
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                          )
                      ),

                    ]
                ),
              ),

            ],
          ),
        ),
      ),
    );




  }
/*  Widget _showDeliveryPopup(){
    return StatefulBuilder(builder: (BuildContext context, StateSetter mystate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),

          GestureDetector(
              onTap: () {
                address = "Loading....";
                setState(() {});
                getAddress(lati,lngi);
              },
              child: new Row(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Icon(Icons.location_on_outlined,
                        color: CustomColor.primaryColor, size: 22.0)),
                Padding(padding: new EdgeInsets.fromLTRB(5, 0, 0, 0)),
                Expanded(
                    child: Text(address,
                        style: TextStyle(
                            fontSize: 13, color: Colors.blue),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis))
              ])),
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text('Choose Courier', style: GlobalStyle.chooseCourier),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Text('DHL', style: GlobalStyle.courierTitle),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                     // _delivery = 'DHL Regular';
                      //_deliveryPrice = 13;
                    });
                    //countSubTotal();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Regular', style: GlobalStyle.courierType),
                        Text('\$13', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Express', style: GlobalStyle.courierType),
                        Text('\$22', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 32,
                  color: Colors.grey[400],
                ),
                Text('FedEx', style: GlobalStyle.courierTitle),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Regular', style: GlobalStyle.courierType),
                        Text('\$9', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){

                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Express', style: GlobalStyle.courierType),
                        Text('\$17', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ],
      );
    });
  }*/

  String address = "Address!";
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

Future<BitmapDescriptor> getMarkerIcon(String imagePath,String infoText,Color color,double rotateDegree) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  //size
  Size canvasSize = Size(700.0,220.0);
  Size markerSize = Size(140.0,140.0);



  final Paint infoPaint = Paint()..color = Colors.white;
  final Paint infoStrokePaint = Paint()..color = color;
  final double infoHeight = 70.0;
  final double strokeWidth = 2.0;

 // final Paint markerPaint = Paint()..color = color.withOpacity(0);
  final double shadowWidth = 30.0;

  final Paint borderPaint = Paint()..color = color..strokeWidth=2.0..style = PaintingStyle.stroke;

  final double imageOffset = shadowWidth*.5;

  canvas.translate(canvasSize.width/2, canvasSize.height/2+infoHeight/2);

  // Add shadow circle
  // canvas.drawOval(Rect.fromLTWH(-markerSize.width/2, -markerSize.height/2, markerSize.width, markerSize.height), markerPaint);
  // // Add border circle
  // canvas.drawOval(Rect.fromLTWH(-markerSize.width/2+shadowWidth, -markerSize.height/2+shadowWidth, markerSize.width-2*shadowWidth, markerSize.height-2*shadowWidth), borderPaint);

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
  ui.Image image;
  if(imagePath.contains("arrow-ack.png")){
    image = await getImageFromPath("assets/images/direction.png");
  }else{
    image = await getImageFromPathUrl(imagePath);

  }
  paintImage(canvas: canvas,image: image, rect: oval, fit: BoxFit.fitHeight);

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
