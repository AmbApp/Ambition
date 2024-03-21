// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:ambition_app/Utils/helpers.dart';
import 'package:ambition_app/core/auth/screens/auth_screen.dart';
import 'package:ambition_app/core/home/screens/home_screen.dart';
import 'package:ambition_app/core/profile/viewmodel/profile_viewmodel.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/colors.dart';

import 'Utils/device_info_service.dart';

import 'Utils/styles.dart';
import 'config/network/network_config.dart';
import 'config/sizeconfig/size_config.dart';
import 'core/auth/provider/login_store.dart';

import 'core/notifications/services/notifications_model.dart';
import 'core/notifications/widgets/withNotification.dart';
import 'core/registration/viewmodel/registration_viewmodel.dart';

import 'core/ride/modals/add_payment_modal.dart';
import 'core/ride/viewmodel/map_view_model.dart';
import 'firebase_options.dart';

late SharedPreferences sharedPreferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NetworkConfig().initNetworkConfig();
  await _initLocationService();
  await _getDeviceInfo();

  Stripe.publishableKey =
      'pk_live_51OFdEPJlb4GNIzMo4proLNzjMxCQTyIrKvkao5G2L1tw86LLw8GdMmoj3pPRmP4v7mZKiICiUiYOYfkRYqLzl1j200utRNEexq';

  await dotenv.load(fileName: 'assets/.env');

  runApp(App());
}

Future _getDeviceInfo() async {
  sharedPreferences = await SharedPreferences.getInstance();
  // sharedPreferences.clear(); // uncomment if need to login at each time
  final DeviceInformation? deviceInformation =
      await DeviceInfoService.getDeviceInfo();
  sharedPreferences.setString(
      "deviceId", deviceInformation?.uUID.toString() ?? '');
  sharedPreferences.setString(
      "deviceInfo", deviceInformation?.toJson().toString() ?? '');
}

Future _initLocationService() async {
  var location = loc.Location();

  if (!await location.serviceEnabled()) {
    if (!await location.requestService()) {
      return;
    }
  }

  var permission = await location.hasPermission();
  if (permission == PermissionStatus.denied) {
    permission = await location.requestPermission();
    if (permission != PermissionStatus.granted) {
      return;
    }
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: AppColors.PRIMARY_500,
      ),
    );

    return MultiProvider(
        providers: [
          Provider<LoginStore>(
            create: (_) => LoginStore(),
          ),
          ChangeNotifierProvider<MapViewModel>(
            create: (_) => MapViewModel(),
          ),
          ChangeNotifierProvider<NotificationsModel>(
            create: (_) => NotificationsModel(),
          ),
          ChangeNotifierProvider<RegistrationViewModel>(
            create: (_) => RegistrationViewModel(),
          ),
          ChangeNotifierProvider<ProfileViewModel>(
            create: (_) => ProfileViewModel(),
          ),
        ],
        child: Consumer<LoginStore>(
          builder: (ctx, auth, _) {
            auth.loadInitialDataFromSharedPreferences();
            return MaterialApp(
              supportedLocales: const [
                Locale('en', ''),
                Locale('de', ''),
              ],
              title: 'Ambition App',
              navigatorKey: Get.key,
              debugShowCheckedModeBanner: false,
              theme: Styles.lightTheme,
              home: WithNotifications(
                key: UniqueKey(),
                child: Builder(
                  builder: (context) {
                    final Size size = MediaQuery.of(context).size;
                    SizeConfig.init(
                      context,
                      height: size.height,
                      width: size.width,
                      allowFontScaling: true,
                    );
                    return Builder(
                      builder: (context) {
                        return isAuthenticated ? HomeScreen() : AuthScreen();
                      },
                    );
                  },
                ),
              ),
            );
          },
        ));
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString("accessToken");
    logger("accessToken");
    logger(accessToken.toString());
    setState(() {
      isAuthenticated = accessToken != null;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    checkAuthenticationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
