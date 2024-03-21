// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../provider/login_store.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/authScreen';
  final String signupMode;

  const SignUpScreen({Key? key, required this.signupMode}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SizeConfig config = SizeConfig();

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController age = TextEditingController();

  int _activeStepIndex = 0;

  void onStepContinue() {
    _activeStepIndex += 1;
  }

  void onStepCancel() {
    _activeStepIndex -= 1;
  }

  List<Step> stepList() {
    var textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 18, color: AppColors.BLACK);

    return [
      Step(
        state: _activeStepIndex <= 0 ? StepState.editing : StepState.complete,
        isActive: _activeStepIndex >= 0,
        title: const Text('Account', style: TextStyle(color: AppColors.BLACK)),
        content: Container(
          child: Column(
            children: [
              TextField(
                controller: fName,
                style: TextStyle(color: AppColors.BLACK),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              TextField(
                controller: lName,
                style: TextStyle(color: AppColors.BLACK),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      Step(
          state: _activeStepIndex <= 1 ? StepState.editing : StepState.complete,
          isActive: _activeStepIndex >= 1,
          title: const Text('Information',
              style: TextStyle(color: AppColors.BLACK)),
          content: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: phone,
                  style: TextStyle(color: AppColors.BLACK),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
                TextField(
                  controller: email,
                  style: TextStyle(color: AppColors.BLACK),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  style: TextStyle(color: AppColors.BLACK),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          )),
      Step(
          state: StepState.complete,
          isActive: _activeStepIndex >= 2,
          title:
              const Text('Confirm', style: TextStyle(color: AppColors.BLACK)),
          content: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Last Name: ${email.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Phone: ${phone.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Email : ${email.text}',
                style: textStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Password : ${password.text}', style: textStyle),
            ],
          ))),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_500,
        centerTitle: true,
        title: const Text("Ambition",
            style: TextStyle(
                color: AppColors.WHITE,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.WHITE,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<LoginStore>(
        builder: (_, loginStore, __) {
          return Scaffold(
            // key: GlobalVariable.scaffoldKey,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                      height: (MediaQuery.of(context).viewInsets.bottom > 0.0)
                          ? (config.uiHeightPx * 0.08).toDouble()
                          : (config.uiHeightPx * 0.12).toDouble()),
                  Text('Your Information',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.BLACK,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          )),
                  SizedBox(height: 20),
                  Stepper(
                    type: StepperType.vertical,
                    currentStep: _activeStepIndex,
                    steps: stepList(),
                    onStepContinue: () {
                      if (_activeStepIndex < (stepList().length - 1)) {
                        setState(() {
                          _activeStepIndex += 1;
                        });
                      } else {
                        if (phone.text != '' && password.text != '') {
                          loginStore.registerUser(
                              context,
                              password.text,
                              phone.text,
                              email.text,
                              fName.text,
                              lName.text,
                              widget.signupMode,
                              "personal");
                        }
                      }
                    },
                    onStepCancel: () {
                      if (_activeStepIndex == 0) {
                        return;
                      }

                      setState(() {
                        _activeStepIndex -= 1;
                      });
                    },
                    onStepTapped: (int index) {
                      final isLastStep =
                          _activeStepIndex == stepList().length - 1;

                      setState(() {
                        _activeStepIndex = index;
                      });
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      final isLastStep =
                          _activeStepIndex == stepList().length - 1;

                      return StepControlBuilder(
                          details: details,
                          loginStore: loginStore,
                          activeStepIndex: _activeStepIndex,
                          isLastStep: isLastStep);
                    },
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}

class StepControlBuilder extends StatelessWidget {
  const StepControlBuilder({
    super.key,
    required details,
    required activeStepIndex,
    required loginStore,
    required this.isLastStep,
  })  : _activeStepIndex = activeStepIndex,
        _details = details,
        _loginStore = loginStore;

  final int _activeStepIndex;
  final ControlsDetails _details;
  final LoginStore _loginStore;
  final bool isLastStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          if (_activeStepIndex > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _details.onStepCancel,
                child: Text('Back',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        color: AppColors.LM_BACKGROUND_BASIC)),
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: _details.onStepContinue,
              child: (isLastStep)
                  ? _loginStore.isOtpLoading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(),
                        )
                      : Text('Submit',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  color: AppColors.LM_BACKGROUND_BASIC))
                  : Text('Next',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.0,
                          color: AppColors.LM_BACKGROUND_BASIC)),
            ),
          ),
        ],
      ),
    );
  }
}
