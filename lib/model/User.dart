class User extends Object {
  dynamic email;
  dynamic expiration_date;
  dynamic days_left;
  dynamic plan;
  dynamic devices_limit;
  dynamic group_id;

  User(
      {this.email,
      this.expiration_date,
      this.days_left,
      this.plan,
      this.devices_limit,
      this.group_id});

  User.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    expiration_date = json["expiration_date"];
    days_left = json["days_left"];
    plan = json["plan"];
    devices_limit = json["devices_limit"];
    group_id = json["group_id"];
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'expiration_date': expiration_date,
        'days_left': days_left,
        'plan': plan,
        'devices_limit': devices_limit,
        'group_id': group_id
      };
}
