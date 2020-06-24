import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/answer_model.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/static_data/data/models/question_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final Iterable questionJson = json.decode(fixture("questions_fixture.json"));
  final questions = questionJson.map((json)=>QuestionModel.fromJson(json)).toList();

  test("should_create_AnswerModel_from_Question", (){
    final expectedResult = [
      AnswerModel(questions[0], Choice.neutral),
      AnswerModel(questions[1], Choice.neutral),
      AnswerModel(questions[2], ""),
      AnswerModel(questions[3], ""),
    ];
    final result = questions.map((q)=>AnswerModel.fromQuestion(q)).toList();
    expect(result, expectedResult);
  });

  test("should_create_modified_model_successfully_if_type_correct", (){
    final answers = questions.map((q)=>AnswerModel.fromQuestion(q)).toList();
    final expectedChoiceResult = AnswerModel(questions[0], Choice.strongly_disagree);
    answers[0].modifyAnswer(Choice.strongly_disagree);
    expect(answers[0], expectedChoiceResult);
    final expectedTextResult = AnswerModel(questions[2], "newAnswer");
    answers[2].modifyAnswer("newAnswer");
    expect(answers[2], expectedTextResult);
  });

  test("should_throw_exception_if_incorrect_data_type", (){
    final answers = questions.map((q)=>AnswerModel.fromQuestion(q)).toList();
    expect(()=>answers[0].modifyAnswer("3"), throwsA(isInstanceOf<AssertionError>()));
    expect(()=>answers[2].modifyAnswer(Choice.strongly_agree), throwsA(isInstanceOf<AssertionError>()));
  });

}