import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maktrogps/config/apps/ecommerce/global_style.dart';
import 'package:maktrogps/config/custom_image_assets.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;

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

  LatLng _initialPosition = LatLng(35.168033,74.900467);
  Location currentLocation = Location();
  Set<Marker> _markers={};
 /* List<LatLng> _markerList = [];*/

  Map<MarkerId, Marker> _allMarker = {};
  List<LatLng> _latlng = [];
  bool _isBound = false;
  bool _doneListing = false;
  MapType _currentMapType = MapType.normal;
  bool _trafficEnabled = false;
  var _trafficButtonColor = Colors.grey[700];
  @override
  void initState() {
/*    _markerList.add(LatLng(-6.168033, 106.900467));
    _markerList.add(LatLng(-6.164770, 106.900630));
    _markerList.add(LatLng(-6.158637, 106.906376));*/
    //_initImage();
    super.initState();
    _timerDummy = Timer.periodic(Duration(seconds: 20), (Timer t) => _getData());
  }
  Future<void> _getData() async{
    gpsapis api=new gpsapis();
    var hash=StaticVarMethod.user_api_hash;
    StaticVarMethod.devicelist =await gpsapis.getDevicesList(hash);
    updateMarker();
 /*   setState(() {

      });*/
  }



  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
  }

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();

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

  Future<BitmapDescriptor> _createImageLabel({String iconpath='',String label='label', double fontSize=20,double course=0, Color color=Colors.red, bool showtitle=true}) async {
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
    iconpath=StaticVarMethod.baseurlall+"/"+iconpath;

    return getMarkerIcon(iconpath,label,color,course,showtitle);
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
         automaticallyImplyLeading: false,
         elevation: 0,
      /* iconTheme: IconThemeData(
          color: GlobalStyle.appBarIconThemeColor,
        ),*/
      //systemOverlayStyle: GlobalStyle.appBarSystemOverlayStyle,
      centerTitle: false,
      title: Image.asset('assets/appsicon/maktroicon.png', height: 40),
      backgroundColor: GlobalStyle.appBarBackgroundColor,
      //bottom: _reusableWidget.bottomAppBar(),
    ),//_globalWidget.globalAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),
          Positioned(

            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMarker = (_showMarker) ? false : true;
                  for (int a = 0; a < _allMarker.length; a++) {
                    if(_allMarker[MarkerId(a.toString())]!=null){
                      _allMarker[MarkerId(a.toString())] =
                          _allMarker[MarkerId(a.toString())]!.copyWith(
                            visibleParam: _showMarker,
                          );
                    }
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
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
                child:  (_showMarker) ? Image.asset("assets/images/movingdurationicon.png", height: 20,width: 20)
                    : Image.asset("assets/images/movingdurationhide.png", height: 20,width: 20), /*Icon(
                  (_showMarker)
                      ? Icons.location_on
                      : Icons.location_off,
                  color: Colors.grey[700],
                  size: 20,
                ),*/
              ),
            ),
          ),
          Positioned(

            top: 57,
            left: 16,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTitle = (_showTitle) ? false : true;
                   updateMarker();
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                width: 36,
                height: 36,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
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
                child:  (_showTitle) ? Image.asset("assets/images/textshow.png", height: 25,width: 25)
                : Image.asset("assets/images/texthideone.png", height: 25,width: 25),
              ),
            ),
          ),

          Positioned(
            bottom: 300,
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
            bottom: 263,
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
          ),

          Positioned(
            bottom: 200,
            left: 16,
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
                child:   Icon(Icons.zoom_in,
                  color: Colors.grey[700],
                  size: 30,
                ),
              ),
            ),
          ),
          Positioned(

            bottom: 163,
            left: 16,
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
                child: Icon(Icons.zoom_out,
                  color: Colors.grey[700],
                  size: 30,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 200,
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
                  color: Colors.transparent,
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
                child:   Icon(Icons.my_location,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(

            bottom: 163,
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
                  color: Colors.transparent,
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
                child: Icon(Icons.refresh,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
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
          (_mapLoading)?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[100],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):SizedBox.shrink()
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
    this._controller.moveCamera(u2).then((void v){
      _check(u2,this._controller);
    });
  }

  void getLocation() async{
    final Uint8List markIcons = await getImages("assets/images/direction.png", 100);
    var location = await currentLocation.getLocation();

    _controller?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(location.latitude ?? 0.0,location.longitude?? 0.0),
      zoom: 12.0,
    )));
   /* setState(() {
      _markers.add(Marker(markerId: MarkerId('Home'),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0)
      ));
    });*/
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
      onCameraIdle: (){
        if(_isBound==false && _doneListing==true) {
          _isBound = true;
          CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 50);
          this._controller.moveCamera(u2).then((void v){
            _check(u2,this._controller);
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
            if(_isBound==false /*&& _doneListing==true*/) {
              _isBound = true;
              CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 100);
              this._controller.moveCamera(u2).then((void v){
                _check(u2,this._controller);
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


  updateMarker(){

   /* Fluttertoast.showToast(
        msg: 'Click marker ' + ( 1).toString(),
        toastLength: Toast.LENGTH_SHORT);*/

     _initialPosition = LatLng(StaticVarMethod.devicelist[0].lat!.toDouble(),StaticVarMethod.devicelist[0].lng!.toDouble());
    //_allMarker.clear();
    for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {

      if(StaticVarMethod.devicelist[i].lat != 0) {

        var color;
        var label;

       if(StaticVarMethod.devicelist[i].speed!.toInt() > 0){
        color=Colors.green;
        label= StaticVarMethod.devicelist[i].name.toString() + '('+StaticVarMethod.devicelist[i].speed!.toString()+' km)';
      }
       else  if(StaticVarMethod.devicelist[i].online!.contains('online')){
          color=Colors.green;
          label= StaticVarMethod.devicelist[i].name.toString();

      }else{
          color=Colors.red;
          label= StaticVarMethod.devicelist[i].name.toString();
        }
        double lat = StaticVarMethod.devicelist[i].lat as double;
        double lng = StaticVarMethod.devicelist[i].lng as double;
        String iconpath = StaticVarMethod.devicelist[i].icon!.path.toString();
        //double angle =  StaticVarMethod.devicelist[i].course as double;
        LatLng position = LatLng(lat, lng);
        _latlng.add(position);
        _createImageLabel(iconpath: iconpath,label: label,course :StaticVarMethod.devicelist[i].course.toDouble(),color: color,showtitle: _showTitle).then((BitmapDescriptor customIcon) {
          if (mounted) {
            setState(() {
              _mapLoading = false;
              _allMarker[MarkerId(i.toString())] = Marker(
                  markerId: MarkerId(i.toString()),
                  position: position,
                  //rotation: 0.0,
                 // infoWindow: InfoWindow(
                  //    title: 'This is marker ' + (i + 1).toString()),
                  onTap: () {
                    _initialPosition = LatLng(position.latitude,position.longitude);
                   /* Fluttertoast.showToast(
                        msg: 'Click marker ' + (i + 1).toString(),
                        toastLength: Toast.LENGTH_SHORT);*/
                  },
                  anchor: Offset(0.5, 0.5),
                  icon:  customIcon
              );
            });
          }

        });
        if (i == StaticVarMethod.devicelist.length - 1) {
          _doneListing = true;
        }

      }


    }
  }
}


Future<BitmapDescriptor> getMarkerIcon(String imagePath,String infoText,Color color,double rotateDegree,bool _showTitle) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  //size
  Size canvasSize = Size(700.0,220.0);
  Size markerSize = Size(80.0,80.0);
  late TextPainter textPainter;
  if(_showTitle){
    // Add info text
    textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: infoText,
      style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.w600, color: color),
    );
    textPainter.layout();
  }


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

  ui.Image image;
  // Add image
  if(imagePath.contains("arrow-ack.png")){
    image = await getImageFromPath("assets/images/direction.png");
  }else{
    image = await getImageFromPathUrl(imagePath);

  }

  paintImage(canvas: canvas,image: image, rect: oval, fit: BoxFit.fitHeight);

  canvas.restore();
  if(_showTitle){
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
  }


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


