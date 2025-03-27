import 'dart:math';

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // For now past preferences are fetched only 1 time
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

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

  void _addPreference(RidePreference preference) {
    _pastPreferences.remove(preference);
    _pastPreferences.add(preference);
  }
}
