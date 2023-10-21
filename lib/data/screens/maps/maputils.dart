import 'package:flutter/animation.dart';
import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
LatLng? oldLatLng;
bool isCarAnimating = false;

onLocationChange(String latLng) async {
  currentLatLng = LatLng(
      double.parse(latLng.split(',')[0]), double.parse(latLng.split(',')[1]));

  if (cabMarkerSymbol != null && !isCarAnimating)
    _animateCabIcon(oldLatLng!, currentLatLng!);
}

_animateCabIcon(LatLng start, LatLng end) async {
  try {
    AnimationController controller =
    AnimationController(vsync: this, duration: Duration(seconds: 3));
    Animation animation;
    var tween = Tween<double>(begin: 0, end: 1);
    animation = tween.animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        oldLatLng = end;
        isCarAnimating = false;
      } else if (status == AnimationStatus.forward) {
        isCarAnimating = true;
      }
    });
    controller.forward();
    var bearing = getBearing(start, end);

    animation.addListener(() async {
      var v = animation.value;
      var lng = v * end.longitude + (1 - v) * start.longitude;
      var lat = v * end.latitude + (1 - v) * start.latitude;

      var latLng = LatLng(lat, lng);

      var carSymbolOptions = SymbolOptions(
        geometry: latLng,
        iconRotate: bearing,
      );
      await _completer.future
          .then((map) => map.updateSymbol(carMarkerSymbol!, carSymbolOptions));
    });
  } catch (e) {
    print(e);
  }
}

double getBearing(LatLng start, LatLng end) {
  var lat1 = start.latitude * math.pi / 180;
  var lng1 = start.longitude * math.pi / 180;
  var lat2 = end.latitude * math.pi / 180;
  var lng2 = end.longitude * math.pi / 180;

  var dLon = (lng2 - lng1);
  var y = math.sin(dLon) * math.cos(lat2);
  var x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  var bearing = math.atan2(y, x);
  bearing = (bearing * 180) / math.pi;
  bearing = (bearing + 360) % 360;

  return bearing;
}*/
