import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

class AddFieldButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddFieldButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        icon: Icon(Icons.add, color: BaseColors().primaryColor, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: BaseColors().primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}