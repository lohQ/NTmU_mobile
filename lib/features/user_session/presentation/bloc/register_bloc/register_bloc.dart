import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/register.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final Register register;
  final InternetConnectionChecker connectionChecker;

  RegisterBloc({@required this.register, @required this.connectionChecker});

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if(event is SubmitRegisterForm){
      if(await connectionChecker.isConnected()){
        yield RegisterLoading();
        print("yielded loading state");
        final dataCopy = Map<String,dynamic>.from(event.data);
        final either = await register(dataCopy);
        yield* either.fold(
          (failure) async* {
            if(failure is NetworkFailure){
              yield RegisterNetworkError(failure.message);
            }else{
              yield RegisterError(failure.message);
            }
            print("yielded error state");
          },
          (_) async* {
            yield RegisterSuccess();
            print("yielded success state");
          }
        );
      }else{
        yield RegisterNetworkError("No connection");
        print("yielded error state (no connection)");
      }
    }
  }
}
