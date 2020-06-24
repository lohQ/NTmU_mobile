import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetRemoteProfile extends Usecase<Profile, UserSession>{

  final ProfileRepository profileRepository;
  GetRemoteProfile({@required this.profileRepository});

  @override
  Future<Either<Failure, Profile>> call(UserSession params) async {
    return await profileRepository.getRemoteProfile(params);
  }

}