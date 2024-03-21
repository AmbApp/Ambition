// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:ambition_app/core/auth/screens/register_mode_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../provider/login_store.dart';
import '../widgets/country_picker.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loader.dart';
import '../widgets/login_button.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/authScreen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SizeConfig config = SizeConfig();

  final TextEditingController controller = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String countryCode = '';
  String number = '';
  String fullCode = '';
  String? _applicationSignature;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      try {
        // getSignature();
      } catch (e) {
        debugPrint('PhoneAuthScreen:initState() ${e.toString()}');
        logger("Error getting app signature${e.toString()}");
      }
    }
  }

  // Future<void> getSignature() async {
  //   // final String? signature = await AndroidSmsRetriever.getAppSignature();
  //   // if (signature != null) {
  //   //   setState(() {
  //   //     _applicationSignature = signature;
  //   //   });
  //   // }
  // }

  void _clearField() {
    FocusScope.of(context).unfocus();
    phoneController.clear();
    passwordController.clear();
  }

  Future _performAction(String contact, String code) async {
    setState(() => number = contact);
    setState(() => countryCode = code);
    GlobalVariable.formKey.currentState!.save();
    setState(() => fullCode = countryCode + number);

    logger(fullCode);
  }

  Future _endAction() async {}

  void dismissFocus() {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: false, // TODO: add loading state
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    key: GlobalVariable.formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (config.uiHeightPx * 0.05).toDouble()
                                      : (config.uiHeightPx * 0.10).toDouble()),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Text('Ambition',
                                  style: TextStyle(
                                      color: AppColors.PRIMARY_500,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w700))),
                          SizedBox(
                            height: config.uiHeightPx * 0.06,
                          ),
                          // Container(
                          //     margin:
                          //         const EdgeInsets.only(top: 10, bottom: 40),
                          //     child: Text('Where Cargo Meets Convenience',
                          //         style: TextStyle(
                          //             color: AppColors.PRIMARY_500,
                          //             fontSize: 15,
                          //             fontWeight: FontWeight.w500))),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 12, top: 12, bottom: 18),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'Enter your mobile number',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.PRIMARY_500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ]),
                                ),
                              )),
                          SizedBox(
                            height: config.sh(80).toDouble(),
                            width: SizeConfig.screenWidthDp! * 0.94,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ContactInputField(
                                  (contact, code, _) =>
                                      _performAction(contact, code!),
                                  () => _endAction(),
                                  false,
                                  false,
                                  phoneController),
                            ),
                          ),
                          Container(
                              // width: SizeConfig.screenWidthDp! * 0.94,
                              padding: const EdgeInsets.only(
                                  left: 12, top: 20, bottom: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'enter password',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.PRIMARY_500,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ]),
                                ),
                              )),
                          PasswordInput(
                            config: config,
                            controller: passwordController,
                          ),
                          Column(
                            children: [
                              if (!loginStore.isPhoneLoading)
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: LoginButton(
                                        text: 'Log In',
                                        isLoading: loginStore.isPhoneLoading,
                                        onPress: () {
                                          loginStore.phoneLogin(
                                              context,
                                              fullCode,
                                              passwordController.text);
                                          if (loginStore.isPhoneDone == true) {
                                            _clearField();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 10,
                                          right: 10,
                                          bottom: 4),
                                      child: Text('or',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.PRIMARY_500,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w400,
                                              )),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, left: 16, right: 16),
                                        child: Text('New User?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: AppColors.PRIMARY_500,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: LoginButton(
                                        text: 'Register',
                                        isLoading: loginStore.isPhoneLoading,
                                        onPress: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) {
                                                return RegistrationModeScreen();
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 400),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(0, 1);
                                                const end = Offset.zero;
                                                const curve = Curves.easeInOut;
                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));
                                                var offsetAnimation =
                                                    animation.drive(tween);
                                                return SlideTransition(
                                                  position: offsetAnimation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              if (loginStore.isPhoneLoading)
                                CircularProgressIndicator()
                            ],
                          ),
                          SizedBox(
                              height:
                                  (MediaQuery.of(context).viewInsets.bottom >
                                          0.0)
                                      ? (config.uiHeightPx * 0.0375).toDouble()
                                      : (config.uiHeightPx * 0.085).toDouble()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.config,
    required this.controller,
  });

  final TextEditingController controller;
  final SizeConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.sh(80).toDouble(),
      width: SizeConfig.screenWidthDp! * 0.94,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomTextField(controller: controller)),
    );
  }
}
