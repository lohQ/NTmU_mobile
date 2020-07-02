import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:clean_ntmu/features/static_data/data/data_sources/static_data_local_data_source.dart';
import 'package:clean_ntmu/features/static_data/data/repositories/server_data_repostiory_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final profileJson = json.decode(fixture("profile_fixture.json"));
  final profileModel = ProfileModel(
    id: 310,
    fullname: "Royston Beh Zhi Yang",
    gender: "Male", 
    description: "Me is Beh. Me love to sleep. Don't disturb me zzz", 
    hobbies: ["American football", "Astronomy", "Basketball", "Body Building"], 
    dateOfBirth: DateTime.parse("1995-11-15"), 
    country: "Singapore", 
    religion: "Christianity", 
    course: "Materials Engineering And Economics\n", 
    matricYear: 2018, 
    photoUrl: "http://10.0.2.2:8000/media/profile_image/image_picker9017397231703990920.jpg", 
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await StaticDataRepositoryImpl(localDataSource: StaticDataLocalDataSource()).loadDataFromFile();
  });

  test("should_convert_to_and_from_json_successfully", (){
    final model = ProfileModel.fromJson(profileJson);
    expect(model, profileModel);
    final json = model.toJson();
    profileJson.remove('days_to_match');
    profileJson.remove('reporter');
    json.remove('date_of_birth');
    profileJson.remove('date_of_birth');
    expect(json, profileJson);
  });

}