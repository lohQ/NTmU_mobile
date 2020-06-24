part of 'user_session_bloc.dart';

abstract class UserSessionEvent extends Equatable {
  const UserSessionEvent();
}

class LoadSessionEvent extends UserSessionEvent {
  final UserSession session;
  LoadSessionEvent([this.session]);
  @override
  List<Object> get props => [];
}
class EndSessionEvent extends UserSessionEvent {
  @override
  List<Object> get props => [];
}
class SaveSessionEvent extends UserSessionEvent {
  final UserSession session;
  SaveSessionEvent(this.session);
  @override
  List<Object> get props => [session];
}
