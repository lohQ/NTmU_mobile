part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class SubmitRegisterForm extends RegisterEvent{
  final Map<String,dynamic> data;
  SubmitRegisterForm(this.data);
}

