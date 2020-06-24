import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/changePassword.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:meta/meta.dart';

part 'changepassword_event.dart';
part 'changepassword_state.dart';

class ChangepasswordBloc extends Bloc<ChangepasswordEvent, ChangepasswordState> {

  final ChangePassword changePassword;
  final InternetConnectionChecker connectionChecker;
  ChangepasswordBloc({@required this.changePassword, @required this.connectionChecker});

  @override
  ChangepasswordState get initialState => ChangepasswordInitial();

  @override
  Stream<ChangepasswordState> mapEventToState(
    ChangepasswordEvent event,
  ) async* {
    if(event is SubmitNewPassword){
      if(await connectionChecker.isConnected()){
        final params = ChangePasswordParams(event.userSession, event.oldPassword, event.newPassword);
        final either = await changePassword(params);
        yield* either.fold(
          (failure) async* {
            yield ChangepasswordError(failure.message);
          },
          (_) async* {
            yield ChangepasswordSubmitted();
          }
        );
      }else{
        yield ChangepasswordError("No connection");
      }
    }
  }
}
