import 'package:flutter/material.dart';

import '../../Utils/colors.dart';

class HopOnDivider extends StatelessWidget {
  const HopOnDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      color: AppColors.BLACK,
      thickness: 1.0,
    );
  }
}
