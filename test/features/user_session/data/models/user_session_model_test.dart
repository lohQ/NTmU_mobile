import 'dart:convert';

import 'package:clean_ntmu/features/user_session/data/models/user_session_model.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';


void main() {

  UserSessionModel tUserSessionModel = UserSessionModel(token: "u001_token");

  test("should_be_a_subclass_of_UserSession", (){
    expect(tUserSessionModel, isA<UserSession>());
  });

  final Map<String,dynamic> accountJson = json.decode(fixture("user_session_fixture.json"));

  test("UserSessionModel.fromJson_should_return_correct_UserSessionModel", () async {
    final result = UserSessionModel.fromJson(accountJson);
    expect(result, tUserSessionModel);
  });

  test("UserSessionModel.toJson_should_return_corrent_json_map", () async {
    final result = tUserSessionModel.toJson();
    expect(result, accountJson);
  });
}