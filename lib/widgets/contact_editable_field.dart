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
  final VoidCallback onDelete;

  const ContactEditableField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    required this.onDelete,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Icon + Input + Cancel
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: EditField(
                    label: '',
                    controller: controller,
                    keyboardType: keyboardType,
                  ),
                ),
                const SizedBox(width: 10),
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
          ],
        ),
      );
    }

    return ContactDetailItem(
      icon: icon,
      label: label,
      value: controller.text.isNotEmpty ? controller.text : "N/A",
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}