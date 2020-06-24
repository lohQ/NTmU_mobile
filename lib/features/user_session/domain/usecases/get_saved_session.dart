import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';

class GetSavedSession extends Usecase<UserSession,NoParams> {

  final UserSessionRepository userSessionRepo;
  GetSavedSession({this.userSessionRepo});

  @override
  Future<Either<Failure, UserSession>> call(NoParams params) async {
    return await userSessionRepo.getSavedSession();
  }
  
}