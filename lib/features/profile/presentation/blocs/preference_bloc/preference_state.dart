part of 'preference_bloc.dart';

abstract class PreferenceState extends Equatable {
  final Preference preference;
  const PreferenceState(this.preference);
}

class PreferenceInitial extends PreferenceState {
  PreferenceInitial() : super(null);
  @override
  List<Object> get props => [];
}

class PreferenceLoading extends PreferenceState {
  PreferenceLoading(Preference preference) : super(preference);
  @override
  List<Object> get props => [preference];
}

class PreferenceUpdated extends PreferenceState {
  PreferenceUpdated(Preference preference) : super(preference);
  @override
  List<Object> get props => [preference];
}

class PreferenceError extends PreferenceState {
  final String error;
  PreferenceError(this.error, Preference preference) : super(preference);
  @override
  List<Object> get props => [error];
}
