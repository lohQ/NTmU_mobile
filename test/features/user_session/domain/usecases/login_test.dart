import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/user_session/data/repositories/user_session_repository_impl.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/login.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserSessionRepositoryImpl extends Mock implements UserSessionRepositoryImpl {}

void main() {

  MockUserSessionRepositoryImpl mockUserSessionRepo;
  Login usecase;

  setUp((){
    mockUserSessionRepo = MockUserSessionRepositoryImpl();
    usecase = Login(userSessionRepo: mockUserSessionRepo);
  });

  final tUserSession = UserSession(authToken: "u001_token");
  final params = LoginParams(username: "username", password: "password", saveSession: true);
  void setupStartNewSessionFunc(){
    when(mockUserSessionRepo.startNewSession(anyNamed("username"), anyNamed("password")))
      .thenAnswer((_) async => Right(tUserSession));
  }
  void setupSaveSessionFunc(){
    when(mockUserSessionRepo.saveSession(anyNamed("session")))
      .thenAnswer((_) async => null);
  }

  test("should_return_UserSession_when_success", () async {
    setupStartNewSessionFunc();
    final result = await usecase.call(params);
    expect(result, Right(tUserSession));
  });
  test("should_return_Failure_when_startNewSession_fails", () async {
    when(mockUserSessionRepo.startNewSession(anyNamed("username"), anyNamed("password")))
      .thenAnswer((_) async => Left(BadRequestFailure("failure")));
    final result = await usecase.call(params);
    expect(result, Left(BadRequestFailure("failure")));
  });

  test("should_save_session_if_saveSession_is_true", () async {
    setupStartNewSessionFunc();
    setupSaveSessionFunc();
    await usecase.call(params);
    verify(mockUserSessionRepo.saveSession(tUserSession));
  });

}