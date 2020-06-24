import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';

class EndSession extends Usecase<void,NoParams> {

  final UserSessionRepository userSessionRepo;
  EndSession({this.userSessionRepo});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final failure = await userSessionRepo.endSession();
    if(failure != null){
      return Left(failure);
    }else{
      return Right(null);
    }
  }
  
}
