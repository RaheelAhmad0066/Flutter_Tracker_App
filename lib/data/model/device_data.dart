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