part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitializeProfileEvent extends ProfileEvent {
  final UserSession userSession;
  InitializeProfileEvent(this.userSession);
  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final Map<String,dynamic> data;
  UpdateProfileEvent(this.data);
  @override
  List<Object> get props => [data];
}

class ReloadProfileEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}