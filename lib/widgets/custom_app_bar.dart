import 'package:biz_scan_app/views/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  final Size preferredSize = const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Image.asset(
          'assets/images/archholdings_logo.png',
        ),
      ),
      elevation: 3,
      backgroundColor: BaseColors().whiteColor,
      shadowColor: BaseColors().greyColor,
      actions: [
        IconButton(
          onPressed: () {
             Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreen(),
                            ),
                            (route) => false,
                          );
          },
          icon: Icon(
            Icons.logout,
            color: BaseColors().primaryColor,
          ),
        ),
      ],
    );
  }
}