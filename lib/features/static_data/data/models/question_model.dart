import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/question.dart';
import 'package:meta/meta.dart';

class QuestionModel extends Question {
  QuestionModel({
    @required int id, 
    @required String name, 
    @required Type answerType}) : super(id: id, name: name, answerType: answerType);

  factory QuestionModel.fromJson(Map<String,dynamic> json){
    return QuestionModel(
      id: json["id"],
      name: json["question"],
      answerType: _mapContenttypeToType(json["answer_type"])
    );
  }

  static Type _mapContenttypeToType(int contenttype){
    if(contenttype == 45){
      return Choice;
    }else if(contenttype == 47){
      return String;
    }else{
      throw FormatException("failed to map django contenttype to dart type");
    }
  }

}