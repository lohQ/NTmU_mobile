part of 'changepassword_bloc.dart';

@immutable
abstract class ChangepasswordState {}

class ChangepasswordInitial extends ChangepasswordState {}

class ChangepasswordSubmitted extends ChangepasswordState {}

class ChangepasswordLoading extends ChangepasswordState {}

class ChangepasswordError extends ChangepasswordState {
  final String error;
  ChangepasswordError(this.error);
}