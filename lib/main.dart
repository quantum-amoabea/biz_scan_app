import 'package:biz_scan_app/features/auth/viewmodels/login_viewmodel.dart';
import 'package:biz_scan_app/features/scan/viewmodels/camera_viewmodel.dart';
import 'package:biz_scan_app/features/contact/viewmodels/contacts_viewmodel.dart';
import 'package:biz_scan_app/features/scan/viewmodels/scan_viewmodel.dart';
import 'package:biz_scan_app/core/offline/prefs_manager.dart';
import 'package:biz_scan_app/core/network/interceptor/token_interceptor.dart';
import 'package:biz_scan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:biz_scan_app/navigation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/network/dio_client.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await PrefsManager().init();
  await DioClient().initDioClient();

  TokenInterceptor.onLogout = () {
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = PrefsManager().isAuthenticated();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ScanViewModel()),
        ChangeNotifierProvider(create: (_) => ContactsViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        home: isAuthenticated ? const NavBar() : const LoginScreen(),
      ),
    );
  }
}