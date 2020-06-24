import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';

class SaveSession extends Usecase<void, SaveSessionParams> {
  final UserSessionRepository userSessionRepo;
  SaveSession({this.userSessionRepo});

  @override
  Future<Either<Failure, void>> call(SaveSessionParams params) async {
    final failure = await userSessionRepo.saveSession(params.session);
    if(failure != null){
      return Left(failure);
    }else{
      return Right(null);
    }
  }
}

class SaveSessionParams {
  final UserSession session;
  SaveSessionParams(this.session);
}
