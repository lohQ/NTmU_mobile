import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/matchings/data/data_sources/local_data_source.dart';
import 'package:clean_ntmu/features/matchings/data/data_sources/remote_data_source.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class MatchingsRepositoryImpl extends MatchingsRepository{

  final MatchingsRemoteDataSource remoteDataSource;
  final MatchingsLocalDataSource localDataSource;
  MatchingsRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.localDataSource});

  Failure _mapDioErrorToFailure(DioError e){
    if( e.type == DioErrorType.CONNECT_TIMEOUT || 
        e.type == DioErrorType.SEND_TIMEOUT || 
        e.type == DioErrorType.RECEIVE_TIMEOUT){
      return NetworkFailure(e.message);
    }else if(e.type == DioErrorType.RESPONSE){
      if(e.response.statusCode == 400){
        return BadRequestFailure(e.response.data.toString());
      }else if(e.response.statusCode == 401){ 
        return UnauthenticatedFailure(e.response.data.toString());
      }else if(e.response.statusCode == 403){
        return UnauthorizedFailure(e.response.data.toString());
      }else if(e.response.statusCode ~/ 100 == 5){
        return ServerFailure(e.response.data.toString());
      }
    }
    return UncategorizedFailure(e.message);
  }

  Future<Either<Failure, List<Matching>>> getMatchingsAt(UserSession session, int page, MatchingsType type) async {
    try{
      final matchings = List<Matching>();
      if(type == MatchingsType.New){
        matchings.addAll(await remoteDataSource.getNewMatchingsAtPage(session.authToken, page));
      }else if(type == MatchingsType.Pending){
        matchings.addAll(await remoteDataSource.getPendingMatchingsAtPage(session.authToken, page));
      }else if(type == MatchingsType.History){
        matchings.addAll(await remoteDataSource.getHistoryMatchingsAtPage(session.authToken, page));
      }
      return Right(matchings);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }    
  }

  Future<Either<Failure, List<Matching>>> _getMatchingsTill(String authToken, int page, MatchingsType type) async {
    try{
      final matchings = List<Matching>();
      if(type == MatchingsType.New){
        for(int i = 0; i < page; i++){
          matchings.addAll(await remoteDataSource.getNewMatchingsAtPage(authToken, i+1));
        }
      }else if(type == MatchingsType.Pending){
        for(int i = 0; i < page; i++){
          matchings.addAll(await remoteDataSource.getPendingMatchingsAtPage(authToken, i+1));
        }
      }else if(type == MatchingsType.History){
        for(int i = 0; i < page; i++){
          matchings.addAll(await remoteDataSource.getHistoryMatchingsAtPage(authToken, i+1));
        }
      }
      return Right(matchings);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }    
  }

  @override
  Future<Either<Failure, List<Matching>>> getNewMatchingsTill(UserSession userSession, int page) async {
    return await _getMatchingsTill(userSession.authToken, page, MatchingsType.New);
  }
  @override
  Future<Either<Failure, List<Matching>>> getPendingMatchingsTill(UserSession userSession, int page) async {
    return await _getMatchingsTill(userSession.authToken, page, MatchingsType.Pending);
  }
  @override
  Future<Either<Failure, List<Matching>>> getHistoryMatchingsTill(UserSession userSession, int page) async {
    return await _getMatchingsTill(userSession.authToken, page, MatchingsType.History);
  }

  @override
  Future<Either<Failure, Matching>> acceptMatch(UserSession userSession, int matchId) async {
    try{
      final match = await remoteDataSource.acceptMatch(userSession.authToken, matchId);
      return Right(match);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Matching>> rejectMatch(UserSession userSession, int matchId) async {
    try{
      final match = await remoteDataSource.rejectMatch(userSession.authToken, matchId);
      return Right(match);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, List<Matching>>> getCachedHistoryMatchings(UserSession userSession) {
  //   // TODO: implement getCachedHistoryMatchings
  //   return null;
  // }

  // @override
  // Future<Either<Failure, List<Matching>>> getCachedPendingMatchings(UserSession userSession) {
  //   // TODO: implement getCachedPendingMatchings
  //   return null;
  // }

}