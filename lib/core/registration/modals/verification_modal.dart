import 'dart:developer';

import 'package:ambition_app/Utils/helpers.dart';
import 'package:ambition_app/config/sizeconfig/size_config.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/network/resources.dart';
import '../../auth/widgets/login_button.dart';

import '../../home/widgets/verification_step.dart';

import '../../ride/viewmodel/map_view_model.dart';
import '../viewmodel/registration_viewmodel.dart';

class VehicleInfoModal extends StatefulWidget {
  final Function()? onCloseTap;
  final Function(String)? onErrorOccurred;

  const VehicleInfoModal({super.key, this.onCloseTap, this.onErrorOccurred});

  @override
  _VehicleInfoModalState createState() => _VehicleInfoModalState();
}

bool isSaved = false;
typedef SaveData1 = void Function(
  BuildContext ctx,
  String? niNumberFrontImage,
  String? niNumberBackImage,
  String? drivingLicenseFrontImage,
  String? drivingLicenseBackImage,
  DateTime? nIIssuanceDate,
  DateTime? nIExpiryDate,
  DateTime? driverIssuanceDate,
  DateTime? driverExpiryDate,
  String? selectedAccountType,
  String? companyName,
  String? comapnyNo,
  String? goodInTransit,
  String? commercialVehicle,
  String? proofOfAddress,
  String? profilePhoto,
);

typedef SaveData2 = void Function(
    BuildContext ctx, String proofAdrPhotoUrl, String profilePhotUrl);

class _VehicleInfoModalState extends State<VehicleInfoModal> {
  SizeConfig sizeConfig = SizeConfig();
  int _activeStepIndex = 0;
  final PageController _pageController = PageController();

  Map<String, dynamic> formData = {};

  void handleSave1(
    BuildContext ctx,
    String? niNumberFrontImage,
    String? niNumberBackImage,
    String? drivingLicenseFrontImage,
    String? drivingLicenseBackImage,
    DateTime? nIIssuanceDate,
    DateTime? nIExpiryDate,
    DateTime? driverIssuanceDate,
    DateTime? driverExpiryDate,
    String? selectedAccountType,
    String? companyName,
    String? companyNo,
    String? goodInTransit,
    String? commercialVehicle,
    String? proofOfAddress,
    String? profilePhoto,
  ) {
    setState(() {
      isSaved = true;
    });
    final RegistrationViewModel regViewModel =
        Provider.of<RegistrationViewModel>(ctx, listen: false);
    regViewModel.registerDriver(
      niNumberFrontImage: niNumberFrontImage,
      niNumberBackImage: niNumberBackImage,
      niNumberIssueDate: formatDate(nIIssuanceDate),
      niNumberExpireDate: formatDate(nIExpiryDate),
      drivingLicenseFrontImage: drivingLicenseFrontImage,
      drivingLicenseBackImage: drivingLicenseBackImage,
      drivingLicenseIssueDate: formatDate(driverIssuanceDate),
      drivingLicenseExpireDate: formatDate(driverExpiryDate),
      goodInTransit: goodInTransit,
      commercialVehicle: commercialVehicle,
      profilePicture: profilePhoto,
      proof0fAddress: proofOfAddress,
      account: selectedAccountType,
      isVerified: true,
    );
  }

  List<Step> stepList(
      BuildContext context, bool isSaved, RegistrationViewModel regViewModel) {
    return [
      Step(
        title: const Text(
          'Upload Images',
        ),
        content: VerificationStep(
          config: sizeConfig,
          ctx: context,
          isSaved: isSaved,
          onSave: handleSave1,
        ),
      ),
      Step(
        title: const Text('Vehicle Information'),
        content: VehicleInformationStep1(
            config: sizeConfig, isSaved: isSaved, viewModel: regViewModel),
      ),
    ];
  }

  void _goToStep(int stepIndex, RegistrationViewModel regViewModel) {
    setState(() {
      isSaved = false;

      _activeStepIndex = stepIndex;
      _pageController.jumpToPage(_activeStepIndex);
    });
    if (_activeStepIndex == 3) {}
  }

  @override
  Widget build(BuildContext context) {
    final RegistrationViewModel regViewModel =
        context.watch<RegistrationViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.LM_BACKGROUND_BASIC,
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.BLACK,
            size: 26,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: sizeConfig.uiHeightPx * 1,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                children: stepList(context, isSaved, regViewModel)
                    .map((step) => step.content)
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: sizeConfig.uiHeightPx * 0.06,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_activeStepIndex > 0 &&
                        _activeStepIndex <
                            stepList(context, isSaved, regViewModel).length -
                                1 &&
                        isSaved)
                      SizedBox(
                        width: sizeConfig.uiWidthPx * 0.4,
                        child: LoginButton(
                          text: 'Previous',
                          isSecondary: true,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          onPress: () {
                            _goToStep(_activeStepIndex - 1, regViewModel);
                          },
                        ),
                      ),
                    if (_activeStepIndex <
                            stepList(context, isSaved, regViewModel).length -
                                1 &&
                        isSaved)
                      SizedBox(
                        width: sizeConfig.uiWidthPx * 0.4,
                        child: LoginButton(
                          text: 'Next',
                          isSecondary: true,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          onPress: () {
                            _goToStep(_activeStepIndex + 1, regViewModel);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleInformationStep1 extends StatefulWidget {
  final SizeConfig config;
  final RegistrationViewModel viewModel;
  bool isSaved;

  VehicleInformationStep1({
    Key? key,
    required this.config,
    required this.viewModel,
    required this.isSaved,
  }) : super(key: key);

  @override
  _VehicleInformationStep1State createState() =>
      _VehicleInformationStep1State();
}

class _VehicleInformationStep1State extends State<VehicleInformationStep1> {
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController vehicleColorController = TextEditingController();
  final TextEditingController vehicleRegistrationController =
      TextEditingController();
  final TextEditingController pcoLicenseController = TextEditingController();

  String selectedName = 'ford';
  @override
  Widget build(BuildContext context) {
    MapViewModel mViewModel = Provider.of<MapViewModel>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Vehicle Information',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.BLACK)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: TextFormField(
            controller: vehicleModelController,
            decoration: textFieldDecoration('Vehicle Name'),
          ),
        ),
        SizedBox(
          width: widget.config.uiWidthPx * 0.8,
          child: DropdownButtonFormField<String>(
            // value: selectedName,
            decoration: const InputDecoration(
              hintText: 'Select Vehicle',
              labelStyle: TextStyle(color: AppColors.BLACK),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.BLACK),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.BLACK),
              ),
            ),
            style: const TextStyle(color: AppColors.BLACK),
            items: mViewModel.vehicles
                .map((vehicle) => DropdownMenuItem<String>(
                      value: vehicle.name,
                      child: Text(vehicle.name),
                    ))
                .toList(),
            onChanged: (selectedVehicle) {
              setState(() {
                selectedName = selectedVehicle ?? mViewModel.vehicles[0].name;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: TextFormField(
            controller: vehicleColorController,
            decoration: textFieldDecoration('Vehicle Color'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: TextFormField(
            controller: vehicleRegistrationController,
            decoration: textFieldDecoration('Vehicle Registration Number'),
          ),
        ),
        SizedBox(
          height: widget.config.uiHeightPx * 0.04,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(16),
          child: TextFormField(
            controller: pcoLicenseController,
            decoration: textFieldDecoration('PCO License Number'),
          ),
        ),
        SizedBox(
          height: widget.config.uiHeightPx * 0.04,
        ),
        SizedBox(
          width: widget.config.uiWidthPx * 0.8,
          child: LoginButton(
            text: 'Done',
            isLoading: widget.viewModel.registerVehicleResource.ops ==
                NetworkStatus.LOADING,
            isSecondary: true,
            onPress: () {
              widget.viewModel.registerVehicle(
                  make: selectedName,
                  color: vehicleColorController.text,
                  licensePlate: vehicleRegistrationController.text,
                  pcoLicense: pcoLicenseController.text);
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }
}

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
      counterText: "",
      contentPadding: const EdgeInsets.all(10),
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(
        color: AppColors.grey9,
        fontSize: 12,
      ),
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.BLACK,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.BLACK.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.BLACK,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.BLUE,
        ),
        borderRadius: BorderRadius.circular(5),
      ));
}
