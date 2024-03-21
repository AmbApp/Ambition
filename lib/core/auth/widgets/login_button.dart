import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  bool isSecondary;
  final BorderRadiusGeometry? borderRadius;
  final bool? isLoading;

  LoginButton(
      {super.key,
      this.text = '',
      this.onPress,
      this.isSecondary = false,
      this.borderRadius,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress?.call();
      },
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(12)),
        ),
        child: Container(
          width: SizeConfig.screenWidthDp,
          height: SizeConfig().sh(40).toDouble(),
          decoration: BoxDecoration(
            borderRadius:
                borderRadius ?? const BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              colors: isSecondary!
                  ? AppColors.GRADIENTS_SECONDARY
                  : AppColors.GRADIENTS,
              stops: const [
                0.1,
                0.9,
              ],
            ),
          ),
          child: Center(
            child: isLoading!
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.WHITE),
                        strokeWidth: 1.5,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
          ),
        ),
      ),
    );
  }
}
