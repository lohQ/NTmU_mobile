part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginInProgress extends LoginState {
  @override
  List<Object> get props => [];
}
class LoginSuccess extends LoginState {
  final UserSession session;
  final bool saveSession;
  LoginSuccess(this.session, this.saveSession);
  @override
  List<Object> get props => [session, saveSession];
}
class LoginFailed extends LoginState {
  final String failureString;
  LoginFailed(this.failureString);
  @override
  List<Object> get props => [failureString];
}
class LoginError extends LoginState {
  final String errorString;
  LoginError(this.errorString);
  @override
  List<Object> get props => [errorString];
}