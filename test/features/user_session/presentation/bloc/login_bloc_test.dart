
import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/login.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLogin extends Mock implements Login {}
class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}

void main(){

  MockLogin mockLogin;
  MockInternetConnectionChecker mockInternetConnectionChecker;
  LoginBloc bloc;

  setUp((){
    mockLogin = MockLogin();
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    bloc = LoginBloc(
      connectionChecker: mockInternetConnectionChecker,
      login: mockLogin
    );
  });

  void setupConnectionChecker(){
    when(mockInternetConnectionChecker.isConnected()).thenAnswer((_) async => true);
  }
  
  group("Login", (){
    test("should_emit_[InProgrsss,Success]_when_Login_success", () async {
      setupConnectionChecker();
      final tUserSession = UserSession(authToken: "authToken");
      when(mockLogin(any))
        .thenAnswer((_) async => Right(tUserSession));
      final expected = [
        LoginInitial(), 
        LoginInProgress(), 
        LoginSuccess(tUserSession, true)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(StartLoginEvent(username: "username", password: "password", saveSession: true));
    });
    test("should_emit_[InProgress,Failed]_when_Login_failed", () async {
      setupConnectionChecker();
      when(mockLogin(any))
        .thenAnswer((_) async => Left(BadRequestFailure(INVALID_CREDENTIALS)));
      final expected = [
        LoginInitial(), 
        LoginInProgress(), 
        LoginFailed(INVALID_CREDENTIALS)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(StartLoginEvent(username: "username", password: "password", saveSession: true));
    });
    test("should_emit_[InProgress,ErrorOccurred]_when_Login_failed_not_invalid_credentials", () async {
      setupConnectionChecker();
      when(mockLogin(any))
        .thenAnswer((_) async => Left(ServerFailure("some failure")));
      final expected = [
        LoginInitial(), 
        LoginInProgress(), 
        LoginError("some failure")];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(StartLoginEvent(username: "username", password: "password", saveSession: true));
    });
    test("should_emit_[ErrorOccurred]_when_no_connection", () async {
      when(mockInternetConnectionChecker.isConnected()).thenAnswer((_) async => false);
      final expected = [
        LoginInitial(), 
        LoginError(NO_CONNECTION)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(StartLoginEvent(username: "username", password: "password", saveSession: true));
    });
  });

}


