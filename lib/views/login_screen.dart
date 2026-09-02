import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/size_config.dart';
import 'package:biz_scan_app/models/login_user.dart';
import 'package:biz_scan_app/view_models/login_provider.dart';
import 'package:biz_scan_app/views/nav_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/toast_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> loginUser() async {
    final username = _username.text.trim();
    final password = _password.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showToast(message: 'Please fill all fields');
      return;
    }

    try{
      final user = LoginUser(username: username, password: password);

    await context.read<LoginProvider>().loginUser(user);

    showToast(message: "Logged in successfully");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
      (route) => false,
    );
    }
    catch(e){
      showToast(message: e.toString());
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return Scaffold(
      backgroundColor: BaseColors().whiteColor,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 200,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BaseColors().whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: BaseColors().greyColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/archholdings_logo.png',
                    width: 70,
                    height: 70,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Access secured enterprise resources',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BaseColors().greyColor),
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    title: "Username",
                    controller: _username,
                    focusNode: _usernameFocusNode,
                    nextFocusNode: _passwordFocusNode,
                    suffixIcon: Icon(
                      Icons.person,
                      color: BaseColors().greyColor,
                    ),
                  ),

                  CustomTextField(
                    title: "Password",
                    focusNode: _passwordFocusNode,
                    controller: _password,
                    suffixIcon: Icon(Icons.key, color: BaseColors().greyColor),
                    onSubmitted: () async => await loginUser(),
                  ),

                  const SizedBox(height: 20),

                  CustomTextButton(
                    text: 'Sign In',
                    icon: true,
                    isLoading: context.watch<LoginProvider>().isLoading,
                    onPressed: () async => await loginUser(),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.contact_support_outlined,
                        color: BaseColors().greyColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Contact IT Support",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: BaseColors().greyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
