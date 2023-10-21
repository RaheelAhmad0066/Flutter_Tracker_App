class DeviceModel {
  DeviceModel({
      this.imei, 
      this.protocol, 
      this.netProtocol, 
      this.ip, 
      this.port, 
      this.active, 
      this.objectExpire, 
      this.objectExpireDt, 
      this.dtServer, 
      this.dtTracker, 
      this.lat, 
      this.lng, 
      this.altitude, 
      this.angle, 
      this.speed, 
      this.params, 
      this.locValid, 
      this.dtLastStop, 
      this.dtLastIdle, 
      this.dtLastMove, 
      this.name, 
      this.device, 
      this.simNumber, 
      this.model, 
      this.vin, 
      this.plateNumber, 
      this.odometer, 
      this.engineHours, 
      this.customFields,});

  DeviceModel.fromJson(dynamic json) {
    imei = json['imei'];
    protocol = json['protocol'];
    netProtocol = json['net_protocol'];
    ip = json['ip'];
    port = json['port'];
    active = json['active'];
    objectExpire = json['object_expire'];
    objectExpireDt = json['object_expire_dt'];
    dtServer = json['dt_server'];
    dtTracker = json['dt_tracker'];
    lat = json['lat'];
    lng = json['lng'];
    altitude = json['altitude'];
    angle = json['angle'];
    speed = json['speed'];
    params = json['params'] != null ? Params.fromJson(json['params']) : null;
    locValid = json['loc_valid'];
    dtLastStop = json['dt_last_stop'];
    dtLastIdle = json['dt_last_idle'];
    dtLastMove = json['dt_last_move'];
    name = json['name'];
    device = json['device'];
    simNumber = json['sim_number'];
    model = json['model'];
    vin = json['vin'];
    plateNumber = json['plate_number'];
    odometer = json['odometer'];
    engineHours = json['engine_hours'];
    if (json['custom_fields'] != null) {
      customFields = [];
      json['custom_fields'].forEach((v) {
       // customFields?.add(Dynamic.fromJson(v));
      });
    }
  }
  String? imei;
  String? protocol;
  String? netProtocol;
  String? ip;
  String? port;
  String? active;
  String? objectExpire;
  String? objectExpireDt;
  String? dtServer;
  String? dtTracker;
  String? lat;
  String? lng;
  String? altitude;
  String? angle;
  String? speed;
  Params? params;
  String? locValid;
  String? dtLastStop;
  String? dtLastIdle;
  String? dtLastMove;
  String? name;
  String? device;
  String? simNumber;
  String? model;
  String? vin;
  String? plateNumber;
  String? odometer;
  String? engineHours;
  List<dynamic>? customFields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imei'] = imei;
    map['protocol'] = protocol;
    map['net_protocol'] = netProtocol;
    map['ip'] = ip;
    map['port'] = port;
    map['active'] = active;
    map['object_expire'] = objectExpire;
    map['object_expire_dt'] = objectExpireDt;
    map['dt_server'] = dtServer;
    map['dt_tracker'] = dtTracker;
    map['lat'] = lat;
    map['lng'] = lng;
    map['altitude'] = altitude;
    map['angle'] = angle;
    map['speed'] = speed;
    if (params != null) {
      map['params'] = params?.toJson();
    }
    map['loc_valid'] = locValid;
    map['dt_last_stop'] = dtLastStop;
    map['dt_last_idle'] = dtLastIdle;
    map['dt_last_move'] = dtLastMove;
    map['name'] = name;
    map['device'] = device;
    map['sim_number'] = simNumber;
    map['model'] = model;
    map['vin'] = vin;
    map['plate_number'] = plateNumber;
    map['odometer'] = odometer;
    map['engine_hours'] = engineHours;
    if (customFields != null) {
      map['custom_fields'] = customFields?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Params {
  Params({
      this.acc, 
      this.antitamp, 
      this.backbat, 
      this.door, 
      this.gpsrecfault, 
      this.lowbat, 
      this.oilcut, 
      this.rembat, 
      this.shock, 
      this.sos, 
      this.temp, 
      this.vecsecurity,});

  Params.fromJson(dynamic json) {
    acc = json['acc'];
    antitamp = json['antitamp'];
    backbat = json['backbat'];
    door = json['door'];
    gpsrecfault = json['gpsrecfault'];
    lowbat = json['lowbat'];
    oilcut = json['oilcut'];
    rembat = json['rembat'];
    shock = json['shock'];
    sos = json['sos'];
    temp = json['temp'];
    vecsecurity = json['vecsecurity'];
  }
  String? acc;
  String? antitamp;
  String? backbat;
  String? door;
  String? gpsrecfault;
  String? lowbat;
  String? oilcut;
  String? rembat;
  String? shock;
  String? sos;
  String? temp;
  String? vecsecurity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acc'] = acc;
    map['antitamp'] = antitamp;
    map['backbat'] = backbat;
    map['door'] = door;
    map['gpsrecfault'] = gpsrecfault;
    map['lowbat'] = lowbat;
    map['oilcut'] = oilcut;
    map['rembat'] = rembat;
    map['shock'] = shock;
    map['sos'] = sos;
    map['temp'] = temp;
    map['vecsecurity'] = vecsecurity;
    return map;
  }

}