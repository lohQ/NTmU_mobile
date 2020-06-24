part of 'user_session_bloc.dart';

abstract class UserSessionState extends Equatable {
  const UserSessionState();
}

class UserSessionInitial extends UserSessionState {
  @override
  List<Object> get props => [];
}

class UserSessionLoading extends UserSessionState {
  @override
  List<Object> get props => [];
}

class UserSessionErrorOccurred extends UserSessionState {
  final String errorString;
  UserSessionErrorOccurred(this.errorString);
  @override
  List<Object> get props => [errorString];
}

class UserSessionLoaded extends UserSessionState {
  final UserSession userSession;
  UserSessionLoaded(this.userSession);
  @override
  List<Object> get props => [userSession];
}

class UserSessionEnded extends UserSessionState {
  @override
  List<Object> get props => [];
}
