import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';

enum MatchingsType{
  New,
  Pending,
  History
}


abstract class MatchingsRepository {
  Future<Either<Failure, List<Matching>>> getMatchingsAt(UserSession userSession, int page, MatchingsType type);
  Future<Either<Failure, List<Matching>>> getNewMatchingsTill(UserSession userSession, int page);
  Future<Either<Failure, List<Matching>>> getPendingMatchingsTill(UserSession userSession, int page);
  Future<Either<Failure, List<Matching>>> getHistoryMatchingsTill(UserSession userSession, int page);
  Future<Either<Failure, Matching>> acceptMatch(UserSession userSession, int matchId);
  Future<Either<Failure, Matching>> rejectMatch(UserSession userSession, int matchId);
  // Future<Either<Failure, List<Matching>>> getCachedPendingMatchings(UserSession userSession);
  // Future<Either<Failure, List<Matching>>> getCachedHistoryMatchings(UserSession userSession);
}