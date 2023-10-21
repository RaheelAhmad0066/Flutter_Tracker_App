class devicesdata extends Object {
  Params? params;
  String? imei;
  String? active;
  String? object_expire;
  String? object_expire_dt;
  String? dt_server;
  String? dt_tracker;
  String? lat;
  String? lng;
  String? altitude;
  String? angle;
  String? speed;
  String? loc_valid;
  String? dt_last_stop;
  String? dt_last_idle;
  String? dt_last_move;
  String? name;
  String? device;
  String? sim_number;
  String? model;
  String? vin;
  String? plate_number;
  String? odometer;
  String? engine_hours;
 // List<dynamic>? custom_fields;



  devicesdata({this.params, this.imei,this.active,this.object_expire
    ,this.object_expire_dt,this.dt_server,this.dt_tracker,this.lat,this.lng,this.altitude
    ,this.angle,this.speed,this.loc_valid,this.dt_last_stop,this.dt_last_idle
    ,this.dt_last_move,this.name,this.device,this.sim_number,this.model,this.vin
    ,this.plate_number,this.odometer,this.engine_hours/*,this.custom_fields*/
   });

  devicesdata.fromJson(Map<String, dynamic> json) {
    params =  json['params'] != null ? Params.fromJson(json['params']) : null;
    imei = json["imei"];
    active = json['active'];
    object_expire = json['object_expire'];
    object_expire_dt = json['object_expire_dt'];
    dt_server = json['dt_server'];
    dt_tracker = json['dt_tracker'];
    lat = json['lat'];
    lng = json['lng'];
    altitude = json['altitude'];
    angle = json['angle'];
    speed = json['speed'];
    loc_valid = json['loc_valid'];
    dt_last_stop = json['dt_last_stop'];
    dt_last_idle = json['dt_last_idle'];
    dt_last_move = json['dt_last_move'];
    name = json['name'];
    device = json['device'];
    sim_number = json['sim_number'];
    model = json['model'];
    vin = json['vin'];
    plate_number = json['plate_number'];
    odometer = json['odometer'];
    engine_hours = json['engine_hours'];
   // custom_fields = json['custom_fields'];
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



