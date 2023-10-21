import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class historyscreen extends StatefulWidget {
  @override
  _historyscreenState createState() => _historyscreenState();
}

class _historyscreenState extends State<historyscreen> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late GoogleMapController _controller;
  bool _mapLoading = true;
  Timer? _timerDummy;

  // latlng is for moving gps
  List<LatLng> _latlng = [];

  // to drawing polylines of moving gps and distance
  Map<PolylineId, Polyline> _mapPolylines = {};

  double _currentZoom = 14;

  final LatLng _initialPosition = LatLng(-6.168033, 106.900467);


  List<AllItems> _allItemsData = [];
  List<AllItems> _allItems_sorted = [];
  List<AllItems> _allItems_duplicate = [];

  @override
  void initState() {
  /*  _latlng.add(LatLng(-6.168033, 106.900467));
    _latlng.add(LatLng(-6.164770, 106.900630));
    _latlng.add(LatLng(-6.158637, 106.906376));*/
    _getData();
    super.initState();
  }

  Future<void> _getData() async{
    // this timer function is just for demo, so after 2 second, the shimmer loading will disappear and show the content
    /* _timerDummy = Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });*/
    Fluttertoast.showToast(
        msg: 'Refresh ',
        toastLength: Toast.LENGTH_SHORT);
    gpsapis api=new gpsapis();
    var hash=StaticVarMethod.user_api_hash;
    _allItemsData =await api.getHistoryAllList(hash);
    if (_allItemsData.isNotEmpty) {
      _allItems_duplicate.clear();
      _allItems_sorted.clear();
      _allItems_sorted.addAll(_allItemsData);
      _allItems_duplicate.addAll(_allItemsData);
      for (int i = 0; i < _allItemsData.length; i++) {
        if(_allItemsData[i].lat != 0) {
          double lat = _allItemsData[i].lat as double;
          double lng = _allItemsData[i].lng as double;
          _latlng.add(LatLng(lat, lng));
        }
      }
      //  StaticVarMethod.devicelist=_allItemsData;
      if (mounted) {
        setState(() {
          _mapLoading = false;
        });
      }

    } else {
      print("not available");
      _mapLoading = false;
      _allItems_duplicate.clear();
      _allItems_sorted.clear();
      if (mounted) {
        setState(() {});
      }

    }

  }

  @override
  void dispose() {
    _timerDummy?.cancel();
    super.dispose();
  }

  // add marker
  void _drawPolylines() {
    final PolylineId polylineId = PolylineId('1');
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      visible: true,
      width: 2,
      points: _latlng,
      color: Colors.pinkAccent,
    );
    _mapPolylines[polylineId] = polyline;

    CameraUpdate u2 = CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: 15));

    this._controller.moveCamera(u2).then((void v) {
      _check(u2, this._controller);
    });
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
      polylines: Set<Polyline>.of(_mapPolylines.values),
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: _currentZoom,
      ),
      onCameraMove: _onGeoChanged,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        _timerDummy = Timer(Duration(milliseconds: 300), () {
          setState(() {
            _mapLoading = false;
            _drawPolylines();
          });
        });
      },
      onTap: (pos){
        print('currentZoom : '+_currentZoom.toString());
      },
    );
  }
}
