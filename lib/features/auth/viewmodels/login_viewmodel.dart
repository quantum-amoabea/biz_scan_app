import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/offline/prefs_manager.dart';
import 'package:biz_scan_app/features/auth/domain/models/login_user.dart';
import 'package:biz_scan_app/features/auth/domain/models/login_user_response.dart';
import 'package:biz_scan_app/features/auth/domain/models/user.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel extends ChangeNotifier {
  LoginUserResponse? loginUserResponse;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final DioClient dioClient = DioClient();

  final prefsManager = PrefsManager();

  Future<void> loginUser(LoginUser user) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await dioClient.post('api/v1/auth/login', user.toJson());
      loginUserResponse = LoginUserResponse.fromJson(response);
      prefsManager.setAccessToken(loginUserResponse?.accessToken ?? '');
      prefsManager.setRefreshToken(loginUserResponse?.refreshToken ?? "");
      prefsManager.setUser(loginUserResponse?.user ?? User());

      debugPrint('the user is $loginUserResponse');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
