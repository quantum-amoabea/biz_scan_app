class ScanCard {
  String? frontImage;
  String? backImage;
  String? region;

  ScanCard({this.frontImage, this.backImage, this.region});

  ScanCard.fromJson(Map<String, dynamic> json) {
    frontImage = json['front'];
    backImage = json['back'];
    region = json['business_region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['front'] = frontImage;
    data['back'] = backImage;
    data['business_region'] = region;
    return data;
  }
}