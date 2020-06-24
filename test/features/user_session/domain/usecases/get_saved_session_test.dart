import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/data/repositories/user_session_repository_impl.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/get_saved_session.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserSessionRepositoryImpl extends Mock implements UserSessionRepositoryImpl {}

void main() {

  MockUserSessionRepositoryImpl mockUserSessionRepo;
  GetSavedSession usecase;

  setUp((){
    mockUserSessionRepo = MockUserSessionRepositoryImpl();
    usecase = GetSavedSession(userSessionRepo: mockUserSessionRepo);
  });

  final tUserSession = UserSession(authToken: "u001_token");

  test("should_return_UserSession_when_get_success", () async {
    when(mockUserSessionRepo.getSavedSession())
      .thenAnswer((_) async => Right(tUserSession));
    final result = await usecase.call(NoParams());
    expect(result, Right(tUserSession));
  });
  test("should_return_Failure_when_get_failed", () async {
    when(mockUserSessionRepo.getSavedSession())
      .thenAnswer((_) async => Left(StorageReadFailure(NO_SAVED_SESSION)));
    final result = await usecase.call(NoParams());
    expect(result, Left(StorageReadFailure(NO_SAVED_SESSION)));
  });

}