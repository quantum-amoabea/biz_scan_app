class ScanCardResponse {
  String? id;
  String? status;
  String? pollUrl;

  ScanCardResponse({this.id, this.status, this.pollUrl});

  ScanCardResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    pollUrl = json['poll_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['poll_url'] = this.pollUrl;
    return data;
  }
}