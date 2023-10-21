import 'dart:collection';

import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/datasources.dart';
import 'package:flutter/material.dart';

import '../../data/model/devices.dart';

class ObjectStore extends ChangeNotifier {
  List<deviceItems> _objects = [];
  // Map<String, dynamic> _objectSettings = HashMap();
  // Map<String, DriverData> _drivers = HashMap();

  int get count => _objects.length;
  List<deviceItems> get objects => _objects;
  // Map<String, DriverData> get drivers => _drivers;
  // Map<String, dynamic> get objectSettings => _objectSettings;
  bool isLoading = true;

  void getObjects() async{
    isLoading = true;
    _objects = (await gpsapis.getDevicesList(StaticVarMethod.user_api_hash));
    isLoading = false;
    notifyListeners();
  }

  // void getObjectSettings() async{
  //   isLoading = true;
  //   _objectSettings = (await API.getObjectSettings());
  //   isLoading = false;
  //   notifyListeners();
  // }
  //
  // void getObjectDriver() async{
  //   isLoading = true;
  //   _drivers = (await API.loadDriverData());
  //   isLoading = false;
  //   notifyListeners();
  // }

}