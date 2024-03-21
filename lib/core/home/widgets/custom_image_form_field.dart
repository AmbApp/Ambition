import 'dart:io';

import 'package:ambition_app/config/sizeconfig/size_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/colors.dart';

class CustomImageFormField extends StatefulWidget {
  const CustomImageFormField({
    Key? key,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final Function(File) onChanged;

  @override
  _CustomImageFormFieldState createState() => _CustomImageFormFieldState();
}

class _CustomImageFormFieldState extends State<CustomImageFormField> {
  final ImagePicker _picker = ImagePicker();
  SizeConfig config = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: GestureDetector(
            onTap: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
              if (pickedFile != null) {
                widget.onChanged(File(pickedFile.path));
              }
            },
            child: Card(
              elevation: 10,
              color: AppColors.BLACK.withOpacity(0.9),
              surfaceTintColor: AppColors.BLACK.withOpacity(0.9),
              child: Container(
                width: config.uiWidthPx * 0.7,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.label,
                        style: const TextStyle(
                            color: AppColors.WHITE,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    const Icon(Icons.camera_alt, size: 28, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
