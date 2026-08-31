import 'package:biz_scan_app/core/network/dio_client.dart';
import 'package:biz_scan_app/core/offline/prefs_manager.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:biz_scan_app/models/login_user.dart';
import 'package:biz_scan_app/models/login_user_reponse.dart';
import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {
  LoginUserResponse? loginUserResponse;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final dioClient = DioClient();

  final prefsManager = PrefsManager();

  Future<void> loginUser(LoginUser user) async {
    try {
      _isLoading = true;
      final response = await dioClient.post(
        '/api/v1/auth/login',
        user.toJson(),

      );
      loginUserResponse = LoginUserResponse.fromJson(response.data);

    } catch (e) {
      debugPrint('the error is $e');
      showToast(message: '${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
