import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/size_config.dart';
import 'package:biz_scan_app/views/nav_bar.dart';
import 'package:biz_scan_app/widgets/custom_textbutton.dart';
import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Scaffold(
      backgroundColor: BaseColors().whiteColor,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 130),
        child: Container(
          padding: EdgeInsets.all(20),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/archholdings_logo.png',
                width: 70,
                height: 70,
              ),
              SizedBox(height: 10),

              Text(
                'Access secured enterprise resources',
                textAlign: TextAlign.center,
                style: TextStyle(color: BaseColors().greyColor),
              ),
              SizedBox(height: 30),
              CustomTextField(
                title: "Username",
                suffixIcon: Icon(Icons.person, color: BaseColors().greyColor),
              ),
              CustomTextField(
                title: "Password",
                suffixIcon: Icon(Icons.key, color: BaseColors().greyColor),
              ),
              SizedBox(height: 20),

              CustomTextButton(
                text: 'Sign In',
                icon: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavBar()),
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contact_support_outlined,
                    color: BaseColors().greyColor,
                  ),
                  SizedBox(width: 5),
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
    );
  }
}
