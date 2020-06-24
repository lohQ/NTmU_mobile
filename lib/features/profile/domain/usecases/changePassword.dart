import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ChangePassword extends Usecase<void, ChangePasswordParams> {

  final ProfileRepository profileRepo;

  ChangePassword({@required this.profileRepo});

  @override
  Future<Either<Failure, void>> call(params) {
    return profileRepo.changePassword(params.userSession, params.dataToJson());
  }

}

class ChangePasswordParams {
  final UserSession userSession;
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams(this.userSession, this.oldPassword, this.newPassword);

  Map<String,String> dataToJson(){
    return {
      'old_password': oldPassword,
      'new_password1': newPassword,
      'new_password2': newPassword
    };
  }
}