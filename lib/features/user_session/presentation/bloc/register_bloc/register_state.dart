part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String error;
  RegisterError(this.error);
}

class RegisterNetworkError extends RegisterState {
  final String error;
  RegisterNetworkError(this.error);
}