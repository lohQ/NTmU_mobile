import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetRemotePreference extends Usecase<Preference, UserSession>{

  final ProfileRepository profileRepository;
  GetRemotePreference({@required this.profileRepository});

  @override
  Future<Either<Failure, Preference>> call(UserSession params) async {
    return await profileRepository.getRemotePreference(params);
  }

}