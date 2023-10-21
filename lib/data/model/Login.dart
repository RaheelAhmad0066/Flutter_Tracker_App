class Login extends Object {
  int? status;
  String? user_api_hash;

  Login({this.status, this.user_api_hash});

  Login.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    user_api_hash = json["user_api_hash"];
  }

  Map<String, dynamic> toJson() =>
      {'status': status, 'user_api_hash': user_api_hash};
}
