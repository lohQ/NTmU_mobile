import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ForgetPassword extends Usecase<void, String>{

  final UserSessionRepository userSessionRepo;

  ForgetPassword({@required this.userSessionRepo});

  @override
  Future<Either<Failure, void>> call(String params) async {
    final failure = await userSessionRepo.forgetPassword(params);
    if(failure != null){
      return Left(failure);
    }else{
      return Right(null);
    }
  }

}