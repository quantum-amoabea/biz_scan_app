import 'package:flutter/material.dart';

import '../core/toast_message.dart';
import 'custom_dialog.dart';

void showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomDialog(
        title: 'Delete Contact',
        confirmText: 'Delete',
        content: const Text(
          'Are you sure you want to delete this contact? '
          'This action cannot be undone.',
        ),
        onConfirm: () {
          Navigator.pop(context);

          // delete contact here

          showToast(message: 'Contact deleted successfully');
        },
      );
    },
  );
}
