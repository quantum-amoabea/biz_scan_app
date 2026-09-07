import 'package:biz_scan_app/features/auth/domain/models/user.dart';

class LoginUserResponse {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  int? expiresIn;
  User? user;

  LoginUserResponse(
      {this.accessToken,
      this.refreshToken,
      this.tokenType,
      this.expiresIn,
      this.user});

  LoginUserResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

