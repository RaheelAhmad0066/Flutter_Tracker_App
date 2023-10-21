import 'device_data.dart';

/// id : 0
/// title : "Ungrouped"
/// items : [{"id":369,"alarm":0,"name":"PS BR22PA 1985","online":"ack","time":"18-10-2022 15:24:03","timestamp":1666089320,"lat":25.401708,"lng":86.339088,"course":186,"speed":0,"altitude":0,"power":"-","address":"-","protocol":"gt06","driver":"-","sensors":[{"id":1520,"type":"acc","name":"Vehicle","show_in_popup":0,"value":"On","val":true,"scale_value":null}],"ignition_duration":"0s","idle_duration":"0s","stop_duration":"2h 35min 13s","total_distance":25108.03}]

class Devices {
  Devices({
    dynamic id,
    String? title,
    List<deviceItems>? items,}){
    _id = id;
    _title = title;
    _items = items;
  }

  Devices.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(deviceItems.fromJson(v));
      });
    }
  }
  dynamic _id;
  String? _title;
  List<deviceItems>? _items;

  dynamic get id => _id;
  String? get title => _title;
  List<deviceItems>? get items => _items;

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

/// id : 369
/// alarm : 0
/// name : "PS BR22PA 1985"
/// online : "ack"
/// time : "18-10-2022 15:24:03"
/// timestamp : 1666089320
/// lat : 25.401708
/// lng : 86.339088
/// course : 186
/// speed : 0
/// altitude : 0
/// power : "-"
/// address : "-"
/// protocol : "gt06"
/// driver : "-"
/// sensors : [{"id":1520,"type":"acc","name":"Vehicle","show_in_popup":0,"value":"On","val":true,"scale_value":null}]
/// ignition_duration : "0s"
/// idle_duration : "0s"
/// stop_duration : "2h 35min 13s"
/// total_distance : 25108.03

class deviceItems {
  Items({
    dynamic id,
    dynamic alarm,
    String? name,
    String? online,
    String? time,
    dynamic timestamp,
    dynamic lat,
    dynamic lng,
    dynamic course,
    dynamic speed,
    dynamic altitude,
    String? power,
    String? address,
    String? protocol,
    String? driver,
    DeviceIcon? icon,
    List<Sensors>? sensors,
    String? ignitionDuration,
    String? idleDuration,
    String? stopDuration,
    dynamic totalDistance,
    DeviceData? deviceData,}){
    _id = id;
    _alarm = alarm;
    _name = name;
    _online = online;
    _time = time;
    _timestamp = timestamp;
    _lat = lat;
    _lng = lng;
    _course = course;
    _speed = speed;
    _altitude = altitude;
    _power = power;
    _address = address;
    _protocol = protocol;
    _driver = driver;
    _driverData = driverData;
    _icon = icon;
    _sensors = sensors;

    _ignitionDuration = ignitionDuration;
    _idleDuration = idleDuration;
    _stopDuration = stopDuration;
    _totalDistance = totalDistance;
    _deviceData = deviceData;
  }

  deviceItems.fromJson(dynamic json) {
    _id = json['id'];
    _alarm = json['alarm'];
    _name = json['name'];
    _online = json['online'];
    _time = json['time'];
    _timestamp = json['timestamp'];
    _lat = json['lat'];
    _lng = json['lng'];
    _course = json['course'];
    _speed = json['speed'];
    _altitude = json['altitude'];
    _power = json['power'];
    _address = json['address'];
    _protocol = json['protocol'];
    _driver = json['driver'];
    _driverData = json['driver_data'] != null ? DriverData.fromJson(json['driver_data']) : null;
    _icon = json['icon'] != null ? DeviceIcon.fromJson(json['icon']) : null;
    if (json['sensors'] != null) {
      _sensors = [];
      json['sensors'].forEach((v) {
        _sensors?.add(Sensors.fromJson(v));
      });
    }
    _ignitionDuration = json['ignition_duration'];
    _idleDuration = json['idle_duration'];
    _stopDuration = json['stop_duration'];
    _totalDistance = json['total_distance'];
    _deviceData = json['device_data'] != null ? DeviceData.fromJson(json['device_data']) : null;
  }
  dynamic _id;
  dynamic _alarm;
  String? _name;
  String? _online;
  String? _time;
  dynamic _timestamp;
  dynamic _lat;
  dynamic _lng;
  dynamic _course;
  dynamic _speed;
  dynamic _altitude;
  String? _power;
  String? _address;
  String? _protocol;
  String? _driver;
  DriverData? _driverData;
  DeviceIcon? _icon;
  List<Sensors>? _sensors;
  String? _ignitionDuration;
  String? _idleDuration;
  String? _stopDuration;
  dynamic _totalDistance;
  DeviceData? _deviceData;

  dynamic get id => _id;
  dynamic get alarm => _alarm;
  String? get name => _name;
  String? get online => _online;
  String? get time => _time;
  dynamic get timestamp => _timestamp;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  dynamic get course => _course;
  dynamic get speed => _speed;
  dynamic get altitude => _altitude;
  String? get power => _power;
  String? get address => _address;
  String? get protocol => _protocol;
  String? get driver => _driver;
  DriverData? get driverData => _driverData;
  DeviceIcon? get icon => _icon;
  List<Sensors>? get sensors => _sensors;
  String? get ignitionDuration => _ignitionDuration;
  String? get idleDuration => _idleDuration;
  String? get stopDuration => _stopDuration;
  dynamic get totalDistance => _totalDistance;
  DeviceData? get deviceData => _deviceData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['alarm'] = _alarm;
    map['name'] = _name;
    map['online'] = _online;
    map['time'] = _time;
    map['timestamp'] = _timestamp;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['course'] = _course;
    map['speed'] = _speed;
    map['altitude'] = _altitude;
    map['power'] = _power;
    map['address'] = _address;
    map['protocol'] = _protocol;
    map['driver'] = _driver;
    if (_driverData != null) {
      map['driver_data'] = _driverData?.toJson();
    }
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    if (_sensors != null) {
      map['sensors'] = _sensors?.map((v) => v.toJson()).toList();
    }
    map['ignition_duration'] = _ignitionDuration;
    map['idle_duration'] = _idleDuration;
    map['stop_duration'] = _stopDuration;
    map['total_distance'] = _totalDistance;
    if (_deviceData != null) {
      map['device_data'] = _deviceData?.toJson();
    }
    return map;
  }

}

class DeviceData {
  DeviceData({
    dynamic id,
    dynamic userId,
    dynamic active,
    dynamic deleted,
    String? name,
    String? imei,
    String? fuelQuantity,
    String? fuelPrice,
    String? fuelPerKm,
    String? simNumber,
    String? deviceModel,
    dynamic expirationDate,
    Traccar? traccar, }){
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
    _traccar = traccar;
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
    _traccar = json['traccar'] != null ? Traccar.fromJson(json['traccar']) : null;
  }
  dynamic _id;
  dynamic _userId;
  dynamic _active;
  dynamic _deleted;
  String? _name;
  String? _imei;
  String? _fuelQuantity;
  String? _fuelPrice;
  String? _fuelPerKm;
  String? _simNumber;
  String? _deviceModel;
  dynamic _expirationDate;
  Traccar? _traccar;

  dynamic get id => _id;
  dynamic get userId => _userId;
  dynamic get active => _active;
  dynamic get deleted => _deleted;
  String? get name => _name;
  String? get imei => _imei;
  String? get fuelQuantity => _fuelQuantity;
  String? get fuelPrice => _fuelPrice;
  String? get fuelPerKm => _fuelPerKm;
  String? get simNumber => _simNumber;
  String? get deviceModel => _deviceModel;
  dynamic get expirationDate => _expirationDate;
  Traccar? get traccar => _traccar;

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
    if (_traccar != null) {
      map['traccar'] = _traccar?.toJson();
    }
    return map;
  }

}

/// id : 1520
/// type : "acc"
/// name : "Vehicle"
/// show_in_popup : 0
/// value : "On"
/// val : true
/// scale_value : null

class Sensors {
  Sensors({
    dynamic id,
    String? type,
    String? name,
    dynamic showInPopup,
    String? value,
    dynamic val,
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
  dynamic _id;
  String? _type;
  String? _name;
  dynamic _showInPopup;
  String? _value;
  dynamic _val;
  dynamic _scaleValue;

  dynamic get id => _id;
  String? get type => _type;
  String? get name => _name;
  dynamic get showInPopup => _showInPopup;
  String? get value => _value;
  dynamic get val => _val;
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


class DeviceIcon {
  DeviceIcon({
    dynamic id,
    dynamic userId,
    String? type,
    dynamic order,
    dynamic width,
    dynamic height,
    String? path,
    dynamic byStatus,}){
    _id = id;
    _userId = userId;
    _type = type;
    _order = order;
    _width = width;
    _height = height;
    _path = path;
    _byStatus = byStatus;
  }

  DeviceIcon.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _order = json['order'];
    _width = json['width'];
    _height = json['height'];
    _path = json['path'];
    _byStatus = json['by_status'];
  }
  dynamic _id;
  dynamic _userId;
  String? _type;
  dynamic _order;
  dynamic _width;
  dynamic _height;
  String? _path;
  dynamic _byStatus;

  dynamic get id => _id;
  dynamic get userId => _userId;
  String? get type => _type;
  dynamic get order => _order;
  dynamic get width => _width;
  dynamic get height => _height;
  String? get path => _path;
  dynamic get byStatus => _byStatus;

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

class Traccar {
  Traccar({
    num? id,
    String? name,
    String? uniqueId,
    num? latestPositionId,
    num? lastValidLatitude,
    num? lastValidLongitude,
    String? other,
    String? speed,
    String? time,
    String? deviceTime,
    String? serverTime,
    dynamic ackTime,
    num? altitude,
    num? course,
    dynamic power,
    dynamic address,
    String? protocol,
    String? latestPositions,
    String? movedAt,
    String? stopedAt,
    String? engineOnAt,
    String? engineOffAt,
    String? engineChangedAt,
    dynamic databaseId,}){
    _id = id;
    _name = name;
    _uniqueId = uniqueId;
    _latestPositionId = latestPositionId;
    _lastValidLatitude = lastValidLatitude;
    _lastValidLongitude = lastValidLongitude;
    _other = other;
    _speed = speed;
    _time = time;
    _deviceTime = deviceTime;
    _serverTime = serverTime;
    _ackTime = ackTime;
    _altitude = altitude;
    _course = course;
    _power = power;
    _address = address;
    _protocol = protocol;
    _latestPositions = latestPositions;
    _movedAt = movedAt;
    _stopedAt = stopedAt;
    _engineOnAt = engineOnAt;
    _engineOffAt = engineOffAt;
    _engineChangedAt = engineChangedAt;
    _databaseId = databaseId;
  }

  Traccar.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _uniqueId = json['uniqueId'];
    _latestPositionId = json['latestPosition_id'];
    _lastValidLatitude = json['lastValidLatitude'];
    _lastValidLongitude = json['lastValidLongitude'];
    _other = json['other'];
    _speed = json['speed'];
    _time = json['time'];
    _deviceTime = json['device_time'];
    _serverTime = json['server_time'];
    _ackTime = json['ack_time'];
    _altitude = json['altitude'];
    _course = json['course'];
    _power = json['power'];
    _address = json['address'];
    _protocol = json['protocol'];
    _latestPositions = json['latest_positions'];
    _movedAt = json['moved_at'];
    _stopedAt = json['stoped_at'];
    _engineOnAt = json['engine_on_at'];
    _engineOffAt = json['engine_off_at'];
    _engineChangedAt = json['engine_changed_at'];
    _databaseId = json['database_id'];
  }
  num? _id;
  String? _name;
  String? _uniqueId;
  num? _latestPositionId;
  num? _lastValidLatitude;
  num? _lastValidLongitude;
  String? _other;
  String? _speed;
  String? _time;
  String? _deviceTime;
  String? _serverTime;
  dynamic _ackTime;
  num? _altitude;
  num? _course;
  dynamic _power;
  dynamic _address;
  String? _protocol;
  String? _latestPositions;
  String? _movedAt;
  String? _stopedAt;
  String? _engineOnAt;
  String? _engineOffAt;
  String? _engineChangedAt;
  dynamic _databaseId;
  Traccar copyWith({  num? id,
    String? name,
    String? uniqueId,
    num? latestPositionId,
    num? lastValidLatitude,
    num? lastValidLongitude,
    String? other,
    String? speed,
    String? time,
    String? deviceTime,
    String? serverTime,
    dynamic ackTime,
    num? altitude,
    num? course,
    dynamic power,
    dynamic address,
    String? protocol,
    String? latestPositions,
    String? movedAt,
    String? stopedAt,
    String? engineOnAt,
    String? engineOffAt,
    String? engineChangedAt,
    dynamic databaseId,
  }) => Traccar(  id: id ?? _id,
    name: name ?? _name,
    uniqueId: uniqueId ?? _uniqueId,
    latestPositionId: latestPositionId ?? _latestPositionId,
    lastValidLatitude: lastValidLatitude ?? _lastValidLatitude,
    lastValidLongitude: lastValidLongitude ?? _lastValidLongitude,
    other: other ?? _other,
    speed: speed ?? _speed,
    time: time ?? _time,
    deviceTime: deviceTime ?? _deviceTime,
    serverTime: serverTime ?? _serverTime,
    ackTime: ackTime ?? _ackTime,
    altitude: altitude ?? _altitude,
    course: course ?? _course,
    power: power ?? _power,
    address: address ?? _address,
    protocol: protocol ?? _protocol,
    latestPositions: latestPositions ?? _latestPositions,
    movedAt: movedAt ?? _movedAt,
    stopedAt: stopedAt ?? _stopedAt,
    engineOnAt: engineOnAt ?? _engineOnAt,
    engineOffAt: engineOffAt ?? _engineOffAt,
    engineChangedAt: engineChangedAt ?? _engineChangedAt,
    databaseId: databaseId ?? _databaseId,
  );
  num? get id => _id;
  String? get name => _name;
  String? get uniqueId => _uniqueId;
  num? get latestPositionId => _latestPositionId;
  num? get lastValidLatitude => _lastValidLatitude;
  num? get lastValidLongitude => _lastValidLongitude;
  String? get other => _other;
  String? get speed => _speed;
  String? get time => _time;
  String? get deviceTime => _deviceTime;
  String? get serverTime => _serverTime;
  dynamic get ackTime => _ackTime;
  num? get altitude => _altitude;
  num? get course => _course;
  dynamic get power => _power;
  dynamic get address => _address;
  String? get protocol => _protocol;
  String? get latestPositions => _latestPositions;
  String? get movedAt => _movedAt;
  String? get stopedAt => _stopedAt;
  String? get engineOnAt => _engineOnAt;
  String? get engineOffAt => _engineOffAt;
  String? get engineChangedAt => _engineChangedAt;
  dynamic get databaseId => _databaseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['uniqueId'] = _uniqueId;
    map['latestPosition_id'] = _latestPositionId;
    map['lastValidLatitude'] = _lastValidLatitude;
    map['lastValidLongitude'] = _lastValidLongitude;
    map['other'] = _other;
    map['speed'] = _speed;
    map['time'] = _time;
    map['device_time'] = _deviceTime;
    map['server_time'] = _serverTime;
    map['ack_time'] = _ackTime;
    map['altitude'] = _altitude;
    map['course'] = _course;
    map['power'] = _power;
    map['address'] = _address;
    map['protocol'] = _protocol;
    map['latest_positions'] = _latestPositions;
    map['moved_at'] = _movedAt;
    map['stoped_at'] = _stopedAt;
    map['engine_on_at'] = _engineOnAt;
    map['engine_off_at'] = _engineOffAt;
    map['engine_changed_at'] = _engineChangedAt;
    map['database_id'] = _databaseId;
    return map;
  }

}