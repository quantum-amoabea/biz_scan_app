import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const ContactDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: BaseColors().primaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (value.isNotEmpty)
                    IconButton(
                      color: BaseColors().greyColor,
                      iconSize: 17,
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: value),
                        );
                        showToast(message: "Copied to Clipboard");
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  if (onEdit != null)
                    GestureDetector(
                      onTap: onEdit,
                      child: Icon(
                        Icons.edit,
                        color: BaseColors().greyColor,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}