class PlayBackRoute extends Object {
  String? device_id;
  String? latitude;
  String? longitude;
  String? course;
  String? raw_time;
  dynamic speed;

  PlayBackRoute({
    this.device_id,
    this.latitude,
    this.longitude,
    this.course,
    this.raw_time,
    this.speed,
  });

  PlayBackRoute.fromJson(Map<String, dynamic> json) {
    device_id = json["device_id"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    course = json["course"];
    raw_time = json["raw_time"];
    speed = json["speed"];
  }

  Map<String, dynamic> toJson() => {
        'device_id': device_id,
        'latitude': latitude,
        'longitude': longitude,
        'course': course,
        'raw_time': raw_time,
        'speed': speed
      };
}
