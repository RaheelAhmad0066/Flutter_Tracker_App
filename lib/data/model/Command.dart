class Command extends Object {
  String? id;
  String? value;
  String? title;

  Command({this.id, this.value, this.title});

  Command.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    value = json["value"];
    title = json["title"];
  }

  Map<String, dynamic> toJson() => {'id': id, 'value': value, 'title': title};
}
