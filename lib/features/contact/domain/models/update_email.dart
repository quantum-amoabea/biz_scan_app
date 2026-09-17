class UpdateEmail {
  String? email;
  String? type;
  bool? isPrimary;

  UpdateEmail({this.email, this.type, this.isPrimary});

  UpdateEmail.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    type = json['type'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['type'] = type;
    data['is_primary'] = isPrimary;
    return data;
  }
}