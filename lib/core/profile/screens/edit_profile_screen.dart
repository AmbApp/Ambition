import 'package:ambition_app/core/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:ambition_app/Utils/colors.dart';

import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/country_picker.dart';

import '../widgets/square_textfield.dart';

class EditProfileScreen extends StatelessWidget {
  static const String routeName = "profile";

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Profile();
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool genderChecked = true;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _mobileNumberFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _date.text = picked.toString();
      });
    }
  }

  Widget _buildTextField(
      String label,
      String hintText,
      TextInputType inputType,
      TextInputAction inputAction,
      TextEditingController controller,
      FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.BLACK,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        SquareTextField(
          hintText: hintText,
          inputType: inputType,
          inputAction: inputAction,
          controller: controller,
          focusNode: focusNode,
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Gender",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.BLACK,
                fontSize: 16,
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: genderChecked,
                activeColor: AppColors.SECONDARY,
                onChanged: (val) {
                  setState(() {
                    genderChecked = val ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Male",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.PRIMARY_500,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 21,
              height: 21,
              child: Checkbox(
                value: genderChecked,
                activeColor: AppColors.SECONDARY,
                onChanged: (val) {
                  setState(() {
                    genderChecked = val ?? false;
                  });
                },
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Female",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.PRIMARY_500,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerifiedText() {
    return Stack(
      children: <Widget>[
        ContactInputField((contact, code, _) => _performAction(contact, code!),
            () => _endAction(), false, false, _mobileNumberController),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 21,
              right: 12,
            ),
            child: Text(
              "Verified",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.GREEN,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Date of Birth",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.BLACK,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedDate.toLocal().toString().split(' ')[0],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.BLACK,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              btnColor: AppColors.PRIMARY_500,
              btnTxt: "Save",
              btnOnTap: _saveData,
            ),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    final Map<String, String> data = {
      'First Name': '_firstNameController.text',
      'Last Name': '_lastNameController.text',
      'Nick Name': '_nickNameController.text',
      'Mobile Number': '_mobileNumberController.text',
      'Email Address': '_emailController.text',
      'Password': '_passwordController.text',
    };

    print(data);
  }

  String countryCode = '';
  String number = '';
  String fullCode = '';

  Future _performAction(String contact, String code) async {
    setState(() => number = contact);
    setState(() => countryCode = code);
    // _formKey.currentState!.save();
    setState(() => fullCode = countryCode + number);
  }

  Future _endAction() async {}

  @override
  Widget build(BuildContext context) {
    final SizeConfig _config = SizeConfig();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: _config.uiHeightPx * 0.15,
            color: const Color(0xFFF3F3F3),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 15,
                    right: 15,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/user_icon.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                        Text(
                          "Umer Zia",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.BLACK,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField(
                    "First Name",
                    "Umer",
                    TextInputType.text,
                    TextInputAction.done,
                    _firstNameController,
                    _firstNameFocusNode),
                const SizedBox(height: 14),
                _buildTextField(
                    "Last Name",
                    "Zia",
                    TextInputType.text,
                    TextInputAction.done,
                    _lastNameController,
                    _lastNameFocusNode),
                const SizedBox(height: 14),
                _buildUserNameField(),
                const SizedBox(height: 14),
                _buildVerifiedText(),
                const SizedBox(height: 14),
                _buildTextField(
                    "Email Address",
                    "umerzia.com",
                    TextInputType.emailAddress,
                    TextInputAction.done,
                    _emailController,
                    _emailFocusNode),
                const SizedBox(height: 14),
                _buildDateOfBirthField(context),
                const SizedBox(height: 14),
                _buildTextField(
                    "Password",
                    "**********",
                    TextInputType.text,
                    TextInputAction.done,
                    _passwordController,
                    _passwordFocusNode),
                _buildDoneButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
