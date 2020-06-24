import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';

abstract class UserSessionRepository {
  Future<Failure> saveSession(UserSession session);
  Future<Either<Failure,UserSession>> getSavedSession();
  Future<Failure> endSession();
  Future<Either<Failure,UserSession>> startNewSession(String username, String password);
  Future<Failure> register(Map<String,dynamic> data);
  Future<Failure> forgetPassword(String email);
}