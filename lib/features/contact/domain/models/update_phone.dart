class UpdatePhone {
  String? raw;
  String? type;
  bool? isPrimary;
  String? region;

  UpdatePhone({this.raw, this.type, this.isPrimary, this.region});

  UpdatePhone.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    type = json['type'];
    isPrimary = json['is_primary'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['raw'] = raw;
    data['type'] = type;
    data['is_primary'] = isPrimary;
    data['region'] = region;
    return data;
  }
}