import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetLocalProfile extends Usecase<Profile, NoParams>{

  final ProfileRepository profileRepository;
  GetLocalProfile({@required this.profileRepository});

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return profileRepository.getLocalProfile();
  }

}