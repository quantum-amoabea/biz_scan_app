import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButtonWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: BaseColors().primaryColor),
      label: Text(
        label,
        style: TextStyle(color: BaseColors().primaryColor),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: BaseColors().whiteColor,
        elevation: 0,
        side: BorderSide(color: BaseColors().primaryColor, width: 1),
      ),
    );
  }
}