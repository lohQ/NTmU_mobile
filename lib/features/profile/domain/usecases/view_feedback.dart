import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ViewFeedback extends Usecase<List<Answer>,UserSession>{

  final ProfileRepository profileRepo;
  ViewFeedback({@required this.profileRepo});

  @override
  Future<Either<Failure, List<Answer>>> call(UserSession params) {
    return profileRepo.viewFeedback(params);
  }

}