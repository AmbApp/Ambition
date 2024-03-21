import 'dart:developer';

import 'package:ambition_app/core/registration/modals/verification_modal.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../config/sizeconfig/size_config.dart';
import '../../ride/viewmodel/map_view_model.dart';
import '../../widgets/custom_toast.dart';

class RegistrationModal extends StatefulWidget {
  final Function()? onCloseTap;
  final Function(String)? onErrorOccurred;

  const RegistrationModal({Key? key, this.onCloseTap, this.onErrorOccurred})
      : super(key: key);

  @override
  ReferenceNumberBottomSheetState createState() =>
      ReferenceNumberBottomSheetState();
}

class ReferenceNumberBottomSheetState extends State<RegistrationModal> {
  SizeConfig config = SizeConfig();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      MapViewModel mViewModel =
          Provider.of<MapViewModel>(context, listen: false);
      await mViewModel.getVehicles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1,
      minChildSize: 1,
      expand: false,
      initialChildSize: 1,
      builder: (BuildContext context, ScrollController controller) {
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
          body: SingleChildScrollView(
            child: Container(
              color: AppColors.LM_BACKGROUND_BASIC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: config.sh(20).toDouble(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: config.uiHeightPx * 0.06,
                      left: 16,
                      right: 16,
                      bottom: config.uiHeightPx * 0.02,
                    ),
                    child: Text(
                      "Get ready for more earning oppurtunities",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: config.uiHeightPx * 0.06,
                      left: 16,
                      right: 16,
                      bottom: config.uiHeightPx * 0.02,
                    ),
                    child: Text(
                      "Here at Ambition we will provide you tips to make evry move as smooth as possible",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: config.uiHeightPx * 0.1,
                  ),
                  ChecklistItem(
                    text: "Personal Information",
                    isChecked: true,
                  ),
                  ChecklistItem(
                    text: "DLVA, NI, License",
                    isChecked: true,
                  ),
                  ChecklistItem(
                    text: "Vehicle Information",
                    isChecked: true,
                  ),
                  SizedBox(
                    height: config.uiHeightPx * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleInfoModal(
                              onErrorOccurred: (error) {
                                customToastBlack(
                                    msg: "Error while updating order: $error");
                              },
                              onCloseTap: () {
                                log('onCloseTap');
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          width: SizeConfig.screenWidthDp,
                          height: config.sh(40).toDouble(),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: const LinearGradient(
                              colors: AppColors.GRADIENTS,
                              stops: [
                                0.1,
                                0.9,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: config.uiWidthPx * 0.06),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: config.uiWidthPx * 0.06),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.white,
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
          ),
        );
      },
    );
  }
}

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool isChecked;

  ChecklistItem({required this.text, this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: isChecked
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                ),
          title: Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}
