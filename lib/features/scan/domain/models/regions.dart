class Country {
  String? suggested;
  List<Regions>? regions;

  Country({this.suggested, this.regions});

  Country.fromJson(Map<String, dynamic> json) {
    suggested = json['suggested'];
    if (json['regions'] != null) {
      regions = <Regions>[];
      json['regions'].forEach((v) {
        regions!.add(new Regions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['suggested'] = suggested;
    if (regions != null) {
      data['regions'] = regions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Regions {
  String? code;
  String? name;
  int? callingCode;
  String? dialPrefix;

  Regions({this.code, this.name, this.callingCode, this.dialPrefix});

  Regions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    callingCode = json['calling_code'];
    dialPrefix = json['dial_prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['calling_code'] = this.callingCode;
    data['dial_prefix'] = this.dialPrefix;
    return data;
  }
}