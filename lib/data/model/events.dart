/// status : 1
/// items : {"current_page":1,"data":[{"id":1834049,"user_id":28,"device_id":1123,"geofence_id":null,"poi_id":null,"position_id":96794,"alert_id":348,"type":"overspeed","message":"Overspeed (10 kph)","address":null,"altitude":0,"course":null,"latitude":25.570896666666666,"longitude":85.25038166666667,"power":null,"speed":30,"time":"2022-10-08 11:23:53","deleted":0,"created_at":"2022-10-08 11:23:56","updated_at":"2022-10-08 11:23:56","additional":{"overspeed_speed":10},"name":"Overspeed","detail":"10 kph","geofence":null,"device_name":"BR01GA 6293"}]}

class Events {
  Events({
      Items? items,}){
    _items = items;
}

  Events.fromJson(dynamic json) {
    _items =  Items.fromJson(json['items']);
  }
  Items? _items;
  Items? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.toJson();
    }
    return map;
  }

}

/// current_page : 1
/// data : [{"id":1834049,"user_id":28,"device_id":1123,"geofence_id":null,"poi_id":null,"position_id":96794,"alert_id":348,"type":"overspeed","message":"Overspeed (10 kph)","address":null,"altitude":0,"course":null,"latitude":25.570896666666666,"longitude":85.25038166666667,"power":null,"speed":30,"time":"2022-10-08 11:23:53","deleted":0,"created_at":"2022-10-08 11:23:56","updated_at":"2022-10-08 11:23:56","additional":{"overspeed_speed":10},"name":"Overspeed","detail":"10 kph","geofence":null,"device_name":"BR01GA 6293"}]

class Items {
  Items({
      dynamic currentPage, 
      List<EventsData>? data,}){
    _currentPage = currentPage;
    _data = data;
}

  Items.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(EventsData.fromJson(v));
      });
    }
  }
  dynamic _currentPage;
  List<EventsData>? _data;

  dynamic get currentPage => _currentPage;
  List<EventsData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1834049
/// user_id : 28
/// device_id : 1123
/// geofence_id : null
/// poi_id : null
/// position_id : 96794
/// alert_id : 348
/// type : "overspeed"
/// message : "Overspeed (10 kph)"
/// address : null
/// altitude : 0
/// course : null
/// latitude : 25.570896666666666
/// longitude : 85.25038166666667
/// power : null
/// speed : 30
/// time : "2022-10-08 11:23:53"
/// deleted : 0
/// created_at : "2022-10-08 11:23:56"
/// updated_at : "2022-10-08 11:23:56"
/// additional : {"overspeed_speed":10}
/// name : "Overspeed"
/// detail : "10 kph"
/// geofence : null
/// device_name : "BR01GA 6293"

class EventsData {
  EventsData({
      dynamic id, 
      dynamic userId, 
      dynamic deviceId, 
      dynamic geofenceId, 
      dynamic poiId, 
      dynamic positionId, 
      dynamic alertId, 
      String? type, 
      String? message, 
      dynamic address, 
      dynamic altitude, 
      dynamic course, 
      dynamic latitude, 
      dynamic longitude, 
      dynamic power, 
      dynamic speed, 
      String? time, 
      dynamic deleted, 
      String? createdAt, 
      String? updatedAt, 
      Additional? additional, 
      String? name, 
      String? detail, 
      dynamic geofence, 
      String? deviceName,}){
    _id = id;
    _userId = userId;
    _deviceId = deviceId;
    _geofenceId = geofenceId;
    _poiId = poiId;
    _positionId = positionId;
    _alertId = alertId;
    _type = type;
    _message = message;
    _address = address;
    _altitude = altitude;
    _course = course;
    _latitude = latitude;
    _longitude = longitude;
    _power = power;
    _speed = speed;
    _time = time;
    _deleted = deleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _additional = additional;
    _name = name;
    _detail = detail;
    _geofence = geofence;
    _deviceName = deviceName;
}

  EventsData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _deviceId = json['device_id'];
    _geofenceId = json['geofence_id'];
    _poiId = json['poi_id'];
    _positionId = json['position_id'];
    _alertId = json['alert_id'];
    _type = json['type'];
    _message = json['message'];
    _address = json['address'];
    _altitude = json['altitude'];
    _course = json['course'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _power = json['power'];
    _speed = json['speed'];
    _time = json['time'];
    _deleted = json['deleted'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _additional = json['additional'] != null ? Additional.fromJson(json['additional']) : null;
    _name = json['name'];
    _detail = json['detail'];
    _geofence = json['geofence'];
    _deviceName = json['device_name'];
  }
  dynamic _id;
  dynamic _userId;
  dynamic _deviceId;
  dynamic _geofenceId;
  dynamic _poiId;
  dynamic _positionId;
  dynamic _alertId;
  String? _type;
  String? _message;
  dynamic _address;
  dynamic _altitude;
  dynamic _course;
  dynamic _latitude;
  dynamic _longitude;
  dynamic _power;
  dynamic _speed;
  String? _time;
  dynamic _deleted;
  String? _createdAt;
  String? _updatedAt;
  Additional? _additional;
  String? _name;
  String? _detail;
  dynamic _geofence;
  String? _deviceName;

  dynamic get id => _id;
  dynamic get userId => _userId;
  dynamic get deviceId => _deviceId;
  dynamic get geofenceId => _geofenceId;
  dynamic get poiId => _poiId;
  dynamic get positionId => _positionId;
  dynamic get alertId => _alertId;
  String? get type => _type;
  String? get message => _message;
  dynamic get address => _address;
  dynamic get altitude => _altitude;
  dynamic get course => _course;
  dynamic get latitude => _latitude;
  dynamic get longitude => _longitude;
  dynamic get power => _power;
  dynamic get speed => _speed;
  String? get time => _time;
  dynamic get deleted => _deleted;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Additional? get additional => _additional;
  String? get name => _name;
  String? get detail => _detail;
  dynamic get geofence => _geofence;
  String? get deviceName => _deviceName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['device_id'] = _deviceId;
    map['geofence_id'] = _geofenceId;
    map['poi_id'] = _poiId;
    map['position_id'] = _positionId;
    map['alert_id'] = _alertId;
    map['type'] = _type;
    map['message'] = _message;
    map['address'] = _address;
    map['altitude'] = _altitude;
    map['course'] = _course;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['power'] = _power;
    map['speed'] = _speed;
    map['time'] = _time;
    map['deleted'] = _deleted;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_additional != null) {
      map['additional'] = _additional?.toJson();
    }
    map['name'] = _name;
    map['detail'] = _detail;
    map['geofence'] = _geofence;
    map['device_name'] = _deviceName;
    return map;
  }

}

/// overspeed_speed : 10

class Additional {
  Additional({
      dynamic overspeedSpeed,}){
    _overspeedSpeed = overspeedSpeed;
}

  Additional.fromJson(dynamic json) {
    _overspeedSpeed = json['overspeed_speed'];
  }
  dynamic _overspeedSpeed;

  dynamic get overspeedSpeed => _overspeedSpeed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['overspeed_speed'] = _overspeedSpeed;
    return map;
  }

}

