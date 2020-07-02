import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
import 'package:clean_ntmu/features/static_data/data/data_sources/static_data_local_data_source.dart';
import 'package:clean_ntmu/features/static_data/data/repositories/server_data_repostiory_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  // final preferenceJson = json.decode(fixture("preference_with_null_fixture.json"));
  final preferenceJson = json.decode(fixture("preference_fixture.json"));
  final preferenceModel = PreferenceModel(
    id: 422, 
    genderPref: ["Female", "Male"], countryPref: ["Malaysia"], religionPref: [], coursePref: ["Business\n"],
    agePrefMin: 20, agePrefMax: 25,
    matricYearPrefMin: 2016, matricYearPrefMax: 2019,
    daysToMatch: 1, interestedFlag: true
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await StaticDataRepositoryImpl(localDataSource: StaticDataLocalDataSource()).loadDataFromFile();
  });

  test("should_convert_to_and_from_json_successfully", (){
    final model = PreferenceModel.fromJson(preferenceJson);
    expect(model, preferenceModel);
    final json = model.toJson();
    preferenceJson.remove('timestamp');
    expect(json, preferenceJson);
  });

}