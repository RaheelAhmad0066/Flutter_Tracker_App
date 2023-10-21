import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:math' as m;
import 'dart:ui' as ui;
import 'package:alxgration_speedometer/speedometer.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maktrogps/data/screens/browser_module_old/browser.dart';
import 'package:maktrogps/utils/MapUtils.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart' as l;
import 'package:odometer/odometer.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:vector_math/vector_math.dart' as v;
import 'package:flutter/material.dart' as m;
import 'package:url_launcher/url_launcher.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constant.dart';
import '../../../config/static.dart';
import '../../../mapconfig/CustomColor.dart';
import '../../../mvvm/view_model/objects.dart';
import '../../../ui/reusable/Mycolor/MyColor.dart';
import '../../model/devices.dart';


class LiveMapScreen extends StatefulWidget {
  LiveMapScreen({Key? key}) : super(key: key);

  @override
  _LiveMapScreenState createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> with TickerProviderStateMixin{
  Completer<GoogleMapController> _controller = Completer();

  MapType _currentMapType = MapType.normal;
  Color _mapTypeBackgroundColor = MyColor.primaryColor;
  Color _mapTypeForegroundColor = MyColor.whiteColor;
  Color _mainColor = Color(0xff2e414b);
  double currentZoom = 16.0;
  bool _trafficEnabled = true;
  List<Marker> _markers = <Marker>[];

  DriverData? driverData;
  bool pageDestoryed = false;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Timer? _timer;
  Timer? _timer2;
  double todayDistance = 0;
  double averageSpeed = 0;
  double maxSpeed = 0;
  double spentFuel = 0;
  double startOdometer = 0;
  double endOdometer = 0;
  int engineHours = 0;
  bool isLoading = true;
  bool noData = false;
  List<LatLng> newPolylinesData = [];
  List<LatLng> parkPolylinesData = [];


  Color _trafficBackgroundButtonColor = CustomColor.primaryColor;
  Color _trafficForegroundButtonColor = Colors.white;
  late GoogleMapController mapController;

  bool isFirst = true;
  bool first= true;

  double _dialogHeight = 320.0;
  int _selectedPeriod = 0;
  late GoogleMapController _mapController;
  LatLng? oldPin;

  double _dialogHeightShare = 330.0;
  int _selectedPeriodShare = 0;

  DateTime _selectedToShareDate = DateTime.now();
  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  TimeOfDay _selectedFromTime = TimeOfDay.now();
  TimeOfDay _selectedToTime = TimeOfDay.now();



  Animation<double>? _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  AnimationController? animationController;
  Set<Circle> _circles = Set<Circle>();
  bool isParked = false;
  String? markerId;
  bool parkingEvent = false;
  bool eventUpdated = false;
  String? eventId;
  String stopTime = "0 s";
  String runTime = "0 s";
  String idleTime = "0 s";
  String inactiveTime = "0 s";
  bool lockStatus = false;

  static final CameraPosition _initialRegion = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14,
  );
  Location currentLocation = Location();
  bool _statusbarLoading = true;
  List<deviceItems> devicesList = [];
  late ObjectStore objectStore;
  @override
  void initState() {

    super.initState();
    drawPolyline();
    drawPolyline2();

  }




  void drawPolyline() async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  void drawPolyline2() async {
    PolylineId id = PolylineId("polyAnim");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        color: Colors.blueAccent,
        points: newPolylinesData);
    polylines[id] = polyline;
    setState(() {});
  }

  void drawPolyline3() async {
    PolylineId id = PolylineId("polyPark");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        color: Colors.blueAccent,
        points: parkPolylinesData);
    polylines[id] = polyline;
    setState(() {});
  }





  String address = "View Address";
  String getAddress(lat, lng) {
    if (lat != null) {
      gpsapis.getGeocoder(lat, lng).then((value) => {
        if (value != null)
          {
            address = value.body,
          //  setState(() {}),
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

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
      _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
      _mapTypeBackgroundColor = _currentMapType == MapType.normal
          ? MyColor.primaryColor
          : MyColor.whiteColor;
      _mapTypeForegroundColor = _currentMapType == MapType.normal
          ? MyColor.whiteColor
          : MyColor.primaryColor;
    });
  }

  void _trafficEnabledPressed() {
    setState(() {
      _trafficEnabled = _trafficEnabled == false ? true : false;
      _trafficBackgroundButtonColor = _trafficEnabled == false
          ? MyColor.whiteColor
          : MyColor.primaryColor;

      _trafficForegroundButtonColor = _trafficEnabled == false
          ? MyColor.primaryColor
          : MyColor.whiteColor;
    });
  }

  void reload() async{
    // polylines.clear();
    // polylineCoordinates.clear();
    // CameraPosition cPosition = CameraPosition(
    //   target: LatLng(double.parse(device.data![0][2].toString()),
    //       double.parse(device.data![0][3].toString())),
    //   zoom: currentZoom,
    // );
    // final GoogleMapController controller = await _controller.future;
    // controller.moveCamera(CameraUpdate.newCameraPosition(cPosition));
    //setState(() {});

  }

  @override
  void dispose() {
    pageDestoryed = true;
    if(_timer != null) {
      _timer!.cancel();
    }
    if(_timer2 != null){
      _timer2!.cancel();
    }
    if(animationController != null) {
      animationController!.dispose();
    }
    super.dispose();
  }

  currentMapStatus(CameraPosition position) {
    currentZoom = position.zoom;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  late double lati;
  late double lngi;
  String fUpdateTime = 'Not Found';
  String fspeed ='Not Found';
  int? speedo =0;
  String ftotalDistance ='Not Found';
  String fstopDuration ='Not Found';

  void updateMarker(deviceItems devicelist) async {
    var iconPath;
    var color;
    var label;
    int? speed = int.tryParse(devicelist.speed.toString());

    lati = devicelist.lat!.toDouble();
    lngi = devicelist.lng!.toDouble();
    fUpdateTime=devicelist.time.toString();
    fspeed=devicelist.speed.toString();
    speedo=int.tryParse(devicelist.speed.toString());
    ftotalDistance=devicelist.totalDistance.toString();
    fstopDuration=devicelist.stopDuration.toString();
    // String replacePath = category.replaceAll("img/markers/objects/land-", "");
    // String replacePath2 = replacePath.replaceAll(".svg", "");
    // String finalImg = replacePath2.replaceAll(RegExp('[^A-Za-z]'),'');





    Uint8List markerIcon;
    try {
      if(MediaQuery.of(context).size.aspectRatio > 0.55){
        markerIcon = await getBytesFromAsset(iconPath, 40);
      }else{
        markerIcon = await getBytesFromAsset(iconPath, 60);
      }
    }catch(e){
      if(int.tryParse(devicelist.speed.toString())! > 0){
        iconPath =  "assets/tbtrack/truck_toprunning.png";
        color=Colors.green;
        label= devicelist.name.toString() + '('+devicelist.speed!.toString()+' km)';
        if(StaticVarMethod.pref_static!.get(devicelist.deviceData!.imei.toString())!=null)
          iconPath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(devicelist.deviceData!.imei.toString()).toString()+"toprunning.png";

      }
      else{
        color=Colors.red;
        iconPath =  "assets/tbtrack/truck_topstop.png";
        label= devicelist.name.toString();
        if(StaticVarMethod.pref_static!.get(devicelist.deviceData!.imei.toString())!=null)
          iconPath =  "assets/tbtrack/"+StaticVarMethod.pref_static!.get(devicelist.deviceData!.imei.toString()).toString()+"topstop.png";
      }
      if(MediaQuery.of(context).size.aspectRatio > 0.55){
        markerIcon = await getBytesFromAsset(iconPath, 40);
      }else{
        markerIcon = await getBytesFromAsset(iconPath, 60);
      }
    }

    var pinPosition =  LatLng(
        double.parse(devicelist.lat.toString()), double.parse(devicelist.lng.toString()));

    if (first) {
      CameraPosition cPosition = CameraPosition(
        target: LatLng(
            double.parse(devicelist.lat.toString()), double.parse(devicelist.lng.toString())),
        zoom: currentZoom,
      );

      final pickupMarker = Marker(
        markerId: MarkerId(StaticVarMethod.imei.toString()),
        position:pinPosition,
        rotation: double.parse(devicelist.course.toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),);

      //Adding a delay and then showing the marker on screen
      await Future.delayed(const Duration(milliseconds: 500));

      _markers.add(pickupMarker);
      _mapMarkerSink.add(_markers);

      oldPin = LatLng(double.parse(devicelist.lat.toString()), double.parse(devicelist.lng.toString()));

      final GoogleMapController controller = await _controller.future;
      controller.moveCamera(CameraUpdate.newCameraPosition(cPosition));
      first = false;
    }
    // var pinPosition =  LatLng(
    //     double.parse(value.data![0][2]), double.parse(value.data![0][3]));
    // _markers.removeWhere((m) => m.markerId.value == args.imei);

    getAddress(double.parse(devicelist.lat.toString()), double.parse(devicelist.lng.toString()));
    if (!first){
      Future.delayed(const Duration(seconds: 2)).then((value) {
        if(oldPin != pinPosition) {
          animateCar(
              oldPin!.latitude,
              oldPin!.longitude,
              pinPosition.latitude,
              pinPosition.longitude,
              _mapMarkerSink,
              this,
              _mapController,
              markerIcon
          );
        }
      });
    }

  }



  animateCar(
      double fromLat, //Starting latitude
      double fromLong, //Starting longitude
      double toLat, //Ending latitude
      double toLong, //Ending longitude
      StreamSink<List<Marker>>
      mapMarkerSink, //Stream build of map to update the UI
      TickerProvider
      provider, //Ticker provider of the widget. This is used for animation
      GoogleMapController controller,
      markerIcon//Google map controller of our widget
      ) async {
    final double bearing =
    getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    _markers.clear();

    var carMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: LatLng(fromLat, fromLong),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: bearing,
        draggable: false);

    //Adding initial marker to the start location.
    _markers.add(carMarker);
    mapMarkerSink.add(_markers);
    animationController = AnimationController(
      duration: const Duration(seconds: 10), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController!)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (_markers.contains(carMarker)) _markers.remove(carMarker);

        //New marker location
        carMarker = Marker(
            markerId: const MarkerId("driverMarker"),
            position: newPos,
            icon: BitmapDescriptor.fromBytes(markerIcon),
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.
        _markers.add(carMarker);
        mapMarkerSink.add(_markers);
        newPolylinesData.add(carMarker.position);
        oldPin = newPos;
        //Moving the google camera to the new animated location.
        // controller.animateCamera(CameraUpdate.newCameraPosition(
        //     CameraPosition(target: newPos, zoom: currentZoom)));
      });

    polylineCoordinates.add(oldPin!);
    animationController!.forward();
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(toLat, toLong), zoom: currentZoom)));
    newPolylinesData.clear();
    if(polylineCoordinates.length > 20){
      polylineCoordinates.removeRange(0, 10);
    }
    // Future.delayed(Duration(seconds: 7)).then((value) => {
    //   controller.animateCamera(CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(toLat, toLong), zoom: currentZoom)))
    // });

  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return v.degrees(m.atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - v.degrees(m.atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return v.degrees(m.atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - v.degrees(m.atan(lng / lat))) + 270;
    }
    return -1;
  }


  @override
  Widget build(BuildContext context) {

    objectStore = Provider.of<ObjectStore>(context);
    devicesList = objectStore.objects;


    var devicemodel= devicesList.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;
    if (devicemodel !=null ) {
      updateMarker(devicemodel);
      isLoading = false;
      noData = false;
    }else{
      isLoading = false;
      noData = true;
      // setState(() {
      //   isLoading = false;
      //   noData = true;
      // });
    }

    final double boxImageSize = (MediaQuery.of(context).size.width / 12);

    print("build live track");
    return SafeArea(
        child: Scaffold(
          body: !isLoading ? !noData ?  Stack(
              children: <Widget>[
                buildMap(),
                //speedometer(),

                Positioned(
                  bottom:220,
                  left: 16,
                  child: GestureDetector(
                    onTap: () async {},
                    child:
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ( Colors.white),
                        border: Border.all(width: 2, color: Color(0xff0B77EC)),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2.0,
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      // color: Colors.white,
                      //color: Color(0x99FFFFFF),
                      child:Column(
                        children: [
                          Text(''+fspeed, style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600,
                          )
                          ),
                          SizedBox(height: 0),
                          Text('km/h', style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400,
                            fontSize: 8,
                          )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Positioned(
                //   top: 50,
                //   left: 16,
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       padding: EdgeInsets.all(5),
                //       width: 36,
                //       height: 36,
                //       child:    Container(
                //           padding: EdgeInsets.all(3),
                //           child: Icon(Icons.arrow_back,
                //             color: Color(0xff0D3D65),
                //             size: 25,
                //           )
                //       ),
                //     ),
                //   ),
                // ),
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
                      child:    Container(
                        padding: EdgeInsets.all(3),
                        child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0)),
                            child: Image.asset("assets/images/layers.png",
                              height: 1,width: 1,
                              color: Color(0xff0D3D65),)),
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
                        color: Color(0xff0D3D65),
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
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0)),
                            child: Image.asset("assets/images/arrow.png",
                              height: 1,width: 1,
                              color: Color(0xff0D3D65),)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180,
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
                        color: Color(0xff0D3D65),
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
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0)),
                            child: Image.asset("assets/images/parallelarrow.png",
                              height: 1,width: 1,
                              color: Color(0xff0D3D65),)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 260,
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
                      child:   Container(
                        padding: EdgeInsets.all(3),
                        child: ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(0)),
                            child: Image.asset("assets/images/mylocation1.png",
                              height: 1,width: 1,
                              color: Color(0xff0D3D65),)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  right: 16,

                  child: GestureDetector(
                    onTap: () async {


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
                (_statusbarLoading)?_showStatusPopup(boxImageSize):_showvehiclestatus(),
                mainView()

              ]) : Center(
              child: Text("noData")  ): Center(child: CircularProgressIndicator(),) ,
        )
    );
  }

  Widget mainView(){
    Color? color = Colors.red.withOpacity(0.5);
    String status = fUpdateTime;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 5), child:
          Container(
            margin: EdgeInsets.only(left:20,right: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.black,
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: color!

              ),
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width / 1.02,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(right: 8)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap: (){
                        Navigator.pop(context);
                      }, child:
                      Icon(Icons.arrow_back_ios,color: Colors.white, size: 30,))
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            StaticVarMethod.deviceName.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontFamily: "Sofia",
                                fontWeight: FontWeight.w900,
                                fontSize: 14.0,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(status,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: "Sofia",
                                  fontSize: 10.0,
                                  color: Colors.white,),
                              ),

                              // Text(('validity').tr(),style: TextStyle(
                              //     fontSize: 11.0,
                              //     color: MyColor.primaryColor),),
                              // Padding(padding: EdgeInsets.only(left: 5)),
                              // Text(devicesSettingsList![args.imei][33] != '0000-00-00' ? Util.dateToDays(devicesSettingsList![args.imei][33]).toString()+" days" : "-",
                              //   style: TextStyle(
                              //       fontSize: 11.0,
                              //       fontWeight: FontWeight.bold,
                              //       color: MyColor.primaryColor),),
                            ],
                          ),
                          // Text(device.data!.isNotEmpty ? device.data![0][6].toString() + " Km/hr" : "0 Km/hr",style: TextStyle(
                          //     fontSize: 11.0,
                          //     color: MyColor.primaryColor),),
                        ],
                      )
                    ],
                  )
                ],
              )
          )
          ),
        ),
      ],
    );
  }


  void getLocation() async{
    var location = await currentLocation.getLocation();

    _mapController?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(location.latitude ?? 0.0,location.longitude?? 0.0),
      zoom: 12.0,
    )));

  }
  Widget speedometer() {


    return   Positioned(
        top: 70,
        left: 0,
        right: 0,
        child:  Speedometer(
          size:50,
          minValue: 0,
          maxValue: 160,
          currentValue:speedo!,
          barColor: Colors.black87,
          pointerColor: Colors.red,
          displayText: ""+speedo.toString()+" km",
          displayTextStyle: TextStyle(fontSize: 9, color: Colors.black,fontFamily: 'digital_font',fontWeight: FontWeight.bold ),
          displayNumericStyle: TextStyle(fontSize: 9, color: Colors.red,fontFamily: 'digital_font',fontWeight: FontWeight.bold,height: 40),
          onComplete: (){
            print("ON COMPLETE");
          },
        )
    );
  }




  Widget buildMap() {

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: _currentMapType,
            trafficEnabled: _trafficEnabled,
            initialCameraPosition: _initialRegion,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            onCameraMove: currentMapStatus,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            minMaxZoomPreference: MinMaxZoomPreference(0,20),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
            },
            polylines:  Set<Polyline>.of(polylines.values),
            markers: Set<Marker>.of(snapshot.data ?? []),
            padding: EdgeInsets.all(8),
            circles: _circles,
          );
        });

    return Stack(
      children: <Widget>[
        Container(
            child:googleMap
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 50, 5, 0),
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: Column(
        //       children: <Widget>[
        //         Padding(
        //           padding: const EdgeInsets.fromLTRB(0, 30, 5, 0),
        //           child: Align(
        //             alignment: Alignment.topRight,
        //             child: Column(
        //               children: <Widget>[
        //                 FloatingActionButton(
        //                   heroTag: "mapType",
        //                   onPressed: _onMapTypeButtonPressed,
        //                   materialTapTargetSize: MaterialTapTargetSize.padded,
        //                   backgroundColor: _mapTypeBackgroundColor,
        //                   foregroundColor: _mapTypeForegroundColor,
        //                   mini: true,
        //                   child: const Icon(Icons.map, size: 30.0),
        //                 ),
        //                 FloatingActionButton(
        //                   heroTag: "traffic",
        //                   onPressed: _trafficEnabledPressed,
        //                   mini: true,
        //                   materialTapTargetSize: MaterialTapTargetSize.padded,
        //                   backgroundColor: _trafficBackgroundButtonColor,
        //                   foregroundColor: _trafficForegroundButtonColor,
        //                   child: const Icon(Icons.traffic, size: 30.0),
        //                 ),
        //                 FloatingActionButton(
        //                   heroTag: "route",
        //                   onPressed: () async{
        //                     String origin = "device.data![0][2].toString()"; // lat,long like 123.34,68.56
        //                     if (Platform.isAndroid) {
        //                       String query = Uri.encodeComponent(origin);
        //                      String url =
        //                       "https://www.google.com/maps/search/?api=1&query=$query";
        //                       await launch(url);
        //                     } else {
        //                       String urlAppleMaps =
        //                       'https://maps.apple.com/?q=$origin';
        //                       String url =
        //                       "comgooglemaps://?saddr=&daddr=$origin&directionsmode=driving";
        //                       if (await canLaunch(url)) {
        //                     await launch(url);
        //                     } else {
        //                     if (await canLaunch(url)) {
        //                     await launch(url);
        //                     } else if (await canLaunch(
        //                     urlAppleMaps)) {
        //                     await launch(urlAppleMaps);
        //                     } else {
        //                     throw 'Could not launch $url';
        //                     }
        //                     throw 'Could not launch $url';
        //                     }
        //                   }
        //                   },
        //                   mini: true,
        //                   materialTapTargetSize: MaterialTapTargetSize.padded,
        //                   backgroundColor: Colors.white,
        //                   foregroundColor: MyColor.primaryColor,
        //                   child: const Icon(Icons.directions, size: 30.0),
        //                 ),
        //
        //                 // FloatingActionButton(
        //                 //   heroTag: "sensors",
        //                 //   onPressed: (){
        //                 //     Navigator.pushNamed(context, "/sensorsScreen",
        //                 //         arguments:DeviceManageArguments(args.imei));
        //                 //   },
        //                 //   mini: true,
        //                 //   materialTapTargetSize: MaterialTapTargetSize.padded,
        //                 //   backgroundColor: Colors.white,
        //                 //   foregroundColor: MyColor.primaryColor,
        //                 //   child: const Icon(Icons.sensors_sharp, size: 30.0),
        //                 // ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),




      ],
    );
  }


  Widget _showStatusPopup(double boxImageSize) {
    double imageSize = MediaQuery.of(context).size.width / 25;
    return (_statusbarLoading)?Positioned(
      bottom: 20,
      right: 10,
      left: 10,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),

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
                //margin: EdgeInsets.fromLTRB(12, 6, 12, 6),

                child: Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(12, 6, 12, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child:  Container(
                                      // margin: EdgeInsets.only(top: 5),
                                      child: Text(''+StaticVarMethod.imei,
                                          style: TextStyle(
                                              fontSize: 10,
                                              //height: 0.8,
                                              // fontFamily: 'digital_font'
                                              fontWeight: FontWeight.bold
                                          )),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child:                Container(

                                      child: GestureDetector(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                if(_statusbarLoading){
                                                  _statusbarLoading = false;
                                                }else{
                                                  _statusbarLoading = true;
                                                }

                                              });
                                            }
                                            // Fluttertoast.showToast(msg: 'Down', toastLength: Toast.LENGTH_SHORT);

                                          },
                                          child: Icon(Icons.arrow_drop_down_sharp,
                                              color: _mainColor, size: 40.0)

                                      ),
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child:  Container(
                                      // margin: EdgeInsets.only(top: 5),
                                      child: Text( (speedo! > 0)
                                          ? 'Moving '+fstopDuration
                                          : 'Stop '+fstopDuration,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: (speedo! >0)? Colors.green:Colors.grey,
                                              //height: 0.8,
                                              // fontFamily: 'digital_font'
                                              fontWeight: FontWeight.bold
                                          )),
                                    ),
                                  )
                                ],
                              )
                          )
                      ),

                    ]
                ),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 5),
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
                                  child: Column(children: <Widget>[
                                    //Icon(Icons.engineering,size:imageSize),
                                    Image.asset("assets/sensorsicon/engineon.png",
                                        height: imageSize, width: imageSize),
                                    Text('Ignition',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY)),
                                    Text(
                                        (speedo! > 0)
                                            ? "On"
                                            : "Off",
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                  ])),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {},
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
                                  child: Column(children: <Widget>[
                                    Image.asset("assets/sensorsicon/locationon.png",
                                        height: imageSize, width: imageSize),
                                    Text('GPS',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY)),
                                    /*(productData.params?.gpslev != null)
                                        ? Text('${productData.params!.gpslev}',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                        :*/ Text('NaN',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                  ])),
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
                                  child: Column(children: <Widget>[
                                    Image.asset(
                                        "assets/sensorsicon/speedometeron.png",
                                        height: imageSize,
                                        width: imageSize),
                                    Text('Odometer',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY)),
                                    Text('' + ftotalDistance + " km",
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                  ])),
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
                                  child: Column(children: <Widget>[
                                    Image.asset(
                                        "assets/sensorsicon/connectedon.png",
                                        height: imageSize,
                                        width: imageSize),
                                    Text('GSM Level',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY)),
                                    /* (productData.params?.gpslev != null)
                                        ? Text('${productData.params!.gpslev}',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                        :*/ Text('NaN',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                  ])),
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
                                  child: Column(children: <Widget>[
                                    Image.asset("assets/sensorsicon/hour24on.png",
                                        height: imageSize, width: imageSize),
                                    Text('Eng Hour',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY)),
                                    Text('' /*+ productData.engineHours.toString()*/,
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1,
                                            color: SOFT_GREY))
                                  ])),
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
                                  child: Column(children: <Widget>[
                                    Image.asset("assets/sensorsicon/batteryon.png",
                                        height: imageSize, width: imageSize),
                                    Text('Battery',
                                        style: TextStyle(
                                            fontSize: 7,
                                            height: 1.5,
                                            color: SOFT_GREY))
                                  ])),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              /* Container(
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
                                                  *//*Icon(Icons.location_on,
                                                      color: Colors.blue, size: 12),*//*
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
                                            *//* Text(
                                              '_productData[index].name',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.blue
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),*//*
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Text(''+ftotalDistance,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'digital_font'
                                                  )),
                                            ),
                                            *//*  Container(
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
                                            ),*//*
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                          )
                      ),

                    ]
                ),
              ),*/

              Container(
                  decoration: new BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.rectangle,
                    borderRadius:BorderRadius.only(bottomLeft:Radius.circular(15),bottomRight:Radius.circular(15)),
                    // borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        //blurRadius: 10.0,
                        //offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child:
                  GestureDetector(
                      onTap: () async {

                        final url ='https://www.google.com/maps/search/?api=1&query=${lati},${lngi}';
                        /*    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                      } else {
                      throw 'Could not launch $url';
                      }*/
                        // address = "Loading....";
                        //setState(() {});
                        //getAddress(lati,lngi);\

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Browser(
                                  dashboardName: "Location",
                                  dashboardURL: url,
                                )));
                      },
                      child: new Row(children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.only(left: 5.0),

                            child: Icon(Icons.location_on_outlined,
                                color: CustomColor.primaryColor, size: 22.0)),
                        Padding(padding: new EdgeInsets.fromLTRB(5, 0, 0, 0)),

                        Flexible(
                          child: new Container(
                            padding: new EdgeInsets.only(right: 13.0),
                            child: new Text(
                              address,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        /* Expanded(
                          child: Text(address,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.blue),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis))*/
                      ]))
              ),

            ],
          ),
        ),
      ),
    ):_showvehiclestatus();


  }

  Widget _showvehiclestatus() {

    return Positioned(
      bottom: 30,
      right: 0,
      left: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 40),

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
                //margin: EdgeInsets.fromLTRB(6, 10, 6, 1),
                  padding:EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: GestureDetector(
                      onTap: () {

                        setState(() {
                          if(_statusbarLoading){
                            _statusbarLoading= false;
                          }else{
                            _statusbarLoading= true;
                          }

                        });
                        Fluttertoast.showToast(msg: 'Up', toastLength: Toast.LENGTH_SHORT);

                      },
                      child: Icon(Icons.arrow_circle_up,
                          color: _mainColor, size: 40.0)

                  )
              ),


            ],
          ),
        ),
      ),
    );




  }
  Widget _showStatusPopup1() {

    var devicelist= devicesList.where((i) => i.deviceData!.imei!.contains(StaticVarMethod.imei)).single;

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 0),

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
                                borderRadius: BorderRadius.circular(0),
                              ),
                              elevation: 0,
                              color: Colors.white,
                              child: Container(
                                //margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                          child: Image.asset("assets/images/Address.png", height: 25,width: 25)),

                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20,right: 25,top: 5,bottom: 15),

                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  address = "Loading....";
                                                 // setState(() {});
                                                  getAddress(lati,lngi);
                                                },
                                                child:
                                                RichText(
                                                  maxLines: 5,
                                                  //textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                      text:address,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xff8E8E8E),
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


              (devicelist.sensors!.isNotEmpty)?
              Container(

                  height:(devicelist.sensors!.length>5)? 150:90,

                  child:  GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    primary: false,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 8,
                    crossAxisCount: 5,
                    children: List.generate( devicelist.sensors!.length, (int index) {
                      return GridItem(devicelist.sensors![index]);

                    }),
                  )
              ): Center(

                child:  Container(
                    margin: EdgeInsets.fromLTRB(20, 6, 1, 6),
                    height: 50,
                    width: 45,
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0,
                          offset:  Offset(0.5, 4.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0,0 ),
                          child:ClipRRect(
                              child: Image.asset("assets/sensorsicon/engineon.png", height: 13,width: 13,
                                color: Color(0xff0D3D65),)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: Text('Ignition',
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff0D3D65),
                                  ),),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Text((speedo! > 0)?'ON':'OFF',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff0D3D65),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),

            ],
          ),
        ),
      ),
    );




  }

  Widget GridItem(Sensors model){
    return Container(
        padding: EdgeInsets.all(8),
        decoration:  BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset:  Offset(0.5, 4.0),
            ),
          ],
        ),
        child:   Column(
            children: <Widget>[

              model.type
                  .toString()
                  .toLowerCase() ==
                  'ignition'
                  ? Image.asset("assets/sensorsicon/engineon.png",  height: 16,color: themeDark,)
                  : model.type
                  .toString()
                  .toLowerCase() ==
                  'odometer'
                  ? Image.asset("assets/sensorsicon/speedometeron.png",height: 16)
                  : model.type
                  .toString()
                  .toLowerCase() ==
                  'battery'
                  ? Icon(
                FontAwesomeIcons.batteryFull, size: 16,color:themeDark,) :

              model.type
                  .toString()
                  .toLowerCase() ==
                  'charge'
                  ? Icon(
                Icons.battery_charging_full, size: 16,color:themeDark,)
                  : model.type
                  .toString()
                  .toLowerCase() ==
                  'engine lock'
                  ? Icon(
                Icons.hourglass_bottom_rounded, size: 16,color:themeDark,) :
              model.type
                  .toString()
                  .toLowerCase() ==
                  'gps'
                  ? Icon(
                Icons.gps_fixed_outlined, size: 16,color:themeDark,) :
              model.type
                  .toString()
                  .toLowerCase() ==
                  'gsm'
                  ? Image.asset("assets/sensorsicon/connectedon.png",height: 16,color: themeDark,):
              model.type
                  .toString()
                  .toLowerCase() ==
                  'moving'
                  ? Icon(Icons.moving_outlined, size: 16,color:themeDark,) :
              model.type
                  .toString()
                  .toLowerCase() ==
                  'gps starting km'
                  ? Icon(
                Icons.gps_fixed_outlined, size: 16,color:themeDark,) :

              model.type
                  .toString()
                  .toLowerCase() ==
                  'temp'
                  ? Icon(
                FontAwesomeIcons.temperatureLow, size: 16,color:themeDark,)
                  : model.type
                  .toString()
                  .toLowerCase() ==
                  'engine_hours'
                  ? Icon(Icons.alarm, size: 16,color:themeDark,)
                  : Icon(Icons.charging_station, size: 16,color:themeDark,),
              //Icon(Icons.engineering,size:imageSize),
              // Image.asset("assets/sensorsicon/engineon.png", height: imageSize,width: imageSize),
              Text(model.name.toString(),  style: TextStyle(
                  fontSize: 6,height: 1.5, color: themeDark)),
              Text("${model.value.toString()}",  style: TextStyle(
                  fontSize: 7,height: 1, color: themeDark))
            ]
        )
    );
  }
}
