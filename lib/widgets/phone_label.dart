import 'package:flutter/cupertino.dart';

import '../core/colors.dart';

class PhoneTypeContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const PhoneTypeContainer({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? BaseColors().primaryColor
              : BaseColors().lightGreyColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? BaseColors().whiteColor
                : BaseColors().blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}