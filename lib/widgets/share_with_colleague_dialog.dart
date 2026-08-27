import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../core/toast_message.dart';
import 'custom_dialog.dart';

void showShareDialog(BuildContext context) {
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return CustomDialog(
        title: 'Share Contact',
        confirmText: 'Send',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Contact Email',
              suffixIcon: const Icon(Icons.person),
            ),
          ],
        ),
        onConfirm: () {
          final email = emailController.text.trim();

          if (email.isEmpty) return;

          Navigator.pop(context);

          showToast(
            message: 'Business card shared successfully',
          );
        },
      );
    },
  );
}