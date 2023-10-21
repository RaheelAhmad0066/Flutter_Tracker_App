import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maktrogps/config/custom_image_assets.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/screens/playback.dart';
import 'package:maktrogps/mapconfig/CommonMethod.dart';
import 'package:maktrogps/ui/reusable/global_widget.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;
import 'package:maktrogps/utils/Consts.dart';
import 'package:intl/intl.dart';

import '../../config/apps/ecommerce/constant.dart';

class playbackselection extends StatefulWidget {
  @override
  _playbackselection createState() => _playbackselection();
}

class _playbackselection extends State<playbackselection> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  late GoogleMapController _controller;
  bool _mapLoading = true;
  Timer? _timerDummy;
  bool _showMarker = true;
  double _currentZoom = 14;
  LatLng _initialPosition = LatLng(StaticVarMethod.lat,StaticVarMethod.lng);

  Map<MarkerId, Marker> _allMarker = {};
  List<LatLng> _latlng = [];
  bool _isBound = false;
  bool _doneListing = false;
  //date time hepers
  int _selectedperiod = 0;
  double _dialogHeight = 300.0;
  int _selectedTripInfoPeriod = 0;
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();

  var selectedToTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedTripInfoToTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedFromTime =  TimeOfDay.fromDateTime(DateTime.now());
  var selectedTripInfoFromTime =  TimeOfDay.fromDateTime(DateTime.now());
  var fromTime=        DateFormat("HH:mm:ss").format(DateTime.now());
  var fromTripInfoTime=        DateFormat("HH:mm:ss").format(DateTime.now());
  var toTime=  DateFormat("HH:mm:ss").format(DateTime.now());
  var toTripInfoTime=  DateFormat("HH:mm:ss").format(DateTime.now());
  @override
  void initState() {

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

  Future<BitmapDescriptor> _createImageLabel({String label='label', double fontSize=20,double course=0, Color color=Colors.red}) async {
    return getMarkerIcon("assets/images/direction.png",label,color,course);
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
         /* Positioned(

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
                child: Icon(
                  (_showMarker)
                      ? Icons.location_on
                      : Icons.location_off,
                  color: Colors.grey[700],
                  size: 20,
                ),
              ),
            ),
          ),
          Positioned(
            top: 48,
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
          ):SizedBox.shrink(),
          playBackControls(),
        ],
      ),
    );
  }


  Widget playBackControls() {

    return Positioned(
      bottom: 10,
      right: 10,
      left: 10,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 1,bottom: 30),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),

              //borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20) ),
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
                margin: EdgeInsets.only(top: 12),
                child:  Center(
                  child: Text(''+StaticVarMethod.deviceName,
                      style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                )
              ),
              Container(
                  margin: EdgeInsets.only(top: 12),
                    child: Text('Filter',
                        style: TextStyle(color: Colors.black,fontSize: 15)),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  children: [

                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedperiod = 0;
                                showReport();
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Last Hours',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                        )

                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {

                              setState(() {
                                _selectedperiod = 1;
                                showReport();
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Today',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                        )

                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child:OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedperiod = 2;
                                showReport();
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Yesterday',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                        )
                    ),
                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  children: [

                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedperiod = 3;
                                showReport();
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Before 2 days',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center,
                            )
                        )

                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedperiod = 4;
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Last 7 days',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 11
                              ),
                              textAlign: TextAlign.center,
                            )
                        )

                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child:OutlinedButton(
                            onPressed: () {
                              /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => mainmapscreen()),
                          );*/
                              //Fluttertoast.showToast(msg: 'Item has been added to Shopping Cart');
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Last Week',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                        )
                    ),
                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  children: [

                    Expanded(
                        child:OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedperiod = 5;
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(0, 40)
                                ),
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Select Custom Date & Time',
                              style: TextStyle(
                                  color: Colors.grey,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.center,
                            )
                        )
                    ),
                    SizedBox(
                      width: 3,
                    ),

                  ],
                ),
              ),
              _selectedperiod == 5
                  ?Container(
                  child: new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            //color: CustomColor.primaryColor,
                            onPressed: () => _selectFromDate(
                                context, setState),
                            child: Text(
                                formatReportDate(
                                    _selectedFromDate),
                                style: TextStyle(
                                    color: Colors.white)),
                          ),
                          ElevatedButton(
                            // color: CustomColor.primaryColor,
                            onPressed: () {setState(() {
                              _fromTime(context);  });

                            },
                            /*style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              animationDuration: 3
                              ),*/
                            child: Text(
                                formatReportTime(
                                    selectedFromTime),
                                style: TextStyle(
                                    backgroundColor: Colors.grey,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            //color: CustomColor.primaryColor,
                            onPressed: () =>
                                _selectToDate(context, setState),
                            child: Text(
                                formatReportDate(_selectedToDate),
                                style: TextStyle(
                                    color: Colors.white)),
                          ),
                          ElevatedButton(
                            // color: CustomColor.primaryColor,
                            onPressed: () {setState(() {
                              _toTime(context);  });

                            },
                            child: Text(
                                formatReportTime(selectedToTime),
                                style: TextStyle(
                                    color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ))
                  :Container(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showReport();
                   // Fluttertoast.showToast(msg: 'Press Outline Button', toastLength: Toast.LENGTH_SHORT);
                  },
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(0, 40)
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),

                          )
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: Colors.grey,
                            width: 1.0
                        ),
                      )
                  ),
                  icon: Icon(
                    Icons.play_arrow,
                    size: 24.0,color: Colors.grey,
                  ),
                  label: Text('View Playback History        ' ,style: TextStyle(
                      color: Colors.grey,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15
                  )),
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }
  // build google maps to used inside widget
  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      trafficEnabled: false,
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
            if(_isBound==false && _doneListing==true) {
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
    double lat = devicelist.lat!.toDouble();
    double lng = devicelist.lng!.toDouble();
    //double angle =  devicelist.course as double;
    LatLng position = LatLng(lat, lng);
    _latlng.add(position);
    _createImageLabel(label: label,course :devicelist.course.toDouble(),color: color).then((BitmapDescriptor customIcon) {
      if (mounted) {
        setState(() {
          _mapLoading = false;
          _allMarker[MarkerId(devicelist.id.toString())] = Marker(
            markerId: MarkerId(devicelist.id.toString()),
            position: position,
            //rotation: 0.0,
            infoWindow: InfoWindow(
                title: 'This is marker '),
            onTap: () {
           /*   Fluttertoast.showToast(
                  msg: 'Click marker ',
                  toastLength: Toast.LENGTH_SHORT);*/
            },
            anchor: Offset(0.5, 0.5),
            icon: customIcon,
            //icon: BitmapDescriptor.defaultMarker,
            // icon:  BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: .5),"assets/icons/ignitidle.png"),
          );

          _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17));
        });
      }

    });


    //  }


    //  }
  }


  //date time picker
  Future<void> _selectFromDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedFromDate)
      setState(() {
        _selectedFromDate = picked;
      });
  }

  Future<void> _selectToDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedToDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedToDate)
      setState(() {
        _selectedToDate = picked;
      });
  }

  Future<Null> _fromTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime:selectedFromTime,

    );
    if (picked != null && picked != selectedFromTime)
      setState(() {
        selectedFromTime = picked;
        var hour= selectedFromTime.hour;
        var minute= selectedFromTime.minute;
        fromTime ="$hour:$minute:00";
        print(fromTime);
        //var formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
  }

  Future<Null> _toTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime:selectedToTime,

    );
    if (picked != null && picked != selectedToTime)
      setState(() {
        selectedToTime = picked;
        var hour= selectedToTime.hour;
        var minute= selectedToTime.minute;
        toTime ="$hour:$minute:00";
        //  TimeOfDayFormat.H_colon_mm.toString();
        //var formattedDate = "${picked.year}-${picked.month}-${picked.day}";
      });
  }
  void showReport() {
    String fromDate;
    String toDate;
    String fromTime;
    String toTime;

    DateTime current = DateTime.now();

    String month;
    String day;
    if (current.month < 10) {
      month = "0" + current.month.toString();
    } else {
      month = current.month.toString();
    }

    if (current.day < 10) {
      day = "0" + current.day.toString();
    } else {
      day = current.day.toString();
    }

    if (_selectedperiod == 1) {
      String today;

      int dayCon = current.day + 1;
      if (dayCon <= 10) {
        today = "0" + dayCon.toString();
      } else {
        today = dayCon.toString();
      }

      var date = DateTime.parse("${current.year}-"
          "$month-"
          "$today "
          "00:00:00");
      fromDate = formatDateReport(DateTime.now().toString());
      toDate = formatDateReport(date.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";

      StaticVarMethod.fromdate = formatDateReport(DateTime.now().toString());
      StaticVarMethod.todate = formatDateReport(date.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else if (_selectedperiod == 2) {
      String yesterday;

      int dayCon = current.day - 1;
      if (current.day <= 10) {
        yesterday = "0" + dayCon.toString();
      } else {
        yesterday = dayCon.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$yesterday "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else if (_selectedperiod == 3) {
      String sevenDay, currentDayString;
      int dayCon = current.day - current.weekday;
      int currentDay = current.day;
      if (dayCon < 10) {
        sevenDay = "0" + dayCon.abs().toString();
      } else {
        sevenDay = dayCon.toString();
      }
      if (currentDay < 10) {
        currentDayString = "0" + currentDay.toString();
      } else {
        currentDayString = currentDay.toString();
      }

      var start = DateTime.parse("${current.year}-"
          "$month-"
          "$sevenDay "
          "00:00:00");

      var end = DateTime.parse("${current.year}-"
          "$month-"
          "$currentDayString "
          "24:00:00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = "00:00:00";
      toTime = "00:00:00";
      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime =  "00:00";
      StaticVarMethod.totime =  "00:00";
    } else {
      String startMonth, endMoth;
      if (_selectedFromDate.month < 10) {
        startMonth = "0" + _selectedFromDate.month.toString();
      } else {
        startMonth = _selectedFromDate.month.toString();
      }

      if (_selectedToDate.month < 10) {
        endMoth = "0" + _selectedToDate.month.toString();
      } else {
        endMoth = _selectedToDate.month.toString();
      }

      String startHour, endHour;
      if (selectedFromTime.hour < 10) {
        startHour = "0" + selectedFromTime.hour.toString();
      } else {
        startHour = selectedFromTime.hour.toString();
      }

      String startMin, endMin;
      if (selectedFromTime.minute < 10) {
        startMin = "0" + selectedFromTime.minute.toString();
      } else {
        startMin = selectedFromTime.minute.toString();
      }

      if (selectedToTime.minute < 10) {
        endMin = "0" + selectedToTime.minute.toString();
      } else {
        endMin = selectedToTime.minute.toString();
      }

      if (selectedToTime.hour < 10) {
        endHour = "0" + selectedToTime.hour.toString();
      } else {
        endHour = selectedToTime.hour.toString();
      }

      String startDay, endDay;
      if (_selectedFromDate.day <= 10) {
        if (_selectedFromDate.day == 10) {
          startDay = _selectedFromDate.day.toString();
        } else {
          startDay = "0" + _selectedFromDate.day.toString();
        }
      } else {
        startDay = _selectedFromDate.day.toString();
      }

      if (_selectedToDate.day <= 10) {
        if (_selectedToDate.day == 10) {
          endDay = _selectedToDate.day.toString();
        } else {
          endDay = "0" + _selectedToDate.day.toString();
        }
      } else {
        endDay = _selectedToDate.day.toString();
      }

      var start = DateTime.parse("${_selectedFromDate.year}-"
          "$startMonth-"
          "$startDay "
          "$startHour:"
          "$startMin:"
          "00");

      var end = DateTime.parse("${_selectedToDate.year}-"
          "$endMoth-"
          "$endDay "
          "$endHour:"
          "$endMin:"
          "00");

      fromDate = formatDateReport(start.toString());
      toDate = formatDateReport(end.toString());
      fromTime = formatTimeReport(start.toString());
      toTime = formatTimeReport(end.toString());

      StaticVarMethod.fromdate = formatDateReport(start.toString());
      StaticVarMethod.todate = formatDateReport(end.toString());
      StaticVarMethod.fromtime = formatTimeReport(start.toString());
      StaticVarMethod.totime = formatTimeReport(end.toString());
    }

    print(fromDate);
    print(toDate);

    //Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlaybackPage()),
    );
   // getReport(StaticVarMethod.deviceId,StaticVarMethod.fromdate,StaticVarMethod.fromtime,StaticVarMethod.todate,StaticVarMethod.totime);
    /* Navigator.pushNamed(context, "/reportList",
        arguments: ReportArguments(device['id'], fromDate, fromTime,
            toDate, toTime, device["name"], 0));*/

  }
}

Future<BitmapDescriptor> getMarkerIcon(String imagePath,String infoText,Color color,double rotateDegree) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  //size
  Size canvasSize = Size(700.0,220.0);
  Size markerSize = Size(80.0,80.0);

  // Add info text
  TextPainter textPainter = TextPainter(textDirection: Consts.ltrtext);
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
