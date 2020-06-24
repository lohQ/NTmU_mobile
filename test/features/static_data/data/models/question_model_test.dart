import 'dart:convert';

import 'package:clean_ntmu/features/static_data/data/models/question_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final Iterable questionJson = json.decode(fixture("questions_fixture.json"));
  final expectedResult = [
    QuestionModel(
      id: 20,
      name: "I would continue to use NTmU after its official release.",
      answerType: int
    ),
    QuestionModel(
      id: 21,
      name: "I would recommend NTmU to my friends.",
      answerType: int
    ),
    QuestionModel(
      id: 22,
      name: "What do you like the most about NTmU?",
      answerType: String
    ),
    QuestionModel(
      id: 23,
      name: "What do you like the least about NTmU?",
      answerType: String
    )
  ];

  test("should_convert_to_QuestionModel_successfully", (){
    final result = List.from(questionJson).map((json)=>QuestionModel.fromJson(json)).toList();
    expect(result, expectedResult);
  });

}