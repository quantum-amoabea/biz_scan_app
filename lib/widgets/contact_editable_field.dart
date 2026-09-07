import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

import 'contact_detail_item.dart';
import 'edit_field.dart';

class ContactEditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType? keyboardType;
  final VoidCallback onEdit;

  const ContactEditableField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(label),
                    ),
                    GestureDetector(
                      onTap: onEdit,
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: BaseColors().primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Cancel',
                            style: TextStyle(color: BaseColors().primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                EditField(
                  label: label,
                  controller: controller,
                  keyboardType: keyboardType,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: label,
      value: controller.text.isNotEmpty ? controller.text : "N/A",
      onEdit: onEdit,
    );
  }
}