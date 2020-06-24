import 'dart:convert';

import 'package:clean_ntmu/features/matchings/data/models/matching_model.dart';
import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final matchingJson = json.decode(fixture("matches_fixture.json"));
  final MatchingModel expectedModel = MatchingModel(
    id: 371,
    oppProfile: ProfileModel.fromJson(matchingJson[0]["user_2"]),
    selfIsUser1: true,
    description: "No users currently matches your preference, the match provided will only follow your gender preferences.",
    selfChoice: 1,
    oppChoice: 0,
  );
  final expectedJson = {
    "id": 371,
    "user_2": (expectedModel.oppProfile as ProfileModel).toJson(),
    "user_1_choice": 1,
    "user_2_choice": 0,
    "description": "No users currently matches your preference, the match provided will only follow your gender preferences.",
  };

  test("should_convert_to_and_from_json_successfully", (){
    final resultModel = MatchingModel.fromJson(matchingJson[0]);
    expect(resultModel, expectedModel);
    final resultJson = resultModel.toJson();
    expect(resultJson, expectedJson);
  });
}