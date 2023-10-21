class GeofencePermModel extends Object {
  int? deviceId;
  int? geofenceId;

  GeofencePermModel({this.deviceId, this.geofenceId});

  GeofencePermModel.fromJson(Map<String, dynamic> json) {
    deviceId = json["deviceId"];
    geofenceId = json["geofenceId"];
  }

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'geofenceId': geofenceId,
      };
}
