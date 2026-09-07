import 'package:biz_scan_app/core/colors.dart';
import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = BaseColors();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colors.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (value.isNotEmpty)
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: 'Copy',
                          color: colors.greyColor,
                          iconSize: 17,
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: value));
                            showToast(message: 'Copied to Clipboard');
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ),
                  ],
                ),
              ),
              if (onDelete != null)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.close,
                      size: 17,
                      color: colors.primaryColor,
                    ),
                  ),
                ),
              if (onEdit != null)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'Edit',
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit,
                      color: colors.primaryColor,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
