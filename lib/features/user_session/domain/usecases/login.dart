import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class Login extends Usecase<UserSession, LoginParams> {
  final UserSessionRepository userSessionRepo;
  Login({this.userSessionRepo});

  @override
  Future<Either<Failure, UserSession>> call(LoginParams params) async {
    return await userSessionRepo.startNewSession(params.username, params.password);
  }

}

class LoginParams {
  final String username;
  final String password;
  final bool saveSession;
  LoginParams({
    @required this.username, 
    @required this.password, 
    @required this.saveSession});  
}