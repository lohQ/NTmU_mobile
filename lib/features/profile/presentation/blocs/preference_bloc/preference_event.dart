part of 'preference_bloc.dart';

abstract class PreferenceEvent extends Equatable {
  const PreferenceEvent();
}

class InitializePreferenceEvent extends PreferenceEvent {
  final UserSession userSession;
  InitializePreferenceEvent(this.userSession);
  @override
  List<Object> get props => [];
}

class UpdatePreferenceEvent extends PreferenceEvent {
  final Map<String,dynamic> data;
  UpdatePreferenceEvent(this.data);
  @override
  List<Object> get props => [data];
}

class ReloadPreferenceEvent extends PreferenceEvent {
  @override
  List<Object> get props => [];
}