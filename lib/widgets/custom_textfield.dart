import 'package:biz_scan_app/core/colors.dart';
import 'package:flutter/material.dart';

import '../core/size_config.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscure;
  final bool? readOnly;
  final String? title;
  final Color? titleColor;
  final int? minLines;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? hintText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function(String)? onChanged;
  final VoidCallback? onSubmitted;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.title,
    this.focusNode,
    this.hintText,
    this.nextFocusNode,
    this.onChanged,
    this.minLines,
    this.maxLines,
    this.titleColor,
    this.controller,
    this.obscure,
    this.suffixIcon,
    this.readOnly,
    this.onSubmitted,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: TextStyle(
            color: titleColor,
            fontSize: getProportionateScreenHeight(14),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscure ?? false,
          focusNode: focusNode,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType ?? TextInputType.text,
          minLines: minLines,
          maxLines: obscure == true ? 1 : maxLines,
          decoration: InputDecoration(
            prefixIcon: suffixIcon,
            fillColor: Colors.white,
            filled: true,
            counterText: '',
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: getProportionateScreenHeight(14),
                color: BaseColors().greyColor),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(10)),
              borderSide: BorderSide(
                  color: BaseColors().greyColor,
                  width: getProportionateScreenHeight(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(10)),
              borderSide: BorderSide(
                  color: BaseColors().greyColor,
                  width: getProportionateScreenHeight(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(10)),
              borderSide: BorderSide(
                  color: BaseColors().greyColor,
                  width: getProportionateScreenHeight(0.5)),
            ),
          ),
          textInputAction: nextFocusNode == null
              ? TextInputAction.done
              : TextInputAction.next,
          onSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
              onSubmitted?.call();
            }
          },
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
      ],
    );
  }
}
