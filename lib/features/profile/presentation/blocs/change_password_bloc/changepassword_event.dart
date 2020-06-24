part of 'changepassword_bloc.dart';

@immutable
abstract class ChangepasswordEvent {}

class SubmitNewPassword extends ChangepasswordEvent {
  final UserSession userSession;
  final String oldPassword;
  final String newPassword;

  SubmitNewPassword(this.userSession, this.oldPassword, this.newPassword);

}
