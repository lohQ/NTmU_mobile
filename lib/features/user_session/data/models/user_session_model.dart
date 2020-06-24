import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';

class UserSessionModel extends UserSession{

  UserSessionModel({String token}) : super(authToken: token);

  factory UserSessionModel.fromJson(Map<String,dynamic> jsonMap){
    return UserSessionModel(
      token: jsonMap["token"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "token": authToken
    };
  }
}