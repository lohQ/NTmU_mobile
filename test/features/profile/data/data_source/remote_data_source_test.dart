// import 'dart:async';
// import 'dart:convert';

// import 'package:clean_ntmu/features/profile/data/data_sources/remote_data_source.dart';
// import 'package:clean_ntmu/features/profile/data/models/complete_profile_model.dart';
// import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
// import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
// import 'package:clean_ntmu/features/profile/data/models/report_model.dart';
// import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// import '../../../../fixtures/fixture_reader.dart';

// class MockDioClient extends Mock implements Dio {}

// void main(){
  
//   MockDioClient mockDioClient;
//   UserSession userSession;
//   ProfileRemoteDataSourceImpl remoteDataSourceImpl;

//   setUp((){
//     mockDioClient = MockDioClient();
//     userSession = UserSession(userId: 310, authToken: "auth_token");
//     remoteDataSourceImpl = ProfileRemoteDataSourceImpl(dioClient: mockDioClient);
//   });

//   group("general", (){
//     test("should_throw_TimeoutException_after_10_sec", (){
//       when(mockDioClient.get(any, headers: anyNamed('headers')))
//         .thenAnswer((_) async {
//           await Future.delayed(Duration(seconds: 11));
//           return Response("", 200);
//         });
//       expect(
//         () async => await remoteDataSourceImpl.getCompleteProfile(userSession), 
//         throwsA(isInstanceOf<TimeoutException>()));
//     });
//   });

//   group("getCompleteProfile", (){
//     test("should_return_CompleteProfileModel_when_status_code_is_200", () async {
//       final completeProfileStr = fixture("profile_fixture.json");
//       final response = Response(completeProfileStr, 200);
//       when(mockDioClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => response);
//       final result = await remoteDataSourceImpl.getCompleteProfile(userSession);
//       expect(result, isInstanceOf<CompleteProfileModel>());
//     });
//     test("should_throw_ClientException_when_status_code_is_404", () async {
//       final response = Response("", 404, reasonPhrase: "unauthorized");
//       when(mockDioClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => response);
//       expect(
//         () async => await remoteDataSourceImpl.getCompleteProfile(userSession),
//         throwsA(isInstanceOf<ClientException>())
//       );
//     });
//   });

//   group("updateProfile", (){

//     test("should_return_ProfileModel_when_status_code_is_202", () async {
//       final completeProfileStr = fixture("profile_fixture.json");
//       final profileModel = ProfileModel.fromJson(json.decode(completeProfileStr));
//       final response = Response(completeProfileStr, 202);
//       when(mockDioClient.patch(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       final result = await remoteDataSourceImpl.updateProfile(userSession, 301, {"data": "data"});
//       expect(result, isInstanceOf<ProfileModel>());
//       expect(result, profileModel);
//     });
//     test("should_return_ClientException_when_status_code_is_400", () async {
//       final response = Response("", 400);
//       when(mockDioClient.patch(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       expect(
//         () async => await remoteDataSourceImpl.updateProfile(userSession, 301, {"data": true}),
//         throwsA(isInstanceOf<ClientException>())
//       );
//     });

//   });


//   group("updatePreference", (){

//     test("should_return_PreferenceModel_when_status_code_is_202", () async {
//       final preferenceStr = fixture("preference_fixture.json");
//       final preferenceModel = PreferenceModel.fromJson(json.decode(preferenceStr));
//       final response = Response(preferenceStr, 202);
//       when(mockDioClient.patch(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       final result = await remoteDataSourceImpl.updatePreference(userSession, 301, {"data": "data"});
//       expect(result, isInstanceOf<PreferenceModel>());
//       expect(result, preferenceModel);
//     });
//     test("should_return_ClientException_when_status_code_is_400", () async {
//       final response = Response("", 400);
//       when(mockDioClient.patch(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       expect(
//         () async => await remoteDataSourceImpl.updatePreference(userSession, 301, {"data": true}),
//         throwsA(isInstanceOf<ClientException>())
//       );
//     });

//   });


//   group("createReport", (){

//     test("should_return_ReportModel_when_status_code_is_202", () async {
//       final reportStr = fixture("report_fixture.json");
//       final reportModel = ReportModel.fromJson(json.decode(reportStr));
//       final response = Response(reportStr, 201);
//       when(mockDioClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       final result = await remoteDataSourceImpl.createReport(userSession, {"data": "data"});
//       expect(result, isInstanceOf<ReportModel>());
//       expect(result, reportModel);
//     });
//     test("should_return_ClientException_when_status_code_is_400", () async {
//       final response = Response("", 400);
//       when(mockDioClient.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
//         .thenAnswer((_) async => response);
//       expect(
//         () async => await remoteDataSourceImpl.createReport(userSession, {"data": true}),
//         throwsA(isInstanceOf<ClientException>())
//       );
//     });

//   });


// }