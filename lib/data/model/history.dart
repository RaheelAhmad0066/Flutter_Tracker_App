/// items : [{"status":1,"time":"56min 49s","show":"13-08-2022 01:59:42","left":"13-08-2022 02:56:31","raw_time":"2022-08-13 01:59:42","distance":39.09,"time_seconds":3409,"engine_work":2946,"engine_idle":0,"engine_hours":2946,"fuel_consumption":3,"top_speed":86,"average_speed":46,"driver":"","items":[{"id":232315,"device_id":369,"item_id":"i232315","time":"13-08-2022 01:59:42","raw_time":"2022-08-13 01:59:42","altitude":0,"course":277,"speed":7,"latitude":25.419952,"longitude":86.284363,"lat":25.419952,"lng":86.284363,"distance":0.020343180094275343,"other":" ","color":"blue","valid":1,"device_time":"2022-08-12 20:29:42","server_time":"2022-08-13 04:29:45","other_arr":["mcc: 405","mnc: 52","lac: 994","cid: 60502","ignition: true","event: 0","archive: false","odometer: 0","sequence: 7","distance: 20.34","totaldistance: 16739301.65","motion: true","valid: true","enginehours: 3519120","status: 70","charge: true","blocked: false","batterylevel: 100","rssi: 4","sat: 13"],"sensors_data":[{"id":"speed","value":7}]}]}]
/// device : {"id":369,"active":1,"deleted":0,"name":"Baliya PS BR22PA 1985","imei":"860465040092425","fuel_measurement_id":1,"fuel_quantity":"12.00","fuel_price":"95.00","fuel_per_km":"0.08","sim_number":"5754170407198","device_model":"bita","created_at":"2022-03-06 21:21:05","updated_at":"2022-07-03 08:58:42","stop_duration":"14h 57min 13s"}
/// distance_sum : "140.91 Km"
/// top_speed : "87 kph"
/// move_duration : "5h 5min 37s"
/// stop_duration : "4h 58min 14s"
/// fuel_consumption : "11.27 Liters"
/// status : 1

class History {
  History({
      List<TripsItems>? items,
      Device? device, 
      String? distanceSum, 
      String? topSpeed, 
      String? moveDuration, 
      String? stopDuration, 
      String? fuelConsumption, 
      num? status,}){
    _items = items;
    _device = device;
    _distanceSum = distanceSum;
    _topSpeed = topSpeed;
    _moveDuration = moveDuration;
    _stopDuration = stopDuration;
    _fuelConsumption = fuelConsumption;
    _status = status;
}

  History.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(TripsItems.fromJson(v));
      });
    }
    _device = json['device'] != null ? Device.fromJson(json['device']) : null;
    _distanceSum = json['distance_sum'];
    _topSpeed = json['top_speed'];
    _moveDuration = json['move_duration'];
    _stopDuration = json['stop_duration'];
    _fuelConsumption = json['fuel_consumption'];
    _status = json['status'];
  }
  List<TripsItems>? _items;
  Device? _device;
  String? _distanceSum;
  String? _topSpeed;
  String? _moveDuration;
  String? _stopDuration;
  String? _fuelConsumption;
  num? _status;

  List<TripsItems>? get items => _items;
  Device? get device => _device;
  String? get distanceSum => _distanceSum;
  String? get topSpeed => _topSpeed;
  String? get moveDuration => _moveDuration;
  String? get stopDuration => _stopDuration;
  String? get fuelConsumption => _fuelConsumption;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    if (_device != null) {
      map['device'] = _device?.toJson();
    }
    map['distance_sum'] = _distanceSum;
    map['top_speed'] = _topSpeed;
    map['move_duration'] = _moveDuration;
    map['stop_duration'] = _stopDuration;
    map['fuel_consumption'] = _fuelConsumption;
    map['status'] = _status;
    return map;
  }

}

/// id : 369
/// active : 1
/// deleted : 0
/// name : "Baliya PS BR22PA 1985"
/// imei : "860465040092425"
/// fuel_measurement_id : 1
/// fuel_quantity : "12.00"
/// fuel_price : "95.00"
/// fuel_per_km : "0.08"
/// sim_number : "5754170407198"
/// device_model : "bita"
/// created_at : "2022-03-06 21:21:05"
/// updated_at : "2022-07-03 08:58:42"
/// stop_duration : "14h 57min 13s"

class Device {
  Device({
      num? id, 
      num? active, 
      num? deleted, 
      String? name, 
      String? imei, 
      num? fuelMeasurementId, 
      String? fuelQuantity, 
      String? fuelPrice, 
      String? fuelPerKm, 
      String? simNumber, 
      String? deviceModel, 
      String? createdAt, 
      String? updatedAt, 
      String? stopDuration,}){
    _id = id;
    _active = active;
    _deleted = deleted;
    _name = name;
    _imei = imei;
    _fuelMeasurementId = fuelMeasurementId;
    _fuelQuantity = fuelQuantity;
    _fuelPrice = fuelPrice;
    _fuelPerKm = fuelPerKm;
    _simNumber = simNumber;
    _deviceModel = deviceModel;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _stopDuration = stopDuration;
}

  Device.fromJson(dynamic json) {
    _id = json['id'];
    _active = json['active'];
    _deleted = json['deleted'];
    _name = json['name'];
    _imei = json['imei'];
    _fuelMeasurementId = json['fuel_measurement_id'];
    _fuelQuantity = json['fuel_quantity'];
    _fuelPrice = json['fuel_price'];
    _fuelPerKm = json['fuel_per_km'];
    _simNumber = json['sim_number'];
    _deviceModel = json['device_model'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _stopDuration = json['stop_duration'];
  }
  num? _id;
  num? _active;
  num? _deleted;
  String? _name;
  String? _imei;
  num? _fuelMeasurementId;
  String? _fuelQuantity;
  String? _fuelPrice;
  String? _fuelPerKm;
  String? _simNumber;
  String? _deviceModel;
  String? _createdAt;
  String? _updatedAt;
  String? _stopDuration;

  num? get id => _id;
  num? get active => _active;
  num? get deleted => _deleted;
  String? get name => _name;
  String? get imei => _imei;
  num? get fuelMeasurementId => _fuelMeasurementId;
  String? get fuelQuantity => _fuelQuantity;
  String? get fuelPrice => _fuelPrice;
  String? get fuelPerKm => _fuelPerKm;
  String? get simNumber => _simNumber;
  String? get deviceModel => _deviceModel;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get stopDuration => _stopDuration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['active'] = _active;
    map['deleted'] = _deleted;
    map['name'] = _name;
    map['imei'] = _imei;
    map['fuel_measurement_id'] = _fuelMeasurementId;
    map['fuel_quantity'] = _fuelQuantity;
    map['fuel_price'] = _fuelPrice;
    map['fuel_per_km'] = _fuelPerKm;
    map['sim_number'] = _simNumber;
    map['device_model'] = _deviceModel;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['stop_duration'] = _stopDuration;
    return map;
  }

}

/// status : 1
/// time : "56min 49s"
/// show : "13-08-2022 01:59:42"
/// left : "13-08-2022 02:56:31"
/// raw_time : "2022-08-13 01:59:42"
/// distance : 39.09
/// time_seconds : 3409
/// engine_work : 2946
/// engine_idle : 0
/// engine_hours : 2946
/// fuel_consumption : 3
/// top_speed : 86
/// average_speed : 46
/// driver : ""
/// items : [{"id":232315,"device_id":369,"item_id":"i232315","time":"13-08-2022 01:59:42","raw_time":"2022-08-13 01:59:42","altitude":0,"course":277,"speed":7,"latitude":25.419952,"longitude":86.284363,"lat":25.419952,"lng":86.284363,"distance":0.020343180094275343,"other":" ","color":"blue","valid":1,"device_time":"2022-08-12 20:29:42","server_time":"2022-08-13 04:29:45","other_arr":["mcc: 405","mnc: 52","lac: 994","cid: 60502","ignition: true","event: 0","archive: false","odometer: 0","sequence: 7","distance: 20.34","totaldistance: 16739301.65","motion: true","valid: true","enginehours: 3519120","status: 70","charge: true","blocked: false","batterylevel: 100","rssi: 4","sat: 13"],"sensors_data":[{"id":"speed","value":7}]}]

class TripsItems {
  TripsItems({
      num? status, 
      String? time, 
      String? show, 
      String? left, 
      String? rawTime, 
      num? distance, 
      num? timeSeconds, 
      num? engineWork, 
      num? engineIdle, 
      num? engineHours, 
      num? fuelConsumption, 
      num? topSpeed, 
      num? averageSpeed, 
      String? driver, 
      List<AllItems>? items,}){
    _status = status;
    _time = time;
    _show = show;
    _left = left;
    _rawTime = rawTime;
    _distance = distance;
    _timeSeconds = timeSeconds;
    _engineWork = engineWork;
    _engineIdle = engineIdle;
    _engineHours = engineHours;
    _fuelConsumption = fuelConsumption;
    _topSpeed = topSpeed;
    _averageSpeed = averageSpeed;
    _driver = driver;
    _items = items;
}

  TripsItems.fromJson(dynamic json) {
    _status = json['status'];
    _time = json['time'];
    _show = json['show'];
    _left = json['left'];
    _rawTime = json['raw_time'];
    _distance = json['distance'];
    _timeSeconds = json['time_seconds'];
    _engineWork = json['engine_work'];
    _engineIdle = json['engine_idle'];
    _engineHours = json['engine_hours'];
    _fuelConsumption = json['fuel_consumption'];
    _topSpeed = json['top_speed'];
    _averageSpeed = json['average_speed'];
    _driver = json['driver'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(AllItems.fromJson(v));
      });
    }
  }
  num? _status;
  String? _time;
  String? _show;
  String? _left;
  String? _rawTime;
  num? _distance;
  num? _timeSeconds;
  num? _engineWork;
  num? _engineIdle;
  num? _engineHours;
  num? _fuelConsumption;
  num? _topSpeed;
  num? _averageSpeed;
  String? _driver;
  List<AllItems>? _items;

  num? get status => _status;
  String? get time => _time;
  String? get show => _show;
  String? get left => _left;
  String? get rawTime => _rawTime;
  num? get distance => _distance;
  num? get timeSeconds => _timeSeconds;
  num? get engineWork => _engineWork;
  num? get engineIdle => _engineIdle;
  num? get engineHours => _engineHours;
  num? get fuelConsumption => _fuelConsumption;
  num? get topSpeed => _topSpeed;
  num? get averageSpeed => _averageSpeed;
  String? get driver => _driver;
  List<AllItems>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['time'] = _time;
    map['show'] = _show;
    map['left'] = _left;
    map['raw_time'] = _rawTime;
    map['distance'] = _distance;
    map['time_seconds'] = _timeSeconds;
    map['engine_work'] = _engineWork;
    map['engine_idle'] = _engineIdle;
    map['engine_hours'] = _engineHours;
    map['fuel_consumption'] = _fuelConsumption;
    map['top_speed'] = _topSpeed;
    map['average_speed'] = _averageSpeed;
    map['driver'] = _driver;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 232315
/// device_id : 369
/// item_id : "i232315"
/// time : "13-08-2022 01:59:42"
/// raw_time : "2022-08-13 01:59:42"
/// altitude : 0
/// course : 277
/// speed : 7
/// latitude : 25.419952
/// longitude : 86.284363
/// lat : 25.419952
/// lng : 86.284363
/// distance : 0.020343180094275343
/// other : " "
/// color : "blue"
/// valid : 1
/// device_time : "2022-08-12 20:29:42"
/// server_time : "2022-08-13 04:29:45"
/// other_arr : ["mcc: 405","mnc: 52","lac: 994","cid: 60502","ignition: true","event: 0","archive: false","odometer: 0","sequence: 7","distance: 20.34","totaldistance: 16739301.65","motion: true","valid: true","enginehours: 3519120","status: 70","charge: true","blocked: false","batterylevel: 100","rssi: 4","sat: 13"]
/// sensors_data : [{"id":"speed","value":7}]

class AllItems {
  AllItems({
      dynamic id,
    dynamic deviceId,
    dynamic itemId,
    dynamic time,
    dynamic rawTime,
    dynamic altitude,
    dynamic course,
    dynamic speed,
    double? latitude,
    double? longitude,
    dynamic lat,
    dynamic lng,
    dynamic distance,
    dynamic other,
    dynamic color,
      dynamic valid,
    dynamic deviceTime,
    dynamic serverTime,
      List<dynamic>? otherArr,
      List<SensorsData>? sensorsData,}){
    _id = id;
    _deviceId = deviceId;
    _itemId = itemId;
    _time = time;
    _rawTime = rawTime;
    _altitude = altitude;
    _course = course;
    _speed = speed;
    _latitude = latitude;
    _longitude = longitude;
    _lat = lat;
    _lng = lng;
    _distance = distance;
    _other = other;
    _color = color;
    _valid = valid;
    _deviceTime = deviceTime;
    _serverTime = serverTime;
    _otherArr = otherArr;
    _sensorsData = sensorsData;
}

  AllItems.fromJson(dynamic json) {
    _id = json['id'];
    _deviceId = json['device_id'];
    _itemId = json['item_id'];
    _time = json['time'];
    _rawTime = json['raw_time'];
    _altitude = json['altitude'];
    _course = json['course'];
    _speed = json['speed'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _lat = json['lat'];
    _lng = json['lng'];
    _distance = json['distance'];
    _other = json['other'];
    _color = json['color'];
    _valid = json['valid'];
    _deviceTime = json['device_time'];
    _serverTime = json['server_time'];
    _otherArr = json['other_arr'] != null ? json['other_arr'].cast<String>() : [];
    if (json['sensors_data'] != null) {
      _sensorsData = [];
      json['sensors_data'].forEach((v) {
        _sensorsData?.add(SensorsData.fromJson(v));
      });
    }
  }
 dynamic _id;
 dynamic _deviceId;
  dynamic _itemId;
  dynamic _time;
  dynamic _rawTime;
 dynamic _altitude;
 dynamic _course;
 dynamic _speed;
  double? _latitude;
  double? _longitude;
 dynamic _lat;
 dynamic _lng;
 dynamic _distance;
  dynamic _other;
  dynamic _color;
 dynamic _valid;
  dynamic _deviceTime;
  dynamic _serverTime;
  List<dynamic>? _otherArr;
  List<SensorsData>? _sensorsData;

 dynamic get id => _id;
 dynamic get deviceId => _deviceId;
  dynamic get itemId => _itemId;
  dynamic get time => _time;
  dynamic get rawTime => _rawTime;
 dynamic get altitude => _altitude;
 dynamic get course => _course;
 dynamic get speed => _speed;
 double? get latitude => _latitude;
  double? get longitude => _longitude;
 dynamic get lat => _lat;
 dynamic get lng => _lng;
 dynamic get distance => _distance;
  dynamic get other => _other;
  dynamic get color => _color;
 dynamic get valid => _valid;
  dynamic get deviceTime => _deviceTime;
  dynamic get serverTime => _serverTime;
  List<dynamic>? get otherArr => _otherArr;
  List<SensorsData>? get sensorsData => _sensorsData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['device_id'] = _deviceId;
    map['item_id'] = _itemId;
    map['time'] = _time;
    map['raw_time'] = _rawTime;
    map['altitude'] = _altitude;
    map['course'] = _course;
    map['speed'] = _speed;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['distance'] = _distance;
    map['other'] = _other;
    map['color'] = _color;
    map['valid'] = _valid;
    map['device_time'] = _deviceTime;
    map['server_time'] = _serverTime;
    map['other_arr'] = _otherArr;
    if (_sensorsData != null) {
      map['sensors_data'] = _sensorsData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "speed"
/// value : 7

class SensorsData {
  SensorsData({
      dynamic id,
     dynamic value,}){
    _id = id;
    _value = value;
}

  SensorsData.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }
  dynamic _id;
 dynamic _value;

  dynamic get id => _id;
 dynamic get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }

}