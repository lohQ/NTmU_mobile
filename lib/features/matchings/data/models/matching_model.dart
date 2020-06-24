import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:meta/meta.dart';

class MatchingModel extends Matching {

  final bool selfIsUser1;
  MatchingModel({
    @required this.selfIsUser1,
    @required int id, 
    @required ProfileModel oppProfile,
    @required int selfChoice,
    @required int oppChoice, 
    @required String description
  }) : super(
    id: id,
    oppProfile: oppProfile,
    selfChoice: selfChoice, 
    oppChoice: oppChoice,
    matchDescription: description
  );

  factory MatchingModel.fromJson(Map<String,dynamic> json){
    Map<String,dynamic> profileJson;
    int self; int opp;
    if(json.containsKey("user_1")){
      self = 2; opp = 1;
    }else{
      self = 1; opp = 2;
    }
    profileJson = json["user_$opp"];
    final profileModel = ProfileModel.fromJson(profileJson);
    return MatchingModel(
      id: json["id"],
      selfIsUser1: self==1 ? true : false,
      oppProfile:  profileModel,
      selfChoice: json["user_${self}_choice"],
      oppChoice: json["user_${opp}_choice"],
      description: json["description"]
    );
  }

  Map<String,dynamic> toJson(){
    int self; int opp;
    if(selfIsUser1){
      self = 1; opp = 2;
    }else{
      self = 2; opp = 1;
    }
    final profileJson = (oppProfile as ProfileModel).toJson();
    return {
      "id": id,
      "user_$opp": profileJson,
      "user_${self}_choice": selfChoice,
      "user_${opp}_choice": oppChoice,
      "description": matchDescription
    };
  }

}