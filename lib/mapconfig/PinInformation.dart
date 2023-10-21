import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maktrogps/data/model/devices.dart';

class PinInformation {
  String pinPath;
  String avatarPath;
  String address;
  String updatedTime;
  LatLng location;
  String status;
  String name;
  String speed;
  Color labelColor;
  bool ignition;
  String batteryLevel;
  bool charging;
  num? deviceId;
  bool blocked;
  String calcTotalDist;


  PinInformation(
      {required this.pinPath,
        required this.avatarPath,
        required this.address,
        required this.updatedTime,
        required this.location,
        required this.status,
        required this.name,
        required this.speed,
        required this.labelColor,
        required this.batteryLevel,
        required this.ignition,
        required this.charging,
        required this.deviceId,
        required this.blocked,
        required this.calcTotalDist
        });
}
