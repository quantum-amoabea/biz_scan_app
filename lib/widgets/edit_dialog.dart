import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

void editDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required VoidCallback onSave,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: BaseColors().whiteColor,
        title: Text(title, style: TextStyle(color: BaseColors().primaryColor),),
        content: Column(mainAxisSize: MainAxisSize.min, children: [content]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: BaseColors().primaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: BaseColors().primaryColor,
              foregroundColor: BaseColors().whiteColor,
            ),
            onPressed: onSave,
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
