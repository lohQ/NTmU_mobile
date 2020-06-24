// import 'dart:async';
// import 'dart:convert';

// import 'package:clean_ntmu/core/error/exception.dart';
// import 'package:clean_ntmu/core/error/failure.dart';
// import 'package:clean_ntmu/features/user_session/data/data_sources/user_session_local_data_source.dart';
// import 'package:clean_ntmu/features/user_session/data/models/user_session_model.dart';
// import 'package:clean_ntmu/features/user_session/data/repositories/user_session_repository_impl.dart';
// import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
// import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart';
// import 'package:mockito/mockito.dart';

// import '../../../../fixtures/fixture_reader.dart';

// class MockClient extends Mock implements Client {}
// class MockUserSessionLocalDataSource extends Mock implements UserSessionLocalDataSource {}

// void main() {

//   UserSessionRepositoryImpl userSessionRepo;
//   MockClient mockClient;
//   MockUserSessionLocalDataSource mockLocalDataSource;

//   setUp((){
//     mockClient = MockClient();
//     mockLocalDataSource = MockUserSessionLocalDataSource();
//     userSessionRepo = UserSessionRepositoryImpl(
//       httpClient: mockClient,
//       localDataSource: mockLocalDataSource
//     );
//   });

//   group("startNewSession", (){
//     final tResponseString = fixture("response_fixture.json");
//     final UserSession tUserSession = UserSessionModel.fromJson(json.decode(tResponseString));
//     final tResponse = Response(tResponseString, 200);

//     Future<Either<Failure,UserSession>> act() async {
//       return userSessionRepo.startNewSession(username: "username", password: "password");
//     }
//     void setupSendPostRequestWithAnswer(Function answer){
//       when(mockClient.post(any, headers: anyNamed("headers"), body: anyNamed("body")))
//         .thenAnswer(answer);
//     }

//     test("should_return_UserSession_when_success", () async {
//       setupSendPostRequestWithAnswer((_) async => tResponse);
//       final result = await act();
//       expect(result, Right(tUserSession));
//     });
//     test("should_return_ServerFailure_when_timeout", () async {
//       when(mockClient.post(any, headers: anyNamed("headers"), body: anyNamed("body")))
//         .thenThrow(TimeoutException(""));
//       final result = await act();
//       expect(result, Left<Failure,UserSession>(ServerFailure(SERVER_NOT_AVAILABLE)));
//     });
//     test("should_return_ServerFailure_when_respsone_code_is_5xx", () async {
//       final serverFailureResponse = Response("", 500, reasonPhrase: "server error");
//       setupSendPostRequestWithAnswer((_) async => serverFailureResponse);
//       final result = await act();
//       expect(result, Left(ServerFailure("500: server error")));
//     });
//     test("should_return_ClientFailure_when_response_code_is_4xx", () async {
//       final clientFailureResponse = Response("", 499, reasonPhrase: "invalid credentials");
//       setupSendPostRequestWithAnswer((_) async => clientFailureResponse);
//       final result = await act();
//       expect(result, Left(ClientFailure("499: invalid credentials")));
//     });
//   });

//   group("saveSession", (){
//     final tUserSession = UserSessionModel(id: 310, token: "any");
//     test("should_save_success", () async {
//       when(mockLocalDataSource.saveSession(tUserSession))
//         .thenAnswer((_) async => null);
//       final result = await userSessionRepo.saveSession(session: tUserSession);
//       expect(result, null);
//     });
//     test("should_return_StorageFailure_when_StorageException_thrown", () async {
//       when(mockLocalDataSource.saveSession(tUserSession))
//         .thenThrow(MyStorageException(""));
//       final result = await userSessionRepo.saveSession(session: tUserSession);
//       expect(result, StorageFailure(""));
//     });
//   });

//   group("getSavedSession", (){
//     final tUserSession = UserSessionModel(id: 310, token: "any");
//     test("should_return_UserSession_if_has_data", () async {
//       when(mockLocalDataSource.getSavedSession())
//         .thenAnswer((_) async => tUserSession);
//       final result = await userSessionRepo.getSavedSession();
//       expect(result, Right(tUserSession));
//     });
//     test("should_return_failure_if_no_data", () async {
//       when(mockLocalDataSource.getSavedSession())
//         .thenAnswer((_) async => null);
//       final result = await userSessionRepo.getSavedSession();
//       expect(result, Left(StorageFailure(NO_SAVED_SESSION)));
//     });
//   });

//   group("endSession", (){
//     test("should_return_null_when_success", () async {
//       when(mockLocalDataSource.deleteSavedSession())
//         .thenAnswer((_) async => null);
//       final result = await userSessionRepo.endSession();
//       expect(result, null);
//     });
//     test("should_return_failure_when_fails", () async {
//       when(mockLocalDataSource.deleteSavedSession())
//         .thenThrow(MyStorageException("some error"));
//       final result = await userSessionRepo.endSession();
//       expect(result, StorageFailure("some error"));
//     });

//   });

// }