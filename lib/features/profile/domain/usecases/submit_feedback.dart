import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class SubmitFeedback extends Usecase<void, SubmitFeedbackParams>{

  final ProfileRepository profileRepo;
  SubmitFeedback({@required this.profileRepo});

  @override
  Future<Either<Failure, void>> call(SubmitFeedbackParams params) async {
    return await profileRepo.submitFeedback(params.userSession, params.answers);
  }
  
}

class SubmitFeedbackParams{
  final UserSession userSession;
  final List<Answer> answers;

  SubmitFeedbackParams(this.userSession, this.answers);
}