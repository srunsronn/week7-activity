import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import 'package:week_3_blabla_project/ui/providers/rides_preferences_provider.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import 'package:provider/provider.dart';
import '../../widgets/errors/bla_error_screen.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // Access the provider and update the current preference
    final ridesPreferencesProvider = context.read<RidesPreferencesProvider>();
    ridesPreferencesProvider.setCurrentPreferrence(newPreference);

    // Navigate to the RidesScreen
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesPreferencesProvider>(
      builder: (context, ridesPreferencesProvider, child) {
        // Handle the states of pastPreferences
        final pastPreferencesState = ridesPreferencesProvider.pastPreferences;

        if (pastPreferencesState.state == AsyncValueState.loading) {
          // Show a loading message
          return const BlaError(message: 'Loading...');
        }

        if (pastPreferencesState.state == AsyncValueState.error) {
          // Show an error message
          return const BlaError(message: 'No connection. Try later.');
        }

        if (pastPreferencesState.state == AsyncValueState.success) {
          // Get the current preference and history from the provider
          final RidePreference? currentRidePreference =
              ridesPreferencesProvider.currentPreference;
          final List<RidePreference> pastPreferences =
              ridesPreferencesProvider.preferencesHistory;

          return Stack(
            children: [
              // Background image
              const BlaBackground(),

              // Foreground content
              Column(
                children: [
                  SizedBox(height: BlaSpacings.m),
                  Text(
                    "Your pick of rides at low price",
                    style: BlaTextStyles.heading.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 100),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Ride preference form
                        if (currentRidePreference != null)
                          RidePrefForm(
                            initialPreference: currentRidePreference,
                            onSubmit: (newPreference) =>
                                onRidePrefSelected(context, newPreference),
                          ),
                        SizedBox(height: BlaSpacings.m),

                        // History of past preferences
                        if (pastPreferences.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: pastPreferences.length,
                              itemBuilder: (ctx, index) => RidePrefHistoryTile(
                                ridePref: pastPreferences[index],
                                onPressed: () => onRidePrefSelected(
                                    context, pastPreferences[index]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Fallback in case no state matches (shouldn't happen)
        return const SizedBox.shrink();
      },
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
