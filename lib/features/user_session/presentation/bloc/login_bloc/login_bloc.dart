import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/login.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final Login login;
  final InternetConnectionChecker connectionChecker;
  LoginBloc({@required this.login, @required this.connectionChecker});

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is StartLoginEvent) {
      if(await connectionChecker.isConnected()){
        yield LoginInProgress();
        final loginParams = LoginParams(
          username: event.username, 
          password: event.password, 
          saveSession: event.saveSession);
        final userSessionEither = await login(loginParams);
        yield* userSessionEither.fold(
          (failure) async* {
            if(failure is BadRequestFailure){
              yield LoginFailed(failure.message);
            }else{
              yield LoginError(failure.message);
            }
          },
          (userSession) async* {
            yield LoginSuccess(userSession, event.saveSession);
          }
        );
      } else {
        yield LoginError(NO_CONNECTION);
      }
    }

  }
}
