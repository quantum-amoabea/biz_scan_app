class UpdateSocials {
  String? platform;
  String? url;
  String? handle;
  bool? isPrimary;

  UpdateSocials({this.platform, this.url, this.handle, this.isPrimary});

  UpdateSocials.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    url = json['url'];
    handle = json['handle'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform'] = platform;
    data['url'] = url;
    data['handle'] = handle;
    data['is_primary'] = isPrimary;
    return data;
  }
}