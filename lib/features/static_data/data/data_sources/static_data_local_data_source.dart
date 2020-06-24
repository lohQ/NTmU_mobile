
import 'dart:convert';

import 'package:clean_ntmu/features/static_data/data/models/name_with_id_model.dart';
import 'package:clean_ntmu/features/static_data/data/models/question_model.dart';
import 'package:flutter/services.dart' show rootBundle;

class StaticDataLocalDataSource{
  
  Future<List<NameWithIdModel>> getNameWithIds(String filename) async {
    final jsonMap = await _getJsonListFromFile(filename);
    return jsonMap == null
     ? null
     : List.from(jsonMap).map((json)=>NameWithIdModel.fromJson(json)).toList();
  }

  Future<List<QuestionModel>> getQuestions(String filename) async {
    final jsonMap = await _getJsonListFromFile(filename);
    return jsonMap == null
     ? null 
     : List.from(jsonMap).map((json)=>QuestionModel.fromJson(json)).toList();
  }
  
  Future<Iterable> _getJsonListFromFile(String filename) async {
    final jsonString = await rootBundle.loadString("assets/static_data/$filename");
    if(jsonString == null || jsonString.isEmpty){
      return null;
    }
    final Iterable jsonMap = json.decode(jsonString);
    return jsonMap;
  }

}