import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final profileJson = json.decode(fixture("profile_fixture.json"));
  final profileModel = ProfileModel(
    id: 316,
    fullname: "Chia Ching Chuen",
    gender: "Male", 
    description: "Hello, My name is Ching Chuen and i am looking for more friends to talk about everything in life, sing songs and go out for movies and enjoyable things!", 
    hobbies: ["Badminton", "Gaming", "Rock climbing"], 
    dateOfBirth: DateTime.parse("1994-09-11"), 
    country: "Singapore", 
    religion: "Buddhism", 
    course: "Computer Science\n", 
    matricYear: 2016, 
    photoUrl: "http://127.0.0.1:8000/media/profile_image/CCC_Headshot_uQScBan.jpg", 
  );

  test("should_convert_to_and_from_json_successfully", (){
    final model = ProfileModel.fromJson(profileJson);
    expect(model, profileModel);
    final json = model.toJson();
    profileJson.remove('days_to_match');
    profileJson.remove('userpreference_set');
    profileJson.remove('reporter');
    json.remove('date_of_birth');
    profileJson.remove('date_of_birth');
    expect(json, profileJson);
  });

}