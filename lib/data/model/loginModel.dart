/// status : 1
/// user_api_hash : "$2y$10$8MV3tJb7PlW2O/mIBoT.tuFd0ZJoanvlQzlymF8Ls6YcrD4EBE0ji"

class LoginModel {
  LoginModel({
      num? status, 
      String? userApiHash,}){
    _status = status;
    _userApiHash = userApiHash;
}


  LoginModel.fromJson(dynamic json) {
    _status = json['status'];
    _userApiHash = json['user_api_hash'];
  }
  num? _status;
  String? _userApiHash;
LoginModel copyWith({  num? status,
  String? userApiHash,
}) => LoginModel(  status: status ?? _status,
  userApiHash: userApiHash ?? _userApiHash,
);
  num? get status => _status;
  String? get userApiHash => _userApiHash;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['user_api_hash'] = _userApiHash;
    return map;
  }

}