import 'package:flutter/material.dart';

import '../../Utils/colors.dart';
import '../../config/sizeconfig/size_config.dart';

class CustomPlaceTextWidget extends StatefulWidget {
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final Color? fillColor;
  final Color? borderColor;
  final String hintText;
  final SizeConfig config;
  final TextEditingController controller;

  const CustomPlaceTextWidget(
      {this.onSubmitted,
      this.onChanged,
      this.suffix,
      this.prefix,
      this.fillColor,
      this.borderColor,
      required this.hintText,
      required this.config,
      required this.controller,
      Key? key})
      : super(key: key);

  @override
  State<CustomPlaceTextWidget> createState() => _CustomPlaceTextWidgetState();
}

class _CustomPlaceTextWidgetState extends State<CustomPlaceTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 55,
      width: widget.config.uiWidthPx - 60,
      child: TextField(
        scrollPadding: const EdgeInsets.symmetric(vertical: 15),
        onSubmitted: widget.onSubmitted,
        readOnly: false,
        controller: widget.controller,
        cursorColor: AppColors.FONT_GRAY,
        keyboardType: TextInputType.streetAddress,
        autofillHints: const [AutofillHints.addressCity],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: widget.prefix ?? widget.prefix,
          filled: true,
          fillColor: widget.fillColor ?? AppColors.SECONDARY,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: BorderSide(
              width: 1,
              color: widget.borderColor ?? AppColors.BLACK,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: AppColors.BLACK),
          ),
          hintText: widget.hintText,
          alignLabelWithHint: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.BLACK,
              ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
