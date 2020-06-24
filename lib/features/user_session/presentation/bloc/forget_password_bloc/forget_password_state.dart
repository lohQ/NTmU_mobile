part of 'forget_password_bloc.dart';

@immutable
abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}
class ForgetPasswordSubmitted extends ForgetPasswordState {}

class ForgetPasswordError extends ForgetPasswordState {
  final String error;
  ForgetPasswordError(this.error);
}
class ForgetPasswordNetworkError extends ForgetPasswordState {
  final String error;
  ForgetPasswordNetworkError(this.error);
}