import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/end_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/get_saved_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/save_session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'user_session_event.dart';
part 'user_session_state.dart';

class UserSessionBloc extends Bloc<UserSessionEvent, UserSessionState> {

  final EndSession endSession;
  final GetSavedSession getSavedSession;
  final SaveSession saveSession; 
  UserSessionBloc({
    @required this.endSession, 
    @required this.getSavedSession,
    @required this.saveSession,
  });

  @override
  UserSessionState get initialState => UserSessionInitial();

  @override
  Stream<UserSessionState> mapEventToState(
    UserSessionEvent event,
  ) async* {
    if (event is LoadSessionEvent){
      if(event.session != null){
        print("user session loaded");
        yield UserSessionLoaded(event.session);
      }else{
        print("loading user session...");
        yield UserSessionLoading();
        final userSessionEither = await getSavedSession(NoParams());
        yield* userSessionEither.fold(
          (failure) async* {
            if(failure.message == NO_SAVED_SESSION){
              print("no saved user session");
              yield UserSessionEnded();
            }else{
              print("failed to load user session");
              yield UserSessionErrorOccurred(failure.message);
            }
          },
          (userSession) async* {
            print("user session loaded");
            yield UserSessionLoaded(userSession);
          }
        );
      }
      
    } else if (event is SaveSessionEvent) {
      final nullEither = await saveSession(SaveSessionParams(event.session));
      yield* nullEither.fold(
        (failure) async* {
          print("failed to save user session");
          yield UserSessionErrorOccurred(failure.message);
        },
        (success) async* {
          print("user session saved");
        }
      );

    } else if (event is EndSessionEvent) {
      print("ending user session...");
      yield UserSessionLoading();
      final nullEither = await endSession(NoParams());
      yield* nullEither.fold(
        (failure) async* {
          print("failed to end user session");
          yield UserSessionErrorOccurred(failure.message);
        },
        (success) async* {
          print("user session ended");
          yield UserSessionEnded();
        }
      );
    }
  }

}
