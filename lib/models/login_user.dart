class LoginUser {
  String? username;
  String? password;
  String? deviceLabel;

  LoginUser({this.username, this.password, this.deviceLabel});

  LoginUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    deviceLabel = json['device_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['device_label'] = deviceLabel;
    return data;
  }
}