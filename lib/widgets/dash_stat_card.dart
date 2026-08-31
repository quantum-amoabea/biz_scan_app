import 'package:flutter/material.dart';
import 'package:biz_scan_app/core/colors.dart';

class DashboardStatCard extends StatelessWidget {
  final String value;
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const DashboardStatCard({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: BaseColors().whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: BaseColors().greyColor,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: BaseColors().primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}