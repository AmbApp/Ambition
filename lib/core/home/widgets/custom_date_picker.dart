import 'package:ambition_app/config/sizeconfig/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class CustomDatePicker extends StatelessWidget {
  final BuildContext context;
  final SizeConfig config;
  final String text;
  final DateTime? date;
  final Function(DateTime)? updateDate;

  const CustomDatePicker({
    Key? key,
    required this.context,
    required this.config,
    required this.text,
    required this.date,
    required this.updateDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: AppColors.BLACK.withOpacity(0.9),
      surfaceTintColor: AppColors.BLACK.withOpacity(0.9),
      child: InkWell(
        onTap: () {
          _showDialog(
            CupertinoDatePicker(
              initialDateTime: date ?? DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              showDayOfWeek: true,
              onDateTimeChanged: (DateTime newDate) {
                updateDate!(newDate);
              },
            ),
            context,
          );
        },
        child: Container(
          height: config.uiHeightPx * 0.05,
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
