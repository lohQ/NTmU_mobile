part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  final Profile profile;
  const ProfileState(this.profile);
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(null);
  @override
  List<Object> get props => [profile];
}

class ProfileLoading extends ProfileState {
  ProfileLoading(Profile profile) : super(profile);
  @override
  List<Object> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  ProfileUpdated(Profile profile) : super(profile);
  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String error;
  ProfileError(this.error, Profile profile) : super(profile);
  @override
  List<Object> get props => [error];
}
