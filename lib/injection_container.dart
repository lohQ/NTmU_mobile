import 'package:clean_ntmu/features/matchings/data/data_sources/local_data_source.dart';
import 'package:clean_ntmu/features/matchings/data/data_sources/remote_data_source.dart';
import 'package:clean_ntmu/features/matchings/data/repositories/matchings_repository_impl.dart';
import 'package:clean_ntmu/features/matchings/domain/usecases/loadMatchings.dart';
import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:clean_ntmu/features/profile/data/data_sources/local_data_source.dart';
import 'package:clean_ntmu/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/changePassword.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/getLocalPreference.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/updatePreference.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/updateProfile.dart';
import 'package:clean_ntmu/features/static_data/data/data_sources/static_data_local_data_source.dart';
import 'package:clean_ntmu/features/static_data/data/repositories/server_data_repostiory_impl.dart';
import 'package:clean_ntmu/features/user_session/data/data_sources/user_session_local_data_source.dart';
import 'package:clean_ntmu/features/user_session/data/data_sources/user_session_remote_data_source.dart';
import 'package:clean_ntmu/features/user_session/data/repositories/user_session_repository_impl.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/end_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/save_session.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/internetConnectionChecker.dart';
import 'features/matchings/domain/repositories/matchings_repository.dart';
import 'features/matchings/domain/usecases/indicateMatchAcceptance.dart';
import 'features/matchings/domain/usecases/loadAllMatchings.dart';
import 'features/profile/data/data_sources/remote_data_source.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/getLocalProfile.dart';
import 'features/profile/domain/usecases/getRemotePreference.dart';
import 'features/profile/domain/usecases/getRemoteProfile.dart';
import 'features/profile/domain/usecases/submit_feedback.dart';
import 'features/profile/domain/usecases/view_feedback.dart';
import 'features/profile/presentation/blocs/change_password_bloc/changepassword_bloc.dart';
import 'features/profile/presentation/blocs/feedback_bloc/feedback_bloc.dart';
import 'features/profile/presentation/blocs/preference_bloc/preference_bloc.dart';
import 'features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'features/static_data/domain/repositories/static_data_repository.dart';
import 'features/user_session/domain/repositories/user_session_repository.dart';
import 'features/user_session/domain/usecases/forget_password.dart';
import 'features/user_session/domain/usecases/get_saved_session.dart';
import 'features/user_session/domain/usecases/login.dart';
import 'features/user_session/domain/usecases/register.dart';
import 'features/user_session/presentation/bloc/login_bloc/login_bloc.dart';
import 'features/user_session/presentation/bloc/register_bloc/register_bloc.dart';
import 'features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';

// service locator
final sl = GetIt.instance;

Future<void> init() async {

  // user session
  sl.registerFactory(
    ()=>UserSessionBloc(
      getSavedSession: sl(),
      saveSession: sl(),
      endSession: sl(),
    )
  );
  sl.registerFactory(
    ()=>LoginBloc(
      connectionChecker: sl(),
      login: sl(),
    )
  );
  sl.registerLazySingleton(()=>Login(userSessionRepo: sl()));
  sl.registerLazySingleton(()=>GetSavedSession(userSessionRepo: sl()));
  sl.registerLazySingleton(()=>SaveSession(userSessionRepo: sl()));
  sl.registerLazySingleton(()=>EndSession(userSessionRepo: sl()));
  sl.registerLazySingleton<UserSessionRepository>(
    ()=>UserSessionRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl())
  );
  sl.registerLazySingleton<UserSessionLocalDataSource>(()=>UserSessionLocalDataSourceImpl(secureStorage: sl()));
  sl.registerLazySingleton<UserSessionRemoteDataSource>(()=>UserSessionRemoteDataSourceImpl(dioClient: sl()));
  sl.registerFactory(()=>ForgetPasswordBloc(
    connectionChecker: sl(),
    forgetPassword: sl(),
  ));
  sl.registerLazySingleton(()=>ForgetPassword(userSessionRepo: sl()));

  // profile
  sl.registerFactory(
    ()=>ProfileBloc(
      connectionChecker: sl(),
      getLocalProfile: sl(),
      getRemoteProfile: sl(),
      updateProfile: sl()
    )
  );
  sl.registerFactory(
    ()=>PreferenceBloc(
      connectionChecker: sl(),
      getLocalPreference: sl(),
      getRemotePreference: sl(),
      updatePreference: sl()
    )
  );
  sl.registerLazySingleton(()=>GetLocalProfile(profileRepository: sl()));
  sl.registerLazySingleton(()=>GetRemoteProfile(profileRepository: sl()));
  sl.registerLazySingleton(()=>UpdateProfile(profileRepository: sl()));
  sl.registerLazySingleton(()=>GetLocalPreference(profileRepository: sl()));
  sl.registerLazySingleton(()=>GetRemotePreference(profileRepository: sl()));
  sl.registerLazySingleton(()=>UpdatePreference(profileRepository: sl()));
  sl.registerLazySingleton<ProfileRepository>(
    ()=>ProfileRepositoryImpl(
      remoteDataSource: sl(), 
      localDataSource: sl())
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    ()=>ProfileRemoteDataSourceImpl(dioClient: sl())
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    ()=>ProfileLocalDataSourceImpl(sharedPreferences: sl())
  );

  // matchings
  sl.registerFactory(
    ()=>MatchingsBloc(
      connectionChecker: sl(),
      loadMatchings: sl(),
      loadAllMatchings: sl(),
      indicateMatchAcceptance: sl(),
    )
  );
  sl.registerLazySingleton(()=>LoadMatchings(matchingsRepo: sl()));
  sl.registerLazySingleton(()=>LoadAllMatchings(matchingsRepo: sl()));
  sl.registerLazySingleton(()=>IndicateMatchAcceptance(matchingRepo: sl()));
  sl.registerLazySingleton<MatchingsRepository>(
    () => MatchingsRepositoryImpl(remoteDataSource: sl(), localDataSource: sl())
  );
  sl.registerLazySingleton<MatchingsRemoteDataSource>(
    ()=>MatchingsRemoteDataSourceImpl(dioClient: sl())
  );
  sl.registerLazySingleton<MatchingsLocalDataSource>(
    ()=>MatchingsLocalDataSourceImpl()
  );

  // feedback
  sl.registerFactory(()=>FeedbackBloc(
    connectionChecker: sl(),
    submitFeedback: sl(),
    viewFeedback: sl(),
  ));
  sl.registerLazySingleton(()=>SubmitFeedback(profileRepo: sl()));
  sl.registerLazySingleton(()=>ViewFeedback(profileRepo: sl()));

  // change password
  sl.registerFactory(()=>ChangepasswordBloc(
    connectionChecker: sl(),
    changePassword: sl()
  ));
  sl.registerLazySingleton(()=>ChangePassword(profileRepo: sl()));  

  // register
  sl.registerFactory(()=>RegisterBloc(
    register: sl(),
    connectionChecker: sl()
  ));
  sl.registerLazySingleton(()=>Register(userSessionRepo: sl()));

  // static data
  sl.registerLazySingleton<StaticDataRepository>(()=>StaticDataRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton(()=>StaticDataLocalDataSource());

  // core
  sl.registerLazySingleton<InternetConnectionChecker>(()=>InternetConnectionCheckerImpl(connectivity: sl()));
  // external
  sl.registerLazySingleton(()=>Dio(BaseOptions(connectTimeout: 5000)));
  sl.registerLazySingleton(()=>Connectivity());
  sl.registerLazySingleton(()=>FlutterSecureStorage());
  sl.registerSingletonAsync(()=>SharedPreferences.getInstance());

}