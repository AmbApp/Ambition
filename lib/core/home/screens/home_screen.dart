import 'dart:async';

import 'package:ambition_app/Utils/image_path.dart';
import 'package:ambition_app/core/profile/screens/profile_screen.dart';
import 'package:ambition_app/core/registration/modals/registration_modal.dart';
import 'package:ambition_app/core/ride/viewmodel/map_view_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../../Utils/constants.dart';
import '../..//ride/service/stripe_service.dart';
import 'package:ambition_app/Utils/colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';

import '../../../config/sizeconfig/size_config.dart';

import '../../auth/provider/login_store.dart';
import '../../auth/widgets/login_button.dart';

import '../../profile/screens/ride_history.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';
import '../../ride/modals/schedule_ride.dart';
import '../../ride/modals/search_rides_modal.dart';
import '../../ride/screens/map_screen.dart';

enum ActionSliderState {
  idle,
  loading,
  success,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ProfileViewModel viewModel =
          Provider.of<ProfileViewModel>(context, listen: false);

      await viewModel.getRideHistory();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RegistrationModal(),
      //   ),
      // );
    });
  }

  DateTime scheduledDateTime = DateTime.now();

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final StripePaymentHandle stripePaymentHandle = StripePaymentHandle();

  void createStripePayment() => {stripePaymentHandle.stripeMakePayment()};

  void showScheduleRideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScheduleRideDialog(
          setDateTime: (dateTime) {
            scheduledDateTime = dateTime;

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();

    return Consumer<LoginStore>(builder: (context, loginStore, _) {
      return Observer(
          builder: (_) => (Scaffold(
                body: SingleChildScrollView(
                    child: !loginStore.isDriver
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: config.uiHeightPx * 0.08,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: config.uiHeightPx * 0.12,
                                  decoration: const BoxDecoration(
                                    color: AppColors.BLACK,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.04,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    animatedNavigation(context);
                                  },
                                  child: Container(
                                    height: config.uiHeightPx * 0.07,
                                    width: config.uiWidthPx * 0.96,
                                    decoration: const BoxDecoration(
                                      color: AppColors.SECONDARY,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          width: config.uiWidthPx * 0.96,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: config.uiWidthPx * 0.004,
                                              ),
                                              const Icon(
                                                Icons.search,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                child: AutoSizeText(
                                                  "Let's move",
                                                  minFontSize: 13,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                          color: AppColors
                                                              .FONT_GRAY),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                              SizedBox(
                                                width: config.uiWidthPx * 0.01,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: AppColors.WHITE,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                22))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Icon(
                                                        Icons.watch_later,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            config.uiWidthPx *
                                                                0.01,
                                                      ),
                                                      GestureDetector(
                                                        child: SizedBox(
                                                          child: AutoSizeText(
                                                            "Schedule a move",
                                                            minFontSize: 13,
                                                            maxLines: 1,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15,
                                                                    color: AppColors
                                                                        .FONT_GRAY),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          showScheduleRideDialog(
                                                              context);
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            config.uiWidthPx *
                                                                0.01,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_drop_down_sharp,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            config.uiWidthPx *
                                                                0.01,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.012,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  'More Ambition',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: AppColors.FONT_GRAY,
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.012,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: config.uiWidthPx * 0.40,
                                    height: config.uiHeightPx * 0.22,
                                    child: Container(
                                      width: config.uiHeightPx * 0.20,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      child: Card(
                                        elevation: 2,
                                        color: const Color.fromRGBO(
                                            240, 240, 240, 1),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Image.asset(
                                                  height:
                                                      config.uiHeightPx * 0.12,
                                                  width:
                                                      config.uiHeightPx * 0.12,
                                                  'assets/images/rideMove.png',
                                                  fit: BoxFit.fitWidth),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(),
                                              child: SizedBox(
                                                height:
                                                    config.uiHeightPx * (0.08),
                                                child: AutoSizeText(
                                                  "Ride & Move",
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  minFontSize: 15,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                        color:
                                                            AppColors.FONT_GRAY,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: config.uiWidthPx * 0.40,
                                    height: config.uiHeightPx * 0.22,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Card(
                                        elevation: 2,
                                        color: AppColors.grey3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: config.uiHeightPx * 0.1,
                                              child: Image.asset(
                                                  ImagesAsset.vanReal,
                                                  fit: BoxFit.fitHeight),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0, right: 2, top: 2),
                                              child: SizedBox(
                                                height:
                                                    config.uiHeightPx * (0.08),
                                                child: AutoSizeText(
                                                  'Refrigeration',
                                                  maxLines: 1,
                                                  minFontSize: 15,
                                                  overflow: TextOverflow.fade,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 20,
                                                        color:
                                                            AppColors.FONT_GRAY,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.012,
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.25,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    compassEnabled: false,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    zoomGesturesEnabled: false,
                                    initialCameraPosition: const CameraPosition(
                                      target: LatLng(51.4572, 0.1176),
                                      zoom: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: config.uiHeightPx * 0.01,
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              SizedBox(
                                height: config.uiHeightPx * 1,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: config.uiHeightPx * 0.08,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: config.uiHeightPx * 0.12,
                                        decoration: const BoxDecoration(
                                          color: AppColors.BLACK,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.04,
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.26,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4),
                                        child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          compassEnabled: false,
                                          myLocationButtonEnabled: false,
                                          zoomControlsEnabled: false,
                                          zoomGesturesEnabled: false,
                                          initialCameraPosition:
                                              const CameraPosition(
                                            target: LatLng(51.4572, 0.1176),
                                            zoom: 14.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.04,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        height: config.uiHeightPx * 0.06,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColors.SECONDARY
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 1,
                                                offset: const Offset(1, 1)),
                                          ],
                                        ),
                                        child: LoginButton(
                                          isSecondary: true,
                                          text: 'Show Accepted/Scheduled Job',
                                          onPress: () async {
                                            // createStripePayment();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => MapScreen(
                                                        mapMode: MapMode.driver,
                                                      )),
                                            );

                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   isDismissible: false,
                                            //   builder: (context) =>
                                            //       DriverRideNotificationModal(
                                            //           NotificationDataModel()),
                                            // );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 4,
                                right: 4,
                                bottom: config.uiHeightPx * 0.14,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColors.SECONDARY_700
                                                  .withOpacity(0.9),
                                              spreadRadius: 0,
                                              blurRadius: 2,
                                              offset: const Offset(2, 4)),
                                        ],
                                      ),
                                      child: LiteRollingSwitch(
                                        //initial value
                                        value: false,
                                        onTap: () {},
                                        textOn: 'Offline',
                                        textOff: 'Online',
                                        textOffColor: Colors.white,
                                        textOnColor: AppColors.grey9,
                                        colorOn: AppColors.red1,
                                        colorOff: AppColors.BLACK,
                                        iconOn: Icons.cancel_rounded,
                                        iconOff: Icons.done,
                                        textSize: 16.0,
                                        onChanged: (bool state) {
                                          //Use it to manage the different states
                                          print(
                                              'Current State of SWITCH IS: $state');
                                        },
                                        onDoubleTap: () {},
                                        onSwipe: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.01,
                                    ),
                                    SizedBox(
                                      height: config.uiHeightPx * 0.16,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: AppColors.SECONDARY
                                                    .withOpacity(0.3),
                                                spreadRadius: 0,
                                                blurRadius: 2,
                                                offset: const Offset(2, -1)),
                                          ],
                                        ),
                                        child: Card(
                                          elevation: 6,
                                          surfaceTintColor: AppColors.WHITE,
                                          color: AppColors.WHITE,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 16),
                                            height: 160,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Earnings Today',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20,
                                                                    color: AppColors
                                                                        .BLACK,
                                                                  ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '£30',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 17,
                                                                  color:
                                                                      AppColors
                                                                          .BLACK,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          'Transports Today',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20,
                                                                    color: AppColors
                                                                        .BLACK,
                                                                  ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            '01',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 17,
                                                                  color:
                                                                      AppColors
                                                                          .BLACK,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                bottomNavigationBar: SizedBox(
                  height: config.uiHeightPx * 0.12,
                  child: BottomNavigationBar(
                    selectedItemColor: AppColors.grey9,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Account',
                      ),
                    ],
                    onTap: (i) => {
                      if (i == 2)
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const Profile()),
                          ),
                        }
                      else if (i == 1)
                        {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => RideHistoryPage()),
                          ),
                        }
                    },
                  ),
                ),
              )));
    });
  }

  void animatedNavigation(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return SearchRidesModal(
            rideType: Ride_Type.MOVE,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
