import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';

class CountrySelectionTextField extends StatefulWidget {
  final TextEditingController? myController;
  final FocusNode? myFocusNode;
  final String hintText;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final EdgeInsetsGeometry myMargin;
  final Function(String)? onChanged;
  final Function(String)? onSubmited;

  const CountrySelectionTextField({
    super.key,
    required this.myController,
    this.myFocusNode,
    this.myMargin = const EdgeInsets.all(0),
    required this.hintText,
    this.inputType = TextInputType.number,
    this.inputAction = TextInputAction.done,
    this.onChanged,
    this.onSubmited,
  });

  @override
  _CountrySelectionTextFieldState createState() =>
      _CountrySelectionTextFieldState();
}

class _CountrySelectionTextFieldState extends State<CountrySelectionTextField> {
  final _selectPhoneCode = "91";

  @override
  void dispose() {
//    widget.myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.myMargin,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_500,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _openCountryPickerDialog();
                  },
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 5,
                      ),
                      Text("+$_selectPhoneCode"),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.SECONDARY,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: Opacity(
                opacity: 0.64,
                child: TextField(
                  maxLength: 12,
                  autofocus: false,
                  controller: widget.myController,
                  focusNode: widget.myFocusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: widget.inputAction,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    fillColor: Colors.grey,
                    counterText: "",
                  ),
                  onChanged: (str) {},
                  onSubmitted: (str) {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openCountryPickerDialog() => const Text("data");
  // showDialog(
  //       context: context,
  //       builder: (context) => Theme(
  //         data: Theme.of(context),
  //         child: CountryPickerDialog(
  //             titlePadding: EdgeInsets.all(8.0),
  //             searchInputDecoration: InputDecoration(hintText: 'Search...'),
  //             isSearchable: true,
  //             title: Text('Select your phone code'),
  //             onValuePicked: (Country country) {
  //               print(country.isoCode);
  //               setState(() => _selectIoCode = country.isoCode);
  //               setState(() => _selectPhoneCode = country.phoneCode);
  //             },
  //             itemBuilder: _buildDropdownItem),
  //       ),
  //     );
}
