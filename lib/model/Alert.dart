class Alert extends Object {
  dynamic id;
  dynamic user_id;
  dynamic active;
  dynamic name;
  dynamic type;
  dynamic schedules;
  Map<String, dynamic>? notifications;
  dynamic created_at;
  dynamic updated_at;
  dynamic zone;
  dynamic schedule;
  Map<String, dynamic>? command;
  List<dynamic>? devices;
  List<dynamic>? drivers;
  List<dynamic>? geofences;
  List<dynamic>? events_custom;

  Alert(
      {this.id,
      this.user_id,
      this.active,
      this.name,
      this.type,
      this.schedules,
      this.notifications,
      this.created_at,
      this.updated_at,
      this.zone,
      this.schedule,
      this.command,
      this.devices,
      this.drivers,
      this.geofences,
      this.events_custom});

  Alert.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    user_id = json["user_id"];
    active = json["active"];
    name = json["name"];
    type = json["type"];
    schedules = json["schedules"];
    notifications = json["notifications"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
    zone = json["zone"];
    schedule = json["schedule"];
    command = json["command"];
    devices = json["devices"];
    drivers = json["drivers"];
    geofences = json["geofences"];
    events_custom = json["events_custom"];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'active': active,
        'name': name,
        'type': type,
        'schedules': schedules,
        'notifications': notifications,
        'created_at': created_at,
        'updated_at': updated_at,
        'zone': zone,
        'schedule': schedule,
        'command': command,
        'devices': devices,
        'drivers': drivers,
        'geofences': geofences,
        'events_custom': events_custom
      };
}
