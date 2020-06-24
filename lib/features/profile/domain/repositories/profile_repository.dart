import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {

  Either<Failure, Profile> getLocalProfile();
  Future<Either<Failure, Profile>> getRemoteProfile(UserSession userSession);
  Future<Either<Failure, Profile>> updateProfile(UserSession userSession, int id, Map<String,dynamic> data);

  Either<Failure, Preference> getLocalPreference();
  Future<Either<Failure, Preference>> getRemotePreference(UserSession userSession);
  Future<Either<Failure, Preference>> updatePreference(UserSession userSession, int id, Map<String,dynamic> data);

  Future<Either<Failure, void>> changePassword(UserSession userSession, Map<String,String> data);

  Future<Either<Failure, void>> submitFeedback(UserSession userSession, List<Answer> answers);
  Future<Either<Failure, List<Answer>>> viewFeedback(UserSession userSession);

}