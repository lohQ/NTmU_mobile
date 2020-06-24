import 'package:clean_ntmu/features/user_session/data/models/user_session_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserSessionLocalDataSource {
  Future<UserSessionModel> getSavedSession();
  Future<void> saveSession(UserSessionModel session);
  Future<void> deleteSavedSession();
}

const String TOKEN_KEY = "TOKEN";

class UserSessionLocalDataSourceImpl extends UserSessionLocalDataSource {

  final FlutterSecureStorage secureStorage;

  UserSessionLocalDataSourceImpl({this.secureStorage});

  @override
  Future<void> deleteSavedSession() async {
    await Future.wait([
      secureStorage.delete(key: TOKEN_KEY)
    ]);
  }

  @override
  Future<UserSessionModel> getSavedSession() async {
    final token = await secureStorage.read(key: TOKEN_KEY);
    if(token != null){
      return UserSessionModel(token: token);
    }
    return null;
  }

  @override
  Future<void> saveSession(UserSessionModel session) async {
    await secureStorage.write(key: TOKEN_KEY, value: session.authToken);
  }

}