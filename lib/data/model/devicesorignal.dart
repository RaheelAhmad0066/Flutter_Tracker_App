/// id : 29
/// title : "test"
/// items : [{"id":27,"alarm":0,"name":"Bathnaha O.P., BR38F 1217","online":"offline","time":"27-08-2022 20:48:53","timestamp":1661614106,"acktimestamp":1661613533,"lat":26.344027,"lng":87.236347,"course":327,"speed":0,"altitude":0,"icon_type":"rotating","icon_color":"red","icon_colors":{"moving":"green","stopped":"yellow","offline":"red","engine":"orange"},"icon":{"id":93,"user_id":null,"type":"rotating","order":null,"width":21,"height":40,"path":"images/device_icons/62c1bd554da5c0.24482325_offline.png","by_status":1},"power":"-","address":"-","protocol":"gt06","driver":"-","driver_data":{"id":null,"user_id":null,"device_id":null,"name":null,"rfid":null,"phone":null,"email":null,"description":null,"created_at":null,"updated_at":null},"sensors":[{"id":1276,"type":"acc","name":"Vehicle","show_in_popup":0,"value":"On","val":true,"scale_value":null},{"id":1277,"type":"engine","name":"GPS Power","show_in_popup":0,"value":"On","val":true,"scale_value":null},{"id":1278,"type":"gsm","name":"SIM Network","show_in_popup":0,"value":"52 %","val":"52.00","scale_value":3},{"id":1279,"type":"satellites","name":"Satellites","show_in_popup":0,"value":"70 %","val":"70","scale_value":null}],"services":[],"tail":[{"lat":"26.343915","lng":"87.236765"},{"lat":"26.34321","lng":"87.236946666667"},{"lat":"26.34241","lng":"87.237291666667"},{"lat":"26.34322","lng":"87.236751666667"},{"lat":"26.344026666667","lng":"87.236346666667"}],"distance_unit_hour":"kph","unit_of_distance":"km","unit_of_altitude":"mt","unit_of_capacity":"lt","ignition_duration":"64d 19h 22min 4s","idle_duration":"64d 19h 18min 21s","stop_duration":"64d 19h 18min 21s","moved_timestamp":1661594304,"engine_status":null,"detect_engine":"gps","engine_hours":"gps","total_distance":14429.64,"device_data":{"id":27,"user_id":28,"active":1,"deleted":0,"name":"Bathnaha O.P., BR38F 1217","imei":"860465040146015","fuel_quantity":"0.00","fuel_price":"0.00","fuel_per_km":"0.00","sim_number":"5754170407208","device_model":"bita","expiration_date":null}}]

class Devicesorignal {
  Devicesorignal({
      num? id, 
      String? title, 
      List<Items>? items,}){
    _id = id;
    _title = title;
    _items = items;
}

  Devicesorignal.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  num? _id;
  String? _title;
  List<Items>? _items;

  num? get id => _id;
  String? get title => _title;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 27
/// alarm : 0
/// name : "Bathnaha O.P., BR38F 1217"
/// online : "offline"
/// time : "27-08-2022 20:48:53"
/// timestamp : 1661614106
/// acktimestamp : 1661613533
/// lat : 26.344027
/// lng : 87.236347
/// course : 327
/// speed : 0
/// altitude : 0
/// icon_type : "rotating"
/// icon_color : "red"
/// icon_colors : {"moving":"green","stopped":"yellow","offline":"red","engine":"orange"}
/// icon : {"id":93,"user_id":null,"type":"rotating","order":null,"width":21,"height":40,"path":"images/device_icons/62c1bd554da5c0.24482325_offline.png","by_status":1}
/// power : "-"
/// address : "-"
/// protocol : "gt06"
/// driver : "-"
/// driver_data : {"id":null,"user_id":null,"device_id":null,"name":null,"rfid":null,"phone":null,"email":null,"description":null,"created_at":null,"updated_at":null}
/// sensors : [{"id":1276,"type":"acc","name":"Vehicle","show_in_popup":0,"value":"On","val":true,"scale_value":null},{"id":1277,"type":"engine","name":"GPS Power","show_in_popup":0,"value":"On","val":true,"scale_value":null},{"id":1278,"type":"gsm","name":"SIM Network","show_in_popup":0,"value":"52 %","val":"52.00","scale_value":3},{"id":1279,"type":"satellites","name":"Satellites","show_in_popup":0,"value":"70 %","val":"70","scale_value":null}]
/// services : []
/// tail : [{"lat":"26.343915","lng":"87.236765"},{"lat":"26.34321","lng":"87.236946666667"},{"lat":"26.34241","lng":"87.237291666667"},{"lat":"26.34322","lng":"87.236751666667"},{"lat":"26.344026666667","lng":"87.236346666667"}]
/// distance_unit_hour : "kph"
/// unit_of_distance : "km"
/// unit_of_altitude : "mt"
/// unit_of_capacity : "lt"
/// ignition_duration : "64d 19h 22min 4s"
/// idle_duration : "64d 19h 18min 21s"
/// stop_duration : "64d 19h 18min 21s"
/// moved_timestamp : 1661594304
/// engine_status : null
/// detect_engine : "gps"
/// engine_hours : "gps"
/// total_distance : 14429.64
/// device_data : {"id":27,"user_id":28,"active":1,"deleted":0,"name":"Bathnaha O.P., BR38F 1217","imei":"860465040146015","fuel_quantity":"0.00","fuel_price":"0.00","fuel_per_km":"0.00","sim_number":"5754170407208","device_model":"bita","expiration_date":null}

class Items {
  Items({
      num? id, 
      num? alarm, 
      String? name, 
      String? online, 
      String? time, 
      num? timestamp, 
      num? acktimestamp, 
      num? lat, 
      num? lng, 
      num? course, 
      num? speed, 
      num? altitude, 
      String? iconType, 
      String? iconColor, 
      IconColors? iconColors, 
      Icon? icon, 
      String? power, 
      String? address, 
      String? protocol, 
      String? driver, 
      DriverData? driverData, 
      List<Sensors>? sensors, 
      List<dynamic>? services, 
      List<Tail>? tail, 
      String? distanceUnitHour, 
      String? unitOfDistance, 
      String? unitOfAltitude, 
      String? unitOfCapacity, 
      String? ignitionDuration, 
      String? idleDuration, 
      String? stopDuration, 
      num? movedTimestamp, 
      dynamic engineStatus, 
      String? detectEngine, 
      String? engineHours, 
      num? totalDistance, 
      DeviceData? deviceData,}){
    _id = id;
    _alarm = alarm;
    _name = name;
    _online = online;
    _time = time;
    _timestamp = timestamp;
    _acktimestamp = acktimestamp;
    _lat = lat;
    _lng = lng;
    _course = course;
    _speed = speed;
    _altitude = altitude;
    _iconType = iconType;
    _iconColor = iconColor;
    _iconColors = iconColors;
    _icon = icon;
    _power = power;
    _address = address;
    _protocol = protocol;
    _driver = driver;
    _driverData = driverData;
    _sensors = sensors;
    _services = services;
    _tail = tail;
    _distanceUnitHour = distanceUnitHour;
    _unitOfDistance = unitOfDistance;
    _unitOfAltitude = unitOfAltitude;
    _unitOfCapacity = unitOfCapacity;
    _ignitionDuration = ignitionDuration;
    _idleDuration = idleDuration;
    _stopDuration = stopDuration;
    _movedTimestamp = movedTimestamp;
    _engineStatus = engineStatus;
    _detectEngine = detectEngine;
    _engineHours = engineHours;
    _totalDistance = totalDistance;
    _deviceData = deviceData;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _alarm = json['alarm'];
    _name = json['name'];
    _online = json['online'];
    _time = json['time'];
    _timestamp = json['timestamp'];
    _acktimestamp = json['acktimestamp'];
    _lat = json['lat'];
    _lng = json['lng'];
    _course = json['course'];
    _speed = json['speed'];
    _altitude = json['altitude'];
    _iconType = json['icon_type'];
    _iconColor = json['icon_color'];
    _iconColors = json['icon_colors'] != null ? IconColors.fromJson(json['icon_colors']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _power = json['power'];
    _address = json['address'];
    _protocol = json['protocol'];
    _driver = json['driver'];
    _driverData = json['driver_data'] != null ? DriverData.fromJson(json['driver_data']) : null;
    if (json['sensors'] != null) {
      _sensors = [];
      json['sensors'].forEach((v) {
        _sensors?.add(Sensors.fromJson(v));
      });
    }
    if (json['services'] != null) {
      _services = [];
      json['services'].forEach((v) {
      //  _services?.add(Dynamic.fromJson(v));
      });
    }
    if (json['tail'] != null) {
      _tail = [];
      json['tail'].forEach((v) {
        _tail?.add(Tail.fromJson(v));
      });
    }
    _distanceUnitHour = json['distance_unit_hour'];
    _unitOfDistance = json['unit_of_distance'];
    _unitOfAltitude = json['unit_of_altitude'];
    _unitOfCapacity = json['unit_of_capacity'];
    _ignitionDuration = json['ignition_duration'];
    _idleDuration = json['idle_duration'];
    _stopDuration = json['stop_duration'];
    _movedTimestamp = json['moved_timestamp'];
    _engineStatus = json['engine_status'];
    _detectEngine = json['detect_engine'];
    _engineHours = json['engine_hours'];
    _totalDistance = json['total_distance'];
    _deviceData = json['device_data'] != null ? DeviceData.fromJson(json['device_data']) : null;
  }
  num? _id;
  num? _alarm;
  String? _name;
  String? _online;
  String? _time;
  num? _timestamp;
  num? _acktimestamp;
  num? _lat;
  num? _lng;
  num? _course;
  num? _speed;
  num? _altitude;
  String? _iconType;
  String? _iconColor;
  IconColors? _iconColors;
  Icon? _icon;
  String? _power;
  String? _address;
  String? _protocol;
  String? _driver;
  DriverData? _driverData;
  List<Sensors>? _sensors;
  List<dynamic>? _services;
  List<Tail>? _tail;
  String? _distanceUnitHour;
  String? _unitOfDistance;
  String? _unitOfAltitude;
  String? _unitOfCapacity;
  String? _ignitionDuration;
  String? _idleDuration;
  String? _stopDuration;
  num? _movedTimestamp;
  dynamic _engineStatus;
  String? _detectEngine;
  String? _engineHours;
  num? _totalDistance;
  DeviceData? _deviceData;

  num? get id => _id;
  num? get alarm => _alarm;
  String? get name => _name;
  String? get online => _online;
  String? get time => _time;
  num? get timestamp => _timestamp;
  num? get acktimestamp => _acktimestamp;
  num? get lat => _lat;
  num? get lng => _lng;
  num? get course => _course;
  num? get speed => _speed;
  num? get altitude => _altitude;
  String? get iconType => _iconType;
  String? get iconColor => _iconColor;
  IconColors? get iconColors => _iconColors;
  Icon? get icon => _icon;
  String? get power => _power;
  String? get address => _address;
  String? get protocol => _protocol;
  String? get driver => _driver;
  DriverData? get driverData => _driverData;
  List<Sensors>? get sensors => _sensors;
  List<dynamic>? get services => _services;
  List<Tail>? get tail => _tail;
  String? get distanceUnitHour => _distanceUnitHour;
  String? get unitOfDistance => _unitOfDistance;
  String? get unitOfAltitude => _unitOfAltitude;
  String? get unitOfCapacity => _unitOfCapacity;
  String? get ignitionDuration => _ignitionDuration;
  String? get idleDuration => _idleDuration;
  String? get stopDuration => _stopDuration;
  num? get movedTimestamp => _movedTimestamp;
  dynamic get engineStatus => _engineStatus;
  String? get detectEngine => _detectEngine;
  String? get engineHours => _engineHours;
  num? get totalDistance => _totalDistance;
  DeviceData? get deviceData => _deviceData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['alarm'] = _alarm;
    map['name'] = _name;
    map['online'] = _online;
    map['time'] = _time;
    map['timestamp'] = _timestamp;
    map['acktimestamp'] = _acktimestamp;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['course'] = _course;
    map['speed'] = _speed;
    map['altitude'] = _altitude;
    map['icon_type'] = _iconType;
    map['icon_color'] = _iconColor;
    if (_iconColors != null) {
      map['icon_colors'] = _iconColors?.toJson();
    }
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    map['power'] = _power;
    map['address'] = _address;
    map['protocol'] = _protocol;
    map['driver'] = _driver;
    if (_driverData != null) {
      map['driver_data'] = _driverData?.toJson();
    }
    if (_sensors != null) {
      map['sensors'] = _sensors?.map((v) => v.toJson()).toList();
    }
    if (_services != null) {
      map['services'] = _services?.map((v) => v.toJson()).toList();
    }
    if (_tail != null) {
      map['tail'] = _tail?.map((v) => v.toJson()).toList();
    }
    map['distance_unit_hour'] = _distanceUnitHour;
    map['unit_of_distance'] = _unitOfDistance;
    map['unit_of_altitude'] = _unitOfAltitude;
    map['unit_of_capacity'] = _unitOfCapacity;
    map['ignition_duration'] = _ignitionDuration;
    map['idle_duration'] = _idleDuration;
    map['stop_duration'] = _stopDuration;
    map['moved_timestamp'] = _movedTimestamp;
    map['engine_status'] = _engineStatus;
    map['detect_engine'] = _detectEngine;
    map['engine_hours'] = _engineHours;
    map['total_distance'] = _totalDistance;
    if (_deviceData != null) {
      map['device_data'] = _deviceData?.toJson();
    }
    return map;
  }

}

/// id : 27
/// user_id : 28
/// active : 1
/// deleted : 0
/// name : "Bathnaha O.P., BR38F 1217"
/// imei : "860465040146015"
/// fuel_quantity : "0.00"
/// fuel_price : "0.00"
/// fuel_per_km : "0.00"
/// sim_number : "5754170407208"
/// device_model : "bita"
/// expiration_date : null

class DeviceData {
  DeviceData({
      num? id, 
      num? userId, 
      num? active, 
      num? deleted, 
      String? name, 
      String? imei, 
      String? fuelQuantity, 
      String? fuelPrice, 
      String? fuelPerKm, 
      String? simNumber, 
      String? deviceModel, 
      dynamic expirationDate,}){
    _id = id;
    _userId = userId;
    _active = active;
    _deleted = deleted;
    _name = name;
    _imei = imei;
    _fuelQuantity = fuelQuantity;
    _fuelPrice = fuelPrice;
    _fuelPerKm = fuelPerKm;
    _simNumber = simNumber;
    _deviceModel = deviceModel;
    _expirationDate = expirationDate;
}

  DeviceData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _active = json['active'];
    _deleted = json['deleted'];
    _name = json['name'];
    _imei = json['imei'];
    _fuelQuantity = json['fuel_quantity'];
    _fuelPrice = json['fuel_price'];
    _fuelPerKm = json['fuel_per_km'];
    _simNumber = json['sim_number'];
    _deviceModel = json['device_model'];
    _expirationDate = json['expiration_date'];
  }
  num? _id;
  num? _userId;
  num? _active;
  num? _deleted;
  String? _name;
  String? _imei;
  String? _fuelQuantity;
  String? _fuelPrice;
  String? _fuelPerKm;
  String? _simNumber;
  String? _deviceModel;
  dynamic _expirationDate;

  num? get id => _id;
  num? get userId => _userId;
  num? get active => _active;
  num? get deleted => _deleted;
  String? get name => _name;
  String? get imei => _imei;
  String? get fuelQuantity => _fuelQuantity;
  String? get fuelPrice => _fuelPrice;
  String? get fuelPerKm => _fuelPerKm;
  String? get simNumber => _simNumber;
  String? get deviceModel => _deviceModel;
  dynamic get expirationDate => _expirationDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['active'] = _active;
    map['deleted'] = _deleted;
    map['name'] = _name;
    map['imei'] = _imei;
    map['fuel_quantity'] = _fuelQuantity;
    map['fuel_price'] = _fuelPrice;
    map['fuel_per_km'] = _fuelPerKm;
    map['sim_number'] = _simNumber;
    map['device_model'] = _deviceModel;
    map['expiration_date'] = _expirationDate;
    return map;
  }

}

/// lat : "26.343915"
/// lng : "87.236765"

class Tail {
  Tail({
      String? lat, 
      String? lng,}){
    _lat = lat;
    _lng = lng;
}

  Tail.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }
  String? _lat;
  String? _lng;

  String? get lat => _lat;
  String? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }

}

/// id : 1276
/// type : "acc"
/// name : "Vehicle"
/// show_in_popup : 0
/// value : "On"
/// val : true
/// scale_value : null

class Sensors {
  Sensors({
      num? id, 
      String? type, 
      String? name, 
      num? showInPopup, 
      String? value, 
      bool? val, 
      dynamic scaleValue,}){
    _id = id;
    _type = type;
    _name = name;
    _showInPopup = showInPopup;
    _value = value;
    _val = val;
    _scaleValue = scaleValue;
}

  Sensors.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _name = json['name'];
    _showInPopup = json['show_in_popup'];
    _value = json['value'];
    _val = json['val'];
    _scaleValue = json['scale_value'];
  }
  num? _id;
  String? _type;
  String? _name;
  num? _showInPopup;
  String? _value;
  bool? _val;
  dynamic _scaleValue;

  num? get id => _id;
  String? get type => _type;
  String? get name => _name;
  num? get showInPopup => _showInPopup;
  String? get value => _value;
  bool? get val => _val;
  dynamic get scaleValue => _scaleValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['name'] = _name;
    map['show_in_popup'] = _showInPopup;
    map['value'] = _value;
    map['val'] = _val;
    map['scale_value'] = _scaleValue;
    return map;
  }

}

/// id : null
/// user_id : null
/// device_id : null
/// name : null
/// rfid : null
/// phone : null
/// email : null
/// description : null
/// created_at : null
/// updated_at : null

class DriverData {
  DriverData({
      dynamic id, 
      dynamic userId, 
      dynamic deviceId, 
      dynamic name, 
      dynamic rfid, 
      dynamic phone, 
      dynamic email, 
      dynamic description, 
      dynamic createdAt, 
      dynamic updatedAt,}){
    _id = id;
    _userId = userId;
    _deviceId = deviceId;
    _name = name;
    _rfid = rfid;
    _phone = phone;
    _email = email;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  DriverData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _deviceId = json['device_id'];
    _name = json['name'];
    _rfid = json['rfid'];
    _phone = json['phone'];
    _email = json['email'];
    _description = json['description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  dynamic _id;
  dynamic _userId;
  dynamic _deviceId;
  dynamic _name;
  dynamic _rfid;
  dynamic _phone;
  dynamic _email;
  dynamic _description;
  dynamic _createdAt;
  dynamic _updatedAt;

  dynamic get id => _id;
  dynamic get userId => _userId;
  dynamic get deviceId => _deviceId;
  dynamic get name => _name;
  dynamic get rfid => _rfid;
  dynamic get phone => _phone;
  dynamic get email => _email;
  dynamic get description => _description;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['device_id'] = _deviceId;
    map['name'] = _name;
    map['rfid'] = _rfid;
    map['phone'] = _phone;
    map['email'] = _email;
    map['description'] = _description;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}

/// id : 93
/// user_id : null
/// type : "rotating"
/// order : null
/// width : 21
/// height : 40
/// path : "images/device_icons/62c1bd554da5c0.24482325_offline.png"
/// by_status : 1

class Icon {
  Icon({
      num? id, 
      dynamic userId, 
      String? type, 
      dynamic order, 
      num? width, 
      num? height, 
      String? path, 
      num? byStatus,}){
    _id = id;
    _userId = userId;
    _type = type;
    _order = order;
    _width = width;
    _height = height;
    _path = path;
    _byStatus = byStatus;
}

  Icon.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _order = json['order'];
    _width = json['width'];
    _height = json['height'];
    _path = json['path'];
    _byStatus = json['by_status'];
  }
  num? _id;
  dynamic _userId;
  String? _type;
  dynamic _order;
  num? _width;
  num? _height;
  String? _path;
  num? _byStatus;

  num? get id => _id;
  dynamic get userId => _userId;
  String? get type => _type;
  dynamic get order => _order;
  num? get width => _width;
  num? get height => _height;
  String? get path => _path;
  num? get byStatus => _byStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['type'] = _type;
    map['order'] = _order;
    map['width'] = _width;
    map['height'] = _height;
    map['path'] = _path;
    map['by_status'] = _byStatus;
    return map;
  }

}

/// moving : "green"
/// stopped : "yellow"
/// offline : "red"
/// engine : "orange"

class IconColors {
  IconColors({
      String? moving, 
      String? stopped, 
      String? offline, 
      String? engine,}){
    _moving = moving;
    _stopped = stopped;
    _offline = offline;
    _engine = engine;
}

  IconColors.fromJson(dynamic json) {
    _moving = json['moving'];
    _stopped = json['stopped'];
    _offline = json['offline'];
    _engine = json['engine'];
  }
  String? _moving;
  String? _stopped;
  String? _offline;
  String? _engine;

  String? get moving => _moving;
  String? get stopped => _stopped;
  String? get offline => _offline;
  String? get engine => _engine;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['moving'] = _moving;
    map['stopped'] = _stopped;
    map['offline'] = _offline;
    map['engine'] = _engine;
    return map;
  }

}