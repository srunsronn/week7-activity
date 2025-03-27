import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/rides_preferences_provider.dart';
import 'package:week_3_blabla_project/service/rides_service.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onPreferencePressed(BuildContext context) async {
    final ridesPreferencesProvider = context.read<RidesPreferencesProvider>();
    final currentPreference = ridesPreferencesProvider.currentPreference;

    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference!),
      ),
    );

    if (newPreference != null) {
      ridesPreferencesProvider.setCurrentPreferrence(newPreference);
    }
  }

  void onFilterPressed() {
    // Implement filter logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesPreferencesProvider>(
      builder: (context, ridesPreferencesProvider, child) {
        // Get the current preference
        final RidePreference currentRidePreference =
            ridesPreferencesProvider.currentPreference!;

        // Get the list of available rides regarding the current preference
        final RideFilter currentFilter = RideFilter();
        final List<Ride> availableRides = RidesService.instance
            .getRidesFor(currentRidePreference, currentFilter);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
              left: BlaSpacings.m,
              right: BlaSpacings.m,
              top: BlaSpacings.s,
            ),
            child: Column(
              children: [
                RidePrefBar(
                  ridePreference: currentRidePreference,
                  onBackPressed: () => onBackPressed(context),
                  onPreferencePressed: () => onPreferencePressed(context),
                  onFilterPressed: onFilterPressed,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableRides.length,
                    itemBuilder: (ctx, index) => RideTile(
                      ride: availableRides[index],
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
