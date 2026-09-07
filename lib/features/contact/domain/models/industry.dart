class Industry {
  final String code;
  final String name;
  final String fullName;

  const Industry({
    required this.code,
    required this.name,
    required this.fullName,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'full_name': fullName,
    };
  }
}