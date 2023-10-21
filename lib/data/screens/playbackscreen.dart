import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
/*import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';*/
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maktrogps/config/apps/ecommerce/global_style.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:maktrogps/data/model/history.dart';

import 'package:maktrogps/mapconfig/CommonMethod.dart';
import 'package:maktrogps/mapconfig/CustomColor.dart';


class PlaybackPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PlaybackPageState1();
}

class _PlaybackPageState1 extends State<PlaybackPage1> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  bool _isPlaying = false;
  var _isPlayingIcon = Icons.pause_circle_outline;
  bool _trafficEnabled = false;
  MapType _currentMapType = MapType.normal;
  Color _trafficButtonColor = CustomColor.primaryColor;
  Set<Marker> _markers = Set<Marker>();
  double currentZoom = 10.0;
  late StreamController<AllItems> _postsController;
  late Timer _timer;
  late Timer timerPlayBack;
  //static ReportArguments args;
  List<AllItems> routeList = [];
  late bool isLoading;
  double pinPillPosition = 0;

  int _sliderValue = 0;
  int _sliderValueMax = 0;
  int playbackTime = 200;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  List<Choice> choices = [];
  var _fromdate;
  late List<AllItems> _allItemsData;
  String _val2 = '';
  late Choice _selectedChoice; // The app's "state".

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });

    if (_selectedChoice.title =='slow') {
      playbackTime = 400;
      timerPlayBack.cancel();
      playRoute();
    } else if (_selectedChoice.title =='medium') {
      playbackTime = 200;
      timerPlayBack.cancel();
      playRoute();
    } else if (_selectedChoice.title =='fast') {
      playbackTime = 100;
      timerPlayBack.cancel();
      playRoute();
    }
  }

  var todaydate= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  var yesterdaydate= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-1);


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
  initState() {
    _postsController = new StreamController();
    getReport();
    super.initState();
  }

  Timer interval(Duration duration, func) {
    Timer function() {
      Timer timer = new Timer(duration, function);

      func(timer);

      return timer;
    }

    return new Timer(duration, function);
  }

  void playRoute() async {
    var iconPath = "assets/images/direction.png";
    final Uint8List? icon = await getBytesFromAsset(iconPath, 50);
    interval(new Duration(milliseconds: playbackTime), (timer) {
      if (routeList.length != _sliderValue) {
        _sliderValue++;
      }
      timerPlayBack = timer;
      _markers = Set<Marker>();
      if (routeList.length - 1 == _sliderValue.toInt()) {
        timerPlayBack.cancel();
      } else if (routeList.length != _sliderValue.toInt()) {
        moveCamera(routeList[_sliderValue.toInt()]);
        _markers.add(
          Marker(
            markerId:
            MarkerId(routeList[_sliderValue.toInt()].id.toString()),
            position: LatLng(routeList[_sliderValue.toInt()].latitude!.toDouble(),
                routeList[_sliderValue.toInt()].longitude!.toDouble()), // updated position
            rotation: routeList[_sliderValue.toInt()].course!.toDouble(),
            icon: BitmapDescriptor.fromBytes(icon!),
          ),
        );
        setState(() {});
      } else {
        timerPlayBack.cancel();
      }
    });
  }

  void playUsingSlider(int pos) async {
    var iconPath = "assets/images/direction.png";
    final Uint8List? icon = await getBytesFromAsset(iconPath, 80);
    _markers = Set<Marker>();
    if (routeList.length != _sliderValue.toInt()) {
      moveCamera(routeList[_sliderValue.toInt()]);
      _markers.add(
        Marker(
          markerId:
          MarkerId(routeList[_sliderValue.toInt()].deviceId.toString()),
          position: LatLng(routeList[_sliderValue.toInt()].latitude  as double,
              routeList[_sliderValue.toInt()].longitude  as double), // updated position
          rotation: routeList[_sliderValue.toInt()].course as double,
          icon: BitmapDescriptor.fromBytes(icon!),
        ),
      );
      setState(() {});
    }
  }

  void moveCamera(AllItems pos) async {
    CameraPosition cPosition = CameraPosition(
      target: LatLng(pos.latitude  as double, pos.longitude  as double),
      zoom: currentZoom,
    );

    if (isLoading) {
      _showProgress(false);
    }
    isLoading = false;
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  Future<void> getReport() async{
    // _timer = new Timer.periodic(Duration(milliseconds: 1000), (timer)  {
    //  _timer.cancel();

    gpsapis api=new gpsapis();
    var hash=StaticVarMethod.user_api_hash;
    _allItemsData =await api.getHistoryAllList(hash);
    if (_allItemsData.isNotEmpty) {
      routeList.addAll(_allItemsData);
      _allItemsData.forEach((element) {
        if(element.latitude != 0 || element.latitude !=null){
          _postsController.add(element);
          polylineCoordinates
              .add(LatLng(element.latitude as double, element.longitude as double));
        }

      });
      _sliderValueMax = polylineCoordinates.length;
      //playRoute();
      setState(() {});
      drawPolyline();
    }
    else
    {
      if (isLoading)
      {
        _showProgress(false);
        isLoading = false;
      }
      AlertDialogCustom().showAlertDialog(
          context,
          'noData',
          'failed',
          'ok');
    }
    // });
  }

  void drawPolyline() async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        width: 2,
        polylineId: id,
        color: Colors.pinkAccent,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
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
      _trafficEnabled == false ? CustomColor.primaryColor : Colors.green;
    });
  }

  void _playPausePressed() {
    setState(() {
      _isPlaying = _isPlaying == false ? true : false;
      if (_isPlaying) {
        timerPlayBack.cancel();
      } else {
        playRoute();
      }
      _isPlayingIcon = _isPlaying == false
          ? Icons.pause_circle_outline
          : Icons.play_circle_outline;
    });
  }

  currentMapStatus(CameraPosition position) {
    currentZoom = position.zoom;
  }

  @override
  void dispose() {
    if (timerPlayBack != null) {
      if (timerPlayBack.isActive) {
        timerPlayBack.cancel();
      }
    }
    super.dispose();
  }

  static final CameraPosition _initialRegion = CameraPosition(
    target: LatLng(0, 0),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    //args = ModalRoute.of(context).settings.arguments;
    choices = <Choice>[
      Choice(
          title: 'slow',
          icon: Icons.directions_car),
      Choice(
          title: 'medium',
          icon: Icons.directions_bike),
      Choice(
          title: 'fast',
          icon: Icons.directions_boat),
    ];
    _selectedChoice = choices[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(''+StaticVarMethod.deviceName,
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          // action button
          PopupMenuButton<Choice>(
            onSelected: _select,
            icon: Icon(Icons.timer),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
          IconButton(
              icon: Icon(Icons.date_range, color: Colors.black),
              onPressed: () {

                showReportDialog(context,"",67);
               /* showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _datepickerDialog();
                  },
                );*/
                //_datepickerDialog(context);
              }),
          /*   GestureDetector(
              //behavior: HitTestBehavior.translucent,

              onTap: (){
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _datepickerDialog();
                  },
                );
              },

              child:Icon(Icons.info_outline, color: Colors.black)
          ),*/

        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          mapType: _currentMapType,
          initialCameraPosition: _initialRegion,
          onCameraMove: currentMapStatus,
          trafficEnabled: _trafficEnabled,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            CustomProgressIndicatorWidget().showProgressDialog(context,
                'Loading ....');
            isLoading = true;
          },
          markers: _markers,
          polylines: Set<Polyline>.of(polylines.values),
        ),
//            TrackMapPinPillComponent(
//                pinPillPosition: pinPillPosition,
//                currentlySelectedPin: currentlySelectedPin
//            ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _onMapTypeButtonPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.map, size: 20.0,color: Colors.black),
                  mini: true,
                ),
                FloatingActionButton.small(
                  heroTag: "traffic",
                  onPressed: _trafficEnabledPressed,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.traffic, size: 20.0,color: Colors.black),

                ),
              ],
            ),
          ),
        ),
        playBackControls(),
      ]),
    );
  }



  Widget _datepickerDialog(){
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
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Text('Playback History', style: GlobalStyle.chooseCourier),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // This goes to the build method
                      RadioListTile(
                        value: 'today',
                        groupValue: _val2,
                        title: Text("Today"),
                        subtitle: Text(""+DateFormat('yyyy-MM-dd').format(todaydate)+""),
                        onChanged: (String? value) {
                          StaticVarMethod.fromdate=DateFormat('yyyy-MM-dd').format(todaydate);
                          StaticVarMethod.fromtime="00:00";
                          StaticVarMethod.todate=DateFormat('yyyy-MM-dd').format(todaydate);
                          StaticVarMethod.totime=DateFormat('HH:mm').format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour, DateTime.now().minute));
                           getReport();
                          setState(() {
                            _val2 = value!;
                          });
                        },
                        activeColor: Colors.red,
                        secondary: OutlinedButton(
                            onPressed: () {
                              print("Go");
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'GO',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),
                      ),
                      RadioListTile(
                        value: 'Yesterday',
                        groupValue: _val2,
                        title: Text("Yesterday"),
                        subtitle: Text(""+DateFormat('yyyy-MM-dd').format(yesterdaydate)+""),
                        onChanged: (String? value) {

                          StaticVarMethod.fromdate=DateFormat('yyyy-MM-dd').format(yesterdaydate);
                          StaticVarMethod.fromtime="00:00";
                          StaticVarMethod.todate=DateFormat('yyyy-MM-dd').format(yesterdaydate);
                          StaticVarMethod.totime=DateFormat('HH:mm').format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour, DateTime.now().minute));


                          setState(() {
                            getReport();
                            _val2 = value!;
                          });
                        },
                        activeColor: Colors.red,
                        secondary: OutlinedButton(
                            onPressed: () {
                              print("GO");
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'Go',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),
                      ),
                      RadioListTile(
                        value: 'hours',
                        groupValue: _val2,
                        title: Text("1 hours Ago"),
                         subtitle: Text(""+DateFormat('HH:mm').format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour-1, DateTime.now().minute))),
                        onChanged: (String? value) {
                          setState(() {
                            _val2 = value!;
                          });
                        },
                        activeColor: Colors.red,
                        secondary: OutlinedButton(
                            onPressed: () {
                              print("Go");
                            },
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    )
                                ),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.0
                                  ),
                                )
                            ),
                            child: Text(
                              'GO',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.center,
                            )
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 32,
                  color: Colors.grey[400],
                ),
                Text('Custom DateTime', style: GlobalStyle.courierTitle),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      // _delivery = 'Other 1 Regular';
                      // _deliveryPrice = 9;
                    });
                    // countSubTotal();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                             /* DatePicker.showDateTimePicker(context, showTitleActions: true,
                                  onChanged: (date) {
                                    print('change $date in time zone ' +
                                        date.timeZoneOffset.inHours.toString());
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                  }, currentTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,  DateTime.now().minute, DateTime.now().second));*/
                            },
                            child: Text(
                              'From date',
                              style: TextStyle(color: Colors.blue),
                            )),
                        Text('\$9', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      //_delivery = 'Other 1 Express';
                      //_deliveryPrice = 17;
                    });
                    // countSubTotal();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                             /* DatePicker.showDateTimePicker(context, showTitleActions: true,
                                  onChanged: (date) {
                                    setState(() {
                                      _fromdate.toString();
                                    });
                                    print('change $date in time zone ' +
                                        date.timeZoneOffset.inHours.toString());
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                    setState(() {
                                      _fromdate.toString();
                                    });
                                    ondatechange(date.toString());

                                  }, currentTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,  DateTime.now().minute, DateTime.now().second));*/
                            },
                            child: Text(
                              'To Date',
                              style: TextStyle(color: Colors.blue),
                            )),
                        Text(_fromdate.toString(), style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 32,
                  color: Colors.grey[400],
                ),
                Text('Other 2', style: GlobalStyle.courierTitle),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    setState(() {
                      //_delivery = 'Other 2 Regular';
                      //_deliveryPrice = 9;
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
                        Text('\$9', style: GlobalStyle.deliveryPrice),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 32,
                  color: Colors.grey[400],
                ),

              ],
            ),
          ),
        ],
      );
    });
  }

  void ondatechange(String date){
      _fromdate=date;
  }
  /*void _datepickerDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[


                      Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 20,
                            )),
                      ),
                    ]


                ),


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/app_icon.png', width: MediaQuery.of(context).size.width/10),
                      Container(
                        transform: Matrix4.translationValues(0.0, -MediaQuery.of(context).size.width/26, 0.0),
                        child: Text('v', style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        )),
                      ),
                      Text(
                        'DevKit developed and designed for Developer using Flutter. It contains many ready to used Screens, Widgets, Features, Functions, Integrations and Animations for iOS and Android devices.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      // _launchInBrowser('https://1.envato.market/kj4MrM');
                    },
                    child: Text(
                        'Our Portfolio',
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)
                    ),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      //_launchInBrowser('https://1.envato.market/QVNqa');
                    },
                    child: Text(
                      'Purchase Source Code',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }*/
  Widget playBackControls() {
    String fUpdateTime ='Loading ...';
    String speed = 'Loading ..';
    if (routeList.length > _sliderValue.toInt()) {
      fUpdateTime = formatTime(routeList[_sliderValue.toInt()].rawTime.toString());
      speed = routeList[_sliderValue.toInt()].speed.toString();
    }

    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 30),

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

              new Container(
                margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.radio_button_checked,
                          color: Colors.black, size: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Speed' +
                          ": " +
                          speed),
                    ),
                  ],
                ),
              ),
              _sliderValue.toInt() > 0
                  ? routeList[_sliderValue.toInt()].longitude != null
                  ? Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Icon(Icons.location_on_outlined,
                        color: Colors.black, size: 25.0),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 5.0, right: 0),
                              child: Text(
                                utf8.decode(utf8.encode(
                                    routeList[_sliderValue.toInt()]
                                        .latitude.toString())),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ]),
                  )
                ],
              )
                  : new Container()
                  : new Container(),
              new Container(
                margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Icon(Icons.av_timer,
                          color: Colors.black, size: 20.0),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Update' +
                          ": " +
                          fUpdateTime),
                    ),
                  ],
                ),
              ),
              new Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 5.0, left: 5.0),
                          child: InkWell(
                            child: Icon(_isPlayingIcon,
                                color: Colors.black, size: 40.0),
                            onTap: () {
                              _playPausePressed();
                            },
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 5.0, left: 0.0),
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Slider(
                            value: _sliderValue.toDouble(),
                            onChanged: (newSliderValue) {
                              setState(
                                      () => _sliderValue = newSliderValue.toInt());
                              if (timerPlayBack != null) {
                                if (!timerPlayBack.isActive) {
                                  playUsingSlider(newSliderValue.toInt());
                                }
                              }
                            },
                            min: 0,
                            max: _sliderValueMax.toDouble(),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _showProgress(bool status) {
    if (status) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: [
                CircularProgressIndicator(),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text('Loading..')),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }



  void showReportDialog(BuildContext context, String heading,   final device) {
    Dialog simpleDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 0,
                                  groupValue: _selectedperiod,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedperiod = value!;
                                      _dialogHeight = 300.0;
                                    });
                                  },
                                ),
                                new Text('Today'
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _selectedperiod,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedperiod = value!;
                                      _dialogHeight = 300.0;
                                    });
                                  },
                                ),
                                new Text('Yesterday'
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 2,
                                  groupValue: _selectedperiod,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedperiod = value!;
                                      _dialogHeight = 300.0;
                                    });
                                  },
                                ),
                                new Text('ThisWeek'
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: 3,
                                  groupValue: _selectedperiod,
                                  onChanged: (value) {
                                    setState(() {
                                      _dialogHeight = 400.0;
                                      _selectedperiod = value!;
                                    });
                                  },
                                ),
                                new Text('Custom',
                                ),
                              ],
                            ),
                            _selectedperiod == 3
                                ? new Container(
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
                                          child: Text(
                                              formatReportTime(
                                                  selectedFromTime),
                                              style: TextStyle(
                                                backgroundColor: Colors.blue,
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
                                : new Container(),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ElevatedButton(
                                  // color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('cancel'
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  // color: CustomColor.primaryColor,
                                  onPressed: () {
                                    //showReport(heading,  device);
                                  },
                                  child: Text('ok'
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => simpleDialog);
  }


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
  void showReport(String heading,  final device) {
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

    if (_selectedperiod == 0) {
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
    } else if (_selectedperiod == 1) {
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
    } else if (_selectedperiod == 2) {
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
    }

    print(fromDate);
    print(toDate);

    Navigator.pop(context);
   /* Navigator.pushNamed(context, "/reportList",
        arguments: ReportArguments(device['id'], fromDate, fromTime,
            toDate, toTime, device["name"], 0));*/

  }
}

class CustomProgressIndicatorWidget {
  showProgressDialog(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text(message)),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class AlertDialogCustom {
// showAlertDialog(BuildContext context, String message, String heading,
//      String buttonAcceptTitle, String buttonCancelTitle) {
//    // set up the buttons
//    Widget cancelButton = FlatButton(
//      child: Text(buttonCancelTitle),
//      onPressed: () {},
//    );
//    Widget continueButton = FlatButton(
//      child: Text(buttonAcceptTitle),
//      onPressed: () {
//
//      },
//    );
//
//    // set up the AlertDialog
//    AlertDialog alert = AlertDialog(
//      title: Text(heading),
//      content: Text(message),
//      actions: [
//        cancelButton,
//      ],
//    );
//
//    // show the dialog
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return alert;
//      },
//    );
//  }
  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text(buttonAcceptTitle),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      actions: [
        okButton,
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




}




/*class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}*/
