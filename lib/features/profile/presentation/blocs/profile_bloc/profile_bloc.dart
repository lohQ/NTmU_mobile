import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/getLocalProfile.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/getRemoteProfile.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/updateProfile.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final GetRemoteProfile getRemoteProfile;
  final GetLocalProfile getLocalProfile;
  final UpdateProfile updateProfile;
  final InternetConnectionChecker connectionChecker;

  ProfileBloc({
    @required this.getRemoteProfile, 
    @required this.getLocalProfile, 
    @required this.updateProfile, 
    @required this.connectionChecker});

  UserSession userSession;

  Stream<ProfileState> loadLocalProfile() async* {
    print("loading cached profile...");
    final profileEither = await getLocalProfile(NoParams());
    yield* profileEither.fold(
      (failure) async* {
        print("failed to load cached profile");
        yield ProfileError(failure.message, state.profile);
      }, 
      (profile) async* {
        print("cached profile loaded");
        yield ProfileUpdated(profile);
      }
    );
  } 

  Stream<ProfileState> fetchRemoteProfile() async* {
    print("fetching remote profile...");
    final profileEither = await getRemoteProfile(userSession);
    yield* profileEither.fold(
      (failure) async* {
        print("failed to fetch profile");
        yield ProfileError(failure.message, state.profile);
      }, 
      (profile) async* {
        print("profile fetched from server, id = ${profile.id}");
        yield ProfileUpdated(profile);
      }
    );
  } 

  @override
  ProfileState get initialState => ProfileInitial();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {

    if (event is InitializeProfileEvent){
      print("initialized profile bloc");
      userSession = event.userSession;
      yield ProfileLoading(state.profile);
      // yield* loadLocalProfile();
      add(ReloadProfileEvent());

    } else if (event is UpdateProfileEvent) {
      yield ProfileLoading(state.profile);
      if(await connectionChecker.isConnected()){
        final params = UpdateProfileParams(userSession, state.profile.id, event.data);
        final updatedProfileEither = await updateProfile(params);
        yield* updatedProfileEither.fold(
          (failure) async* {
            yield ProfileError(failure.message, state.profile);
          }, 
          (profile) async* {
            yield ProfileUpdated(profile);
          }
        );
      }else{
        yield ProfileError("no connection", state.profile);
      }

    } else if (event is ReloadProfileEvent){
      yield ProfileLoading(state.profile);
      if(await connectionChecker.isConnected()){
        yield* fetchRemoteProfile(); 
      }else{
        yield ProfileError("no connection", state.profile);
      }
      
    }

  }
}
