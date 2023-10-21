class PositionHistory extends Object {
  List<dynamic>? items;
  String? distance_sum;
  String? top_speed;
  String? move_duration;
  String? stop_duration;
  String? fuel_consumption;


  PositionHistory({this.items, this.distance_sum});

  PositionHistory.fromJson(Map<String, dynamic> json) {
    items = json["items"];
    distance_sum = json["distance_sum"];
    top_speed = json['top_speed'];
    move_duration = json['move_duration'];
    stop_duration = json['stop_duration'];
    fuel_consumption = json['fuel_consumption'];
  }
}
