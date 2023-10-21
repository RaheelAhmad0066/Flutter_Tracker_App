import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;
class GoogleMaps6Page extends StatefulWidget {
  @override
  _GoogleMaps6PageState createState() => _GoogleMaps6PageState();
}

class _GoogleMaps6PageState extends State<GoogleMaps6Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late GoogleMapController _controller;
  bool _mapLoading = true;
  Timer? _timerDummy;

  double _currentZoom = 14;

  final LatLng _initialPosition = LatLng(-6.168033, 106.900467);

  List<LatLng> _markerList = [];

  Map<MarkerId, Marker> _allMarker = {};
  List<LatLng> _latlng = [];
  bool _isBound = false;
  bool _doneListing = false;
  late ui.Image _iconFacebook;
  double _iconFacebookSize=70;

  late BitmapDescriptor _markerStop;
  void _setSourceAndDestinationIcons() async {
    _markerStop = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
      //ImageConfiguration(size: Size(5, 5)),
        'assets/images/direction.png');
  }

 /* void _setSourceAndDestinationIcons() async {
    // make sure to initialize before map loading
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/images/direction.png')
        .then((d) {
      _markerStop = d;
    });
  }
*/
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
  }
*/

  @override
  void initState() {
    _setSourceAndDestinationIcons();
    super.initState();
  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
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
      appBar: _globalWidget.globalAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),
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
    );
  }

  // build google maps to used inside widget
  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      trafficEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      mapToolbarEnabled: true,
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
        _timerDummy = Timer(Duration(seconds: 1), () {
          setState(() {
            _mapLoading = false;

            // add all marker here
            for (int i = 0; i < StaticVarMethod.devicelist.length; i++) {
              if (StaticVarMethod.devicelist[i].lat != 0) {
                double lat = StaticVarMethod.devicelist[i].lat as double;
                double lng = StaticVarMethod.devicelist[i].lng as double;
                LatLng position = LatLng(lat, lng);
                //LatLng position = _markerList[i];
                _latlng.add(position);

                _allMarker[MarkerId(i.toString())] = Marker(
                  markerId: MarkerId(i.toString()),
                  position: position,
                  rotation: StaticVarMethod.devicelist[i].course.toDouble(),
                  infoWindow: InfoWindow(title: 'This is marker ' + (i + 1)
                      .toString()),
                  onTap: () {
                  /*  Fluttertoast.showToast(msg: 'Click marker ' +
                        (i + 1).toString(), toastLength: Toast.LENGTH_SHORT);*/
                  },
                  anchor: Offset(0.5, 0.5),
                  icon: _markerStop,
                );
                if (i == StaticVarMethod.devicelist.length - 1) {
                  _doneListing = true;
                }
              }
            }
            // zoom to all marker
            if(_isBound==false && _doneListing==true) {
              _isBound = true;
              CameraUpdate u2=CameraUpdate.newLatLngBounds(_boundsFromLatLngList(_latlng), 100);
              this._controller.moveCamera(u2).then((void v){
                _check(u2,this._controller);
              });
            }
          });
        });
      },
      onTap: (pos){
        print('currentZoom : '+_currentZoom.toString());
      },
    );
  }
}
