import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/dto/ride_preferences_dto.dart';
import '/data/repository/ride_preferences_repository.dart';
import '/model/ride/ride_pref.dart';

class LocalRidePreferencesRepository implements RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    final currentPreferences = await getPastPreferences();

    currentPreferences.add(preference);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _preferencesKey,
      currentPreferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }
}
