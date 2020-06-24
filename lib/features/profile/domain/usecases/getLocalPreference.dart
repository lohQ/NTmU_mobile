import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetLocalPreference extends Usecase<Preference, NoParams>{

  final ProfileRepository profileRepository;
  GetLocalPreference({@required this.profileRepository});

  @override
  Future<Either<Failure, Preference>> call(NoParams params) async {
    return profileRepository.getLocalPreference();
  }

}