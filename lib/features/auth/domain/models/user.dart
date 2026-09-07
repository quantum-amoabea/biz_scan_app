class User {
  String? id;
  String? username;
  String? email;
  String? displayName;
  String? department;
  String? defaultRegion;
  String? lastLoginAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.displayName,
      this.department,
      this.defaultRegion,
      this.lastLoginAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    displayName = json['display_name'];
    department = json['department'];
    defaultRegion = json['default_region'];
    lastLoginAt = json['last_login_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['display_name'] = displayName;
    data['department'] = department;
    data['default_region'] = defaultRegion;
    data['last_login_at'] = lastLoginAt;
    return data;
  }
}