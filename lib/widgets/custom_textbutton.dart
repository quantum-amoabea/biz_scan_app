import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

import '../core/size_config.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final bool? icon;
  final bool? isLoading;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final double? verticalPadding;
  final double? horizontalPadding;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
    this.gradient,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    final radius = BorderRadius.circular(
      borderRadius ?? getProportionateScreenHeight(10),
    );

    return Container(
      constraints: BoxConstraints(
        minHeight: getProportionateScreenHeight(48),
      ),
      decoration: BoxDecoration(
        color: gradient == null
            ? (backgroundColor ?? BaseColors().primaryColor)
            : null,
        gradient: gradient,
        borderRadius: radius,
      ),
      child: TextButton(
        onPressed: onPressed ?? () {},
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? Colors.white,

          minimumSize: Size(
            double.infinity,
            getProportionateScreenHeight(48),
          ),

          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 12,
            horizontal: horizontalPadding ?? 20,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: radius,
          ),

          side: BorderSide(
            color: BaseColors().primaryColor,
            width: 1,
          ),
        ),
        child: isLoading == true
            ? SizedBox(
                height: getProportionateScreenHeight(20),
                width: getProportionateScreenHeight(20),
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (icon == true) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_outlined),
                  ],
                ],
              ),
      ),
    );
  }
}