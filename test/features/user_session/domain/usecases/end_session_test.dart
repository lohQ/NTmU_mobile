import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/user_session/data/repositories/user_session_repository_impl.dart';
import 'package:clean_ntmu/features/user_session/domain/usecases/end_session.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUserSessionRepositoryImpl extends Mock implements UserSessionRepositoryImpl {}

void main() {

  MockUserSessionRepositoryImpl mockUserSessionRepo;
  EndSession usecase;

  setUp((){
    mockUserSessionRepo = MockUserSessionRepositoryImpl();
    usecase = EndSession(userSessionRepo: mockUserSessionRepo);
  });

  test("should_return_null_if_success", () async {
    when(mockUserSessionRepo.endSession())
      .thenAnswer((_) async => null);
    final result = await usecase.call(NoParams());
    expect(result, Right(null));
  });

  test("should_return_failure_if_fails", () async {
    when(mockUserSessionRepo.endSession())
      .thenAnswer((_) async => UncategorizedFailure("some error"));
    final result = await usecase.call(NoParams());
    expect(result, Left(UncategorizedFailure("some error")));
  });

}