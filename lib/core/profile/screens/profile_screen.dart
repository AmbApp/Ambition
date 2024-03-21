import 'package:flutter/material.dart';
import 'package:ambition_app/Utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../config/sizeconfig/size_config.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "profile";

  const ProfileScreen({Key? key}) : super(key: key);

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
  String selectedMenuItem = '';
  bool genderChecked = true;
  DateTime selectedDate = DateTime.now();

  String selectuserName = '';
  String selectuserEmail = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ProfileViewModel viewModel =
          Provider.of<ProfileViewModel>(context, listen: false);
      viewModel.getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    final ProfileViewModel viewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: sizeConfig.uiHeightPx * 0.06,
          ),
          Container(
            color: AppColors.WHITE,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: sizeConfig.uiWidthPx * 0.1,
                      child: GestureDetector(
                        child: Icon(Icons.arrow_back, size: 24),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Text(
                      "My Account",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.BLACK,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    SizedBox(width: sizeConfig.uiWidthPx * 0.1)
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  height: sizeConfig.uiHeightPx * 0.16,
                  margin: EdgeInsets.symmetric(
                      horizontal: sizeConfig.uiWidthPx * 0.04),
                  padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.uiWidthPx * 0.02),
                  decoration: BoxDecoration(
                    color: AppColors.grey3,
                    border: Border.all(color: AppColors.grey3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              viewModel.name.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.BLACK,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(
                              height: sizeConfig.uiHeightPx * 0.012,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                ),
                                Text(
                                  "4.5",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.BLACK,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/user_icon.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: sizeConfig.uiHeightPx * 0.02),
                  child: Wrap(
                    spacing: 6,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 6,
                    children: <Widget>[
                      _buildMenuItem("Wallet", Icons.wallet),
                      _buildMenuItem("Previous Activity", Icons.drive_eta),
                      _buildMenuItem("Support", Icons.support_agent),
                      _buildMenuItem("Ambitiously", Icons.car_repair),
                      _buildMenuItem("Student", Icons.school),
                      _buildMenuItem("Safety Setting", Icons.security),
                      _buildMenuItem(
                          "Business/Company Accounts", Icons.business),
                      _buildMenuItem("Become a driver", Icons.directions_car),
                      _buildMenuItem("Accessibility", Icons.accessibility),
                    ],
                  ),
                ),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: _buildMenuItem("Visit our website", Icons.language)),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: _buildMenuItem("Messages", Icons.email)),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: _buildMenuItem("Legal", Icons.gavel)),
              ],
            ),
          ),
          // Replace BottomNavBar with your implementation
          //BottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String text, IconData icon, {VoidCallback? onTap}) {
    bool isSelected = selectedMenuItem == text;
    SizeConfig sizeConfig = SizeConfig();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text; // Update the selected menu item
        });
        if (onTap != null) {
          onTap(); // Execute the onTap function if provided
        }
      },
      child: Container(
        width: sizeConfig.uiWidthPx * 0.3,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
                color: AppColors.SECONDARY,
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(2, 2)),
            BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 0.0,
                blurRadius: 3 / 2.0,
                offset: const Offset(2, 2)),
          ],
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.white : AppColors.BLACK,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isSelected ? Colors.white : AppColors.BLACK,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
