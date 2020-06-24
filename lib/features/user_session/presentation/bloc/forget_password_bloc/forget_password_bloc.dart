import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/forget_password.dart';
import 'package:meta/meta.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {

  final ForgetPassword forgetPassword;
  final InternetConnectionChecker connectionChecker;
  ForgetPasswordBloc({@required this.forgetPassword, @required this.connectionChecker});

  @override
  ForgetPasswordState get initialState => ForgetPasswordInitial();

  @override
  Stream<ForgetPasswordState> mapEventToState(
    ForgetPasswordEvent event,
  ) async* {
    if(event is SubmitForgetPasswordForm){
      if(await connectionChecker.isConnected()){
        final either = await forgetPassword(event.email);
        yield* either.fold(
          (failure) async* {
            yield ForgetPasswordError(failure.message);
          },
          (_) async* {
            yield ForgetPasswordSubmitted();
          }
        );
      }else{
        yield ForgetPasswordNetworkError("No connection");
      }
    }
  }
}
