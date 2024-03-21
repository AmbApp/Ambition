import 'package:ambition_app/core/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/colors.dart';
import '../../../Utils/helpers.dart';

class RideHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileViewModel viewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    logger('klist');
    logger(viewModel.rideHistory.toString());

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.LM_BACKGROUND_BASIC,
          centerTitle: true,
          title: const Text("Ride History",
              style: TextStyle(
                  color: AppColors.BLACK,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
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
        body: Consumer<ProfileViewModel>(
            builder: (BuildContext context, ProfileViewModel viewModel, _) {
          if (viewModel.rideHistory.isNotEmpty) {
            return ListView.builder(
              itemCount: viewModel.rideHistory.length,
              itemBuilder: (context, index) {
                final ride = viewModel.rideHistory[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                        //  backgroundImage: NetworkImage(ride.driverImageUrl),
                        ),
                    title:
                        Text('\$${ride.rideStatus} - ${ride.rideStatus} miles'),
                    subtitle: Text(
                        '${ride.sourceCoordinates} to ${ride.destinationCoordinates}'),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Text(
              'No ride history found',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.BLACK,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
            ));
          }
        }));
  }
}
