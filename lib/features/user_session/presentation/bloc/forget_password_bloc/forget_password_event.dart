part of 'forget_password_bloc.dart';

@immutable
abstract class ForgetPasswordEvent {}

class SubmitForgetPasswordForm extends ForgetPasswordEvent {
  final String email;
  SubmitForgetPasswordForm(this.email);
}
