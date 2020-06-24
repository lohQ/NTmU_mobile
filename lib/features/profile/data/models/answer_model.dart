import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/question.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';

class AnswerModel extends Answer {

  AnswerModel(Question question, dynamic answer) : super(question: question, answer: answer);

  factory AnswerModel.fromQuestion(Question q){
    if(q.answerType == String){
      return AnswerModel(q, "");
    }else if(q.answerType == Choice){
      return AnswerModel(q, Choice.neutral);
    }
    throw Exception("failed to return AnswerModel from question, invalid type ${q.answerType}");
  }

  factory AnswerModel.fromJson(Map<String,dynamic> json){
    final question = StaticData().data['questions'].firstWhere((q)=>(q.id==json["question"]));
    final answer = json['answer'] is int ? _mapIntToChoice(json['answer']) : json['answer'];
    return AnswerModel(
      question as Question,
      answer
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "question": question.id,
      "answer": answer.runtimeType==Choice ? _mapChoiceToInt(answer) : answer
    };
  }

  static int _mapChoiceToInt(Choice choice){
    if(choice == Choice.strongly_agree){
      return 1;
    }else if(choice == Choice.agree){
      return 2;
    }else if(choice == Choice.neutral){
      return 3;
    }else if(choice == Choice.disagree){
      return 4;
    }else if(choice == Choice.strongly_disagree){
      return 5;
    }
    throw Exception("invalid choice value, failed to convert to integer");
  }

  static Choice _mapIntToChoice(int choice){
    if(choice == 1){
      return Choice.strongly_agree;
    }else if(choice == 2){
      return Choice.agree;
    }else if(choice == 3){
      return Choice.neutral;
    }else if(choice == 4){
      return Choice.disagree;
    }else if(choice == 5){
      return Choice.strongly_disagree;
    }
    throw Exception("invalid choice value, failed to convert to Choice enum");
  }

}
