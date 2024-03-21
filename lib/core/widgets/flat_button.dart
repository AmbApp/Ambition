import 'package:flutter/material.dart';

import '../../Utils/colors.dart';

class FlatButton extends StatelessWidget {
  final Color btnColor;
  final String btnTxt;
  final Function btnOnTap;
  final double height;

  const FlatButton({
    Key? key,
    required this.btnColor,
    required this.btnTxt,
    required this.btnOnTap,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white, // Background color set to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
            side: const BorderSide(
              color: AppColors.PRIMARY_500, // Border color set to PRIMARY_500
            ),
          ),
        ),
        onPressed: () => btnOnTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 12,
          ),
          child: Text(
            btnTxt,
          ),
        ),
      ),
    );
  }
}
