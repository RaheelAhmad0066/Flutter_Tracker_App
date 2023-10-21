class GeofenceModel extends Object {
  List<Geofence>? items;
  dynamic? status;

  GeofenceModel({this.items, this.status});

  GeofenceModel.fromJson(Map<dynamic, dynamic> json) {
    items = json["items"];
    status = json["status"];
  }

  Map<dynamic, dynamic> toJson() => {'items': items, 'status': status};
}

class Geofence extends Object {
  dynamic id;
  dynamic user_id;
  dynamic group_id;
  dynamic active;
  dynamic name;
  dynamic coordinates;
  dynamic polygon_color;
  dynamic created_at;
  dynamic updated_at;
  dynamic type;
  dynamic radius;
  dynamic center;

  Geofence(
      {this.id,
      this.user_id,
      this.group_id,
      this.active,
      this.name,
      this.coordinates,
      this.polygon_color,
      this.created_at,
      this.updated_at,
      this.type,
      this.radius,
      this.center});

  Geofence.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"];
    user_id = json["user_id"];
    group_id = json["group_id"];
    active = json["active"];
    name = json["name"];
    coordinates = json["coordinates"];
    polygon_color = json["polygon_color"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
    type = json["type"];
    radius = json["radius"];
    center = json["center"];
  }

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'user_id': user_id,
        'group_id': group_id,
        'active': active,
        'name': name,
        'coordinates': coordinates,
        'polygon_color': polygon_color,
        'created_at': created_at,
        'updated_at': updated_at,
        'type': type,
        'radius': radius,
        'center': center
      };
}
