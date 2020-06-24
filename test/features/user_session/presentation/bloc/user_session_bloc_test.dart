import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/end_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/get_saved_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/save_session.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockEndSession extends Mock implements EndSession {}
class MockGetSavedSession extends Mock implements GetSavedSession {}
class MockSaveSession extends Mock implements SaveSession {}
class MockConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  MockEndSession mockEndSession;
  MockGetSavedSession mockGetSavedSession;
  MockSaveSession mockSaveSession;
  UserSessionBloc bloc;

  setUp((){
    mockEndSession = MockEndSession();
    mockGetSavedSession = MockGetSavedSession();
    mockSaveSession = MockSaveSession();
    bloc = UserSessionBloc(
      endSession: mockEndSession,
      getSavedSession: mockGetSavedSession,
      saveSession: mockSaveSession,
    );
  });

  final tUserSession = UserSession(authToken: "authToken");

  group("getSavedSession", (){
    test("should_emit_[Loading,Loaded]_if_has_saved_session", () async {
      when(mockGetSavedSession(any))
        .thenAnswer((_) async => Right(tUserSession));
      final expected = [
        UserSessionInitial(), 
        UserSessionLoading(), 
        UserSessionLoaded(tUserSession)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoadSessionEvent());
    });
    test("should_emit_[Loading,Ended]_if_no_saved_session", () async {
      when(mockGetSavedSession(any))
        .thenAnswer((_) async => Left(StorageReadFailure(NO_SAVED_SESSION)));
      final expected = [
        UserSessionInitial(), 
        UserSessionLoading(), 
        UserSessionEnded()];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoadSessionEvent());
    });
  });

  group("saveSession", (){
    test("should_emit_nothing_if_save_success", () async {
      when(mockSaveSession(any))
        .thenAnswer((_) async => Right(null));
      final expected = [UserSessionInitial()];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(SaveSessionEvent(tUserSession));
    });
    test("should_emit_error_if_save_failed", () async {
      when(mockSaveSession(any))
        .thenAnswer((_) async => Left(UncategorizedFailure("some failure")));
      final expected = [
        UserSessionInitial(), 
        UserSessionErrorOccurred("some failure")];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(SaveSessionEvent(tUserSession));
    });
  });

  group("endSession", (){
    test("should_emit_[Loading,Ended]_if_success", () async {
      when(mockEndSession(any))
        .thenAnswer((_) async => Right(null));
      final expected = [
        UserSessionInitial(),
        UserSessionEnded()];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(EndSessionEvent());
    });
    test("should_emit_[Loading,Error]_if_failed", () async {
      when(mockEndSession(any))
        .thenAnswer((_) async => Left(UncategorizedFailure("some failure")));
      final expected = [
        UserSessionInitial(),
        UserSessionErrorOccurred("some failure")];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(EndSessionEvent());
    });
  });

}
