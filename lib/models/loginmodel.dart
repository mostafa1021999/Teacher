class LoginUser {
  String? status;
  Data? data;

  LoginUser.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

}
class Data {
  User ?user;
  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

}

class User {
  String? sId;
  String? name;
  String? phoneNumber;
  String? token;

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    token = json['token'];
  }

}