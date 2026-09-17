import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_dialog.dart';

void showDeleteDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomDialog(
        title: title,
        confirmText: 'Delete',
        content: content,
        onConfirm: onConfirm,
      );
    },
  );
}