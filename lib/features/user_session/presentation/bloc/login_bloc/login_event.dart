part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class StartLoginEvent extends LoginEvent {
  final String username;
  final String password;
  final bool saveSession;

  StartLoginEvent({
    @required this.username, 
    @required this.password, 
    @required this.saveSession});
  
  @override
  List<Object> get props => [username, password, saveSession];
}
