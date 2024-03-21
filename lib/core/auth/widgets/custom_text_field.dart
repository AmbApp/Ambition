import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: AppColors.PRIMARY_500,
        controller: controller,
        onChanged: (value) {},
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontSize: 15, height: 1.0, color: AppColors.grey1),
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(10),
            fillColor: Colors.white,
            filled: true,
            hintStyle: const TextStyle(
              color: AppColors.grey1,
              fontSize: 14,
            ),
            hintText: "",
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.grey1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.red1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppColors.LM_FONT_BLOCKTEXT_GREY7.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.LM_FONT_BLOCKTEXT_GREY7,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.red1),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.BLUE,
              ),
              borderRadius: BorderRadius.circular(5),
            )));
  }
}
