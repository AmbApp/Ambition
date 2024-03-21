import 'dart:io';

import 'package:ambition_app/core/registration/modals/verification_modal.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/helpers.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../auth/widgets/login_button.dart';
import '../../ride/viewmodel/map_view_model.dart';
import '../../widgets/custom_text_field.dart';
import 'custom_date_picker.dart';
import 'custom_image_form_field.dart';

class VerificationStep extends StatefulWidget {
  final SizeConfig config;
  final BuildContext ctx;
  final SaveData1 onSave;
  final bool isSaved;

  const VerificationStep({
    Key? key,
    required this.config,
    required this.ctx,
    required this.isSaved,
    required this.onSave,
  });

  @override
  _VerificationStepState createState() => _VerificationStepState();
}

class _VerificationStepState extends State<VerificationStep> {
  String niNumberFrontImageUrl = '1';
  String niNumberBackImageUrl = '2';
  String drivingLicenseFrontImageUrl = '';
  String drivingLicenseBackImageUrl = '';

  int selectedVanIdx = 0;
  String selectedAccountType = 'personal';

  DateTime? nIIssuanceDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? nIExpiryDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? driverIssuanceDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime? driverExpiryDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool showAdditionalFields = false;

  Future<String?> uploadFile(File? photo) async {
    if (photo == null) return '';
    final fileName = basename(photo.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(photo);

      String url = (await ref.getDownloadURL()).toString();
      return url;
    } catch (e) {
      logger('error occurred');
      return '';
    }
  }

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController comapnyNoController = TextEditingController();
  final TextEditingController goodInTransitController = TextEditingController();
  final TextEditingController commercialVehicleController =
      TextEditingController();

  File? proofAdrPhoto;
  File? profilePhoto;

  String proofAdrPhotoUrl = '';
  String profilePhotUrl = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: widget.config.uiWidthPx * 0.22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.PRIMARY_500,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "New",
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.WHITE,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 2, left: 2, right: 2, bottom: 2),
              child: CupertinoSegmentedControl(
                unselectedColor: AppColors.WHITE,
                selectedColor: AppColors.PRIMARY_500.withOpacity(0.3),
                borderColor: AppColors.PRIMARY_500,
                children: const {
                  'personal': Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Personal Van/Car",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.BLACK))),
                  'business': Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Business/Company Van",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.BLACK))),
                },
                groupValue: selectedAccountType,
                onValueChanged: (value) {
                  setState(() {
                    selectedAccountType = value.toString();
                    if (selectedAccountType == 'business') {
                      showAdditionalFields = true;
                    } else {
                      showAdditionalFields = false;
                    }
                  });
                },
              ),
            ),
            if (showAdditionalFields)
              Column(
                children: [
                  SizedBox(height: widget.config.uiHeightPx * 0.01),
                  CustomPlaceTextWidget(
                    hintText: "Company Name",
                    onSubmitted: (value) {},
                    fillColor: AppColors.WHITE,
                    borderColor: AppColors.PRIMARY_500,
                    controller: companyNameController,
                    config: widget.config,
                  ),
                ],
              ),
            SizedBox(height: widget.config.uiHeightPx * 0.03),
            Text('Upload Images',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.BLACK)),
            SizedBox(height: widget.config.uiHeightPx * 0.03),
            CustomImageFormField(
              label: 'NI Number Front Image',
              onChanged: (file) async {
                niNumberFrontImageUrl = await uploadFile(file) ?? "";
              },
            ),
            CustomImageFormField(
              label: 'NI Number Back Image',
              onChanged: (file) async {
                niNumberBackImageUrl = await uploadFile(file) ?? "";
              },
            ),
            Row(children: [
              Flexible(
                  flex: 2,
                  child: CustomDatePicker(
                      context: context,
                      date: nIIssuanceDate,
                      text: 'Enter Issue Date',
                      updateDate: (newDate) {
                        setState(() {
                          nIIssuanceDate = newDate;
                        });
                      },
                      config: widget.config)),
              Flexible(
                  flex: 2,
                  child: CustomDatePicker(
                      context: context,
                      date: nIExpiryDate,
                      text: 'Enter Expiry Date',
                      updateDate: (newDate) {
                        setState(() {
                          nIExpiryDate = newDate;
                        });
                      },
                      config: widget.config)),
            ]),
            SizedBox(height: widget.config.uiHeightPx * 0.04),
            CustomImageFormField(
              label: 'Driving License Front Image',
              onChanged: (file) async {
                drivingLicenseFrontImageUrl = await uploadFile(file) ?? '';
              },
            ),
            CustomImageFormField(
              label: 'Driving License Back Image',
              onChanged: (file) async {
                drivingLicenseBackImageUrl = await uploadFile(
                      file,
                    ) ??
                    '';
              },
            ),
            Row(children: [
              Flexible(
                  flex: 2,
                  child: CustomDatePicker(
                      context: context,
                      date: driverExpiryDate,
                      text: 'Enter Expiry Date',
                      updateDate: (newDate) {
                        setState(() {
                          driverExpiryDate = newDate;
                        });
                      },
                      config: widget.config)),
              Flexible(
                  flex: 2,
                  child: CustomDatePicker(
                      context: context,
                      date: driverExpiryDate,
                      text: 'Enter Expiry Date',
                      updateDate: (newDate) {
                        setState(() {
                          driverExpiryDate = newDate;
                        });
                      },
                      config: widget.config)),
            ]),
            SizedBox(height: widget.config.uiHeightPx * 0.06),
            CustomImageFormField(
              label: 'Proof of Address',
              onChanged: (file) async {
                proofAdrPhotoUrl = await uploadFile(file) ?? '';
              },
            ),
            CustomImageFormField(
              label: 'Profile Photo',
              onChanged: (file) async {
                profilePhotUrl = await uploadFile(file) ?? '';
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: TextFormField(
                controller: goodInTransitController,
                decoration:
                    textFieldDecoration('Good In Transit Insurance number'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              child: TextFormField(
                controller: commercialVehicleController,
                decoration:
                    textFieldDecoration('Commercial vehicle Insurance number'),
              ),
            ),
            SizedBox(
              height: widget.config.uiHeightPx * 0.04,
            ),
            if (true
                // niNumberFrontImageUrl.isNotEmpty &&
                //   niNumberBackImageUrl.isNotEmpty &&
                //   drivingLicenseFrontImageUrl.isNotEmpty &&
                //   drivingLicenseBackImageUrl.isNotEmpty &&
                //   proofAdrPhotoUrl.isNotEmpty &&
                //   profilePhotUrl.isNotEmpty
                )
              SizedBox(
                width: widget.config.uiWidthPx * 0.8,
                child: LoginButton(
                  text: 'save',
                  isSecondary: true,
                  onPress: () {
                    widget.onSave(
                        widget.ctx,
                        niNumberFrontImageUrl,
                        niNumberBackImageUrl,
                        drivingLicenseFrontImageUrl,
                        drivingLicenseBackImageUrl,
                        nIIssuanceDate,
                        nIExpiryDate,
                        driverIssuanceDate,
                        driverExpiryDate,
                        selectedAccountType,
                        companyNameController.text,
                        comapnyNoController.text,
                        goodInTransitController.text,
                        commercialVehicleController.text,
                        proofAdrPhotoUrl,
                        profilePhotUrl);
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
