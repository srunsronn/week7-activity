import 'dart:math';

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    _fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  Future<void> _fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- fetch data
      List<RidePreference> pastPref = await repository.getPastPreferences();

      // 3- Handle success
      pastPreferences = AsyncValue.success(pastPref);
    } catch (error) {
      // 4- Handle error
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  // Set the current preference
  void setCurrentPreferrence(RidePreference pref) {
    // 1 - Process only if the new preference is not equal to the current one
    if (_currentPreference == pref) return;

    // 2 - Update the current preference
    _currentPreference = pref;

    // 3 - Update the history
    _addPreference(pref);

    // 4 - Notify listeners
    notifyListeners();
  }

  Future<void> _addPreference(RidePreference preference) async {
    // I choose the second approach to add the new preference to the history
    // because it avoids an additional fetch from the repository, making the
    // operation faster and more efficient. By directly updating the provider's
    // cache, we reduce the load on the database or backend and ensure the UI
    // is updated immediately.
    try {
      await repository.addPreference(preference);
      List<RidePreference> updatedList = List.from(pastPreferences.data ?? []);
      updatedList.add(preference);
      pastPreferences = AsyncValue.success(updatedList);

      notifyListeners();
    } catch (error) {
      // Handle error
      pastPreferences = AsyncValue.error(error);
      notifyListeners();
    }
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory {
    if (pastPreferences.state == AsyncValueState.success) {
      return pastPreferences.data!.reversed.toList();
    }
    return [];
  }
}
