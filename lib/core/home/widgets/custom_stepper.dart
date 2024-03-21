import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    required this.lowerLimit,
    required this.upperLimit,
    required this.stepValue,
    required this.iconSize,
    required this.value,
  });

  final int lowerLimit;
  final int upperLimit;
  final int stepValue;
  final double iconSize;
  int value;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RoundedIconButton(
          icon: Icons.remove,
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.lowerLimit
                  ? widget.lowerLimit
                  : widget.value -= widget.stepValue;
            });
          },
        ),
        Container(
          width: widget.iconSize,
          child: Text(
            '${widget.value}',
            style: TextStyle(
              fontSize: widget.iconSize * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        RoundedIconButton(
          icon: Icons.add,
          onPressed: () {
            setState(() {
              widget.value = widget.value == widget.upperLimit
                  ? widget.upperLimit
                  : widget.value += widget.stepValue;
            });
          },
        ),
      ],
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

  RoundedIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: AppColors.BLACK, // Set the button color here
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            icon,
            color: Colors.white, // Set the icon color here
          ),
        ),
      ),
    );
  }
}
