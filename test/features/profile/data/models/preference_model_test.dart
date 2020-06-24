import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  // final preferenceJson = json.decode(fixture("preference_with_null_fixture.json"));
  final preferenceJson = json.decode(fixture("preference_fixture.json"));
  final preferenceModel = PreferenceModel(
    id: 468, 
    genderPref: [], countryPref: [], religionPref: [], coursePref: [],
    agePrefMin: 18, agePrefMax: 49,
    matricYearPrefMin: 2010, matricYearPrefMax: 2018,
    daysToMatch: 1, interestedFlag: true
  );

  test("should_convert_to_and_from_json_successfully", (){
    final model = PreferenceModel.fromJson(preferenceJson);
    expect(model, preferenceModel);
    final json = model.toJson();
    preferenceJson.remove('timestamp');
    expect(json, preferenceJson);
  });

}