import 'package:ambition_app/core/auth/screens/signup_screen.dart';
import 'package:flutter/material.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';

class RegistrationModeScreen extends StatefulWidget {
  const RegistrationModeScreen({Key? key});

  @override
  State<RegistrationModeScreen> createState() => _RegistrationModeScreenState();
}

class _RegistrationModeScreenState extends State<RegistrationModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Ambition",
            style: TextStyle(
                color: AppColors.WHITE,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.WHITE,
            size: 26,
          ),
          // color: AppColors.BLACK,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegistrationCard(
                  mode: "Driver",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              const SignUpScreen(signupMode: 'driver')),
                    );
                  },
                ),
                RegistrationCard(
                  mode: "Passenger",
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) =>
                              const SignUpScreen(signupMode: 'passenger')),
                    );
                  },
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: Text("Register",
                  style: TextStyle(
                      color: AppColors.FONT_GRAY,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationCard extends StatelessWidget {
  final String mode;
  final VoidCallback onTap;

  RegistrationCard({required this.mode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();

    return SizedBox(
      width: config.uiWidthPx * 0.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.SECONDARY,
          // shape: BoxShape.rectangle,
          boxShadow: [
            const BoxShadow(
                color: AppColors.SECONDARY,
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(2.5, 2.5)),
            BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 0.0,
                blurRadius: 3 / 2.0,
                offset: const Offset(2.5, 2.5)),
          ],
        ),
        margin: const EdgeInsets.all(16),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.SECONDARY,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: config.uiHeightPx * 0.12,
                  child: Image.asset(
                      mode == "Driver"
                          ? 'assets/images/driver-icon.png'
                          : 'assets/images/move.png',
                      fit: BoxFit.fitWidth),
                ),
                const SizedBox(height: 16),
                Text(
                    mode == "Driver"
                        ? 'Drive with Ambition'
                        : "Travel with Ambition",
                    style: const TextStyle(
                        color: AppColors.BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(
                    mode == "Driver"
                        ? 'Register as a driver'
                        : "Register as a passenger",
                    style: const TextStyle(
                        color: AppColors.BLACK,
                        fontSize: 13,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
