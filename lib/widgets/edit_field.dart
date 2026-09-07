import 'package:biz_scan_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const EditField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      title: label,
      controller: controller,
      keyboardType: keyboardType,
    );
  }
}