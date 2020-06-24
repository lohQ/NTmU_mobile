import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class Register extends Usecase<void, Map<String,dynamic>>{

  final UserSessionRepository userSessionRepo;
  Register({@required this.userSessionRepo});

  @override
  Future<Either<Failure, void>> call(Map<String, dynamic> params) async {
    final failure = await userSessionRepo.register(params);
    if(failure != null){
      return Left(failure);
    }else{
      return Right(null);
    }
  }

}

const List<String> REGISTER_PARAMS = [
  'email', 'password1', 'password2', 'username',
  'full_name', 'gender', 'description', 'date_of_birth', 
  'country_of_origin', 'religion', 
  'course_of_study', 'year_of_matriculation', 
  'avatar', 'hobbies'
];

// date_of_birth_day? 
