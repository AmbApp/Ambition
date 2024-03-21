import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:lottie/lottie.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../provider/login_store.dart';

class OtpPage extends StatefulWidget {
  static const routeName = '/otp';
  // passed from the previous screen
  final String? phoneNumber;
  final String otpmode;

  const OtpPage({
    Key? key,
    this.phoneNumber = '',
    required this.otpmode,
  }) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final SizeConfig config = SizeConfig();

  final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance!.window.viewInsets,
      WidgetsBinding.instance!.window.devicePixelRatio);

  String text = '';
  String _codeJoined = '';

  // Array to store joined code
  List<String> code = ['', '', '', '', '', ''];

  void _onKeyboardTap(String value) {
    setState(() {
      text = text.length <= 6 ? text + value : text;
    });
  }

  // final String _applicationSignature = "";
  // String _smsCode = "";

  bool isListening = false;
  bool consentLoading = false;

  @override
  void initState() {
    super.initState();
    logger("Otp page  :initState");
    // if (Platform.isAndroid) {
    //   initSmsListener();
    // }
  }

  @override
  void dispose() {
    // AndroidSmsRetriever.stopSmsListener();
    super.dispose();
  }

  String otpCode = '';

  // Future<void> initSmsListener() async {
  //   AndroidSmsRetriever.startSmsListener().then((value) {
  //     setState(() {
  //       final intRegex = RegExp(r'\d+', multiLine: true);
  //       final code = intRegex
  //           .allMatches(value ?? 'Phone Number Not Found')
  //           .first
  //           .group(0);
  //       // _smsCode = code ?? 'NO CODE';
  //       AndroidSmsRetriever.stopSmsListener();
  //     });
  //   });
  // }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  String getCode(String sms) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    final code = intRegex.allMatches(sms).first.group(0);
    return code ?? 'NO CODE';
  }

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(255, 255, 255, 1),
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(
      width: 2,
      color: AppColors.PRIMARY_500,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Observer(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.LM_BACKGROUND_GREY1,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: config.uiHeightPx * 1,
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: config.uiHeightPx * 0.1,
                    ),
                    SizedBox(
                      height: config.uiHeightPx * 0.16,
                      child: Lottie.asset(
                        "assets/animations/otp.json",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidthDp! * 0.03),
                          child: Text("Enter OTP",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                      color: AppColors.PRIMARY_500)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: config.uiWidthPx * 0.03,
                            bottom: config.uiHeightPx * 0.008),
                        child: Text(
                            'A 6-digit code has been sent to ${widget.phoneNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.LM_FONT_SECONDARY_GREY8)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: config.uiWidthPx * 0.03,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Didn't receive OTP?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: AppColors.FONT_GRAY,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                loginStore.resendOtp(
                                    context, widget.phoneNumber ?? '');
                              },
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: AppColors.PRIMARY_500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: config.uiWidthPx * 0.09,
                        left: config.uiWidthPx * 0.03,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          loginStore.resetPassword(
                              context, widget.phoneNumber ?? '', '', '');
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Forgot password ?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.PRIMARY_500),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              otpNumberWidget(0),
                              otpNumberWidget(1),
                              otpNumberWidget(2),
                              otpNumberWidget(3),
                              otpNumberWidget(4),
                              otpNumberWidget(5),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 16, bottom: config.uiHeightPx * 0.075),
                          child: NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor: AppColors.PRIMARY_500,
                            rightIcon: const Icon(
                              Icons.check,
                              color: AppColors.PRIMARY_500,
                            ),
                            rightButtonFn: () {
                              setState(() {
                                _codeJoined =
                                    text; // Update _codeJoined with the entered OTP
                              });
                              loginStore.validateOtpAndLogin(
                                  context,
                                  _codeJoined,
                                  widget.phoneNumber!,
                                  widget.otpmode);
                            },
                            leftIcon: const Icon(
                              Icons.backspace,
                              color: AppColors.PRIMARY_500,
                            ),
                            leftButtonFn: () {
                              setState(() {
                                text = text.isNotEmpty
                                    ? text.substring(0, text.length - 1)
                                    : text;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: pinPutDecoration
          ..copyWith(
            color: Colors.white,
            border: Border.all(width: 2, color: AppColors.PRIMARY_500),
          ),
        child: Center(
            child: Text(
          text[position],
          style: const TextStyle(color: AppColors.BLACK),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 2,
            color: AppColors.PRIMARY_300,
          ),
        ),
      );
    }
  }
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}
