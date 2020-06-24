import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/getLocalPreference.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/getRemotePreference.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/updatePreference.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'preference_event.dart';
part 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {

  final InternetConnectionChecker connectionChecker;
  final GetLocalPreference getLocalPreference;
  final GetRemotePreference getRemotePreference;
  final UpdatePreference updatePreference;

  PreferenceBloc({
    @required this.connectionChecker, 
    @required this.getLocalPreference, 
    @required this.getRemotePreference, 
    @required this.updatePreference});

  UserSession userSession;

  Stream<PreferenceState> loadLocalPreference() async* {
    print("loading cached preference...");
    final profileEither = await getLocalPreference(NoParams());
    yield* profileEither.fold(
      (failure) async* {
        print("failed to load cached preference");
        yield PreferenceError(failure.message, state.preference);
      }, 
      (pref) async* {
        print("cached preference loaded");
        yield PreferenceUpdated(pref);
      }
    );
  } 

  Stream<PreferenceState> fetchRemotePreference() async* {
    print("fetching remote preference...");
    final profileEither = await getRemotePreference(userSession);
    yield* profileEither.fold(
      (failure) async* {
        print("failed to fetch preference");
        yield PreferenceError(failure.message, state.preference);
      }, 
      (pref) async* {
        print("preference fetched, id = ${pref.id}");
        yield PreferenceUpdated(pref);
      }
    );
  } 


  String _validateInput(Map<String,dynamic> pref){
    if(pref.containsKey("age_preference_min")){
      if(pref["age_preference_min"] >= pref["age_preference_max"]){
        return "minimum preferred age should be smaller than the maximum preferred value";
      }
    }
    if(pref.containsKey("year_of_matriculation_min")){
      if(pref["year_of_matriculation_min"] >= pref["year_of_matriculation_max"]){
        return "minimum preferred year of matriculation should be smaller than the maximum preferred value";
      }
    }
    return null;
  }

  @override
  PreferenceState get initialState => PreferenceInitial();

  @override
  Stream<PreferenceState> mapEventToState(
    PreferenceEvent event,
  ) async* {

    if (event is InitializePreferenceEvent){
      print("initialized preference bloc");
      userSession = event.userSession;
      yield PreferenceLoading(state.preference);
      yield* loadLocalPreference();
      add(ReloadPreferenceEvent());

    } else if (event is UpdatePreferenceEvent) {
      yield PreferenceLoading(state.preference);
      if(await connectionChecker.isConnected()){
        String validationError = _validateInput(event.data);
        if(validationError != null){
          yield PreferenceError(validationError, state.preference);
          return;
        }
        final params = UpdatePreferenceParams(userSession, state.preference.id, event.data);
        final updatedPrefEither = await updatePreference(params);
        yield* updatedPrefEither.fold(
          (failure) async* {
            yield PreferenceError(failure.message, state.preference);
          }, 
          (preference) async* {
            yield PreferenceUpdated(preference);
          }
        );
      }else{
        yield PreferenceError("no connection", state.preference);
      }
    
    } else if (event is ReloadPreferenceEvent) {
      yield PreferenceLoading(state.preference);
      if(await connectionChecker.isConnected()){
        yield* fetchRemotePreference(); 
      }else{
        yield PreferenceError("No connection", state.preference);
      }

    }

  }
}
