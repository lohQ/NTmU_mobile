import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class UpdateProfile extends Usecase<Profile, UpdateProfileParams>{

  final ProfileRepository profileRepository;
  UpdateProfile({@required this.profileRepository});

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    return await profileRepository.updateProfile(params.session, params.id, params.data);
  }

}

class UpdateProfileParams {
  final UserSession session;
  final int id;
  final Map<String, dynamic> data;
  UpdateProfileParams(this.session, this.id, this.data);
}