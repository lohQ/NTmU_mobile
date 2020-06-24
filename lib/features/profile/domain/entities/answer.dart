import 'package:clean_ntmu/features/static_data/domain/entities/question.dart';
import 'package:meta/meta.dart';

class Answer {
  final Question question;
  dynamic answer;

  Answer({
    @required this.question, 
    @required this.answer 
  }) : assert(answer.runtimeType == question.answerType);

  void modifyAnswer(dynamic newAnswer){
    if(newAnswer.runtimeType == question.answerType){
      answer = newAnswer;
    }else{
      throw Exception("type ${newAnswer.runtimeType} is not type ${question.answerType}");
    }
  }

}

enum Choice {
  strongly_agree,
  agree,
  neutral,
  disagree,
  strongly_disagree
}

