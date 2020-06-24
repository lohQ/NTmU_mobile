import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class UpdatePreference extends Usecase<Preference, UpdatePreferenceParams>{

  final ProfileRepository profileRepository;
  UpdatePreference({@required this.profileRepository});

  @override
  Future<Either<Failure, Preference>> call(UpdatePreferenceParams params) async {
    return await profileRepository.updatePreference(params.session, params.id, params.data);
  }

}

class UpdatePreferenceParams {
  final UserSession session;
  final int id;
  final Map<String, dynamic> data;
  UpdatePreferenceParams(this.session, this.id, this.data);
}