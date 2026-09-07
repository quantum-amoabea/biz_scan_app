import 'package:flutter/material.dart';

import '../core/colors.dart';
import 'custom_textbutton.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: BaseColors().whiteColor,
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: TextStyle(
              color: BaseColors().primaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.pop(context),
          child:  Text(
            confirmText,
            style: TextStyle(
              color: BaseColors().primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}