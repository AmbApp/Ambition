import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class SquareTextField extends StatelessWidget {
  final double myHeight;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final EdgeInsetsGeometry myMargin;
  final Function(String)? onChanged;
  final Function(String)? onSubmited;

  const SquareTextField({
    Key? key,
    this.myHeight = 48,
    this.controller,
    this.focusNode,
    this.myMargin = const EdgeInsets.all(0),
    required this.hintText,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.done,
    this.onChanged,
    this.onSubmited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 2,
      ),
      margin: myMargin,
      height: myHeight,
      decoration: BoxDecoration(
        color: const Color(0XFFF2F2F4),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Opacity(
        opacity: 0.80,
        child: TextField(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.BLACK,
              ),
          controller: controller,
          keyboardType: inputType,
          focusNode: focusNode,
          textInputAction: inputAction,
          decoration: InputDecoration(
            // focusedBorder: OutlineInputBorder(
            //   borderSide: const BorderSide(
            //     color: AppColors.BLUE,
            //   ),
            //   borderRadius: BorderRadius.circular(5),
            // ),
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black45,
                ),
            fillColor: Colors.red,
          ),
          onChanged: (str) {
            // onChanged(str);
          },
          onSubmitted: (str) {
            // onSubmited(str);
          },
        ),
      ),
    );
  }
}
