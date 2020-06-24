import 'dart:async';

import 'package:clean_ntmu/core/error/exception.dart';
import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/user_session/data/data_sources/user_session_local_data_source.dart';
import 'package:clean_ntmu/features/user_session/data/data_sources/user_session_remote_data_source.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/failures.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:clean_ntmu/features/user_session/domain/repositories/user_session_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class UserSessionRepositoryImpl extends UserSessionRepository{
  final UserSessionLocalDataSource localDataSource;
  final UserSessionRemoteDataSource remoteDataSource;
  UserSessionRepositoryImpl({
    @required this.localDataSource,
    @required this.remoteDataSource,
  }); 

  @override
  Future<Failure> endSession() async {
    try{
      await localDataSource.deleteSavedSession();
      return null;
    }catch(e){
      if(e is MyStorageException){
        return StorageWriteFailure(e.message);
      }
      return DartFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, UserSession>> getSavedSession() async {
    try{
      final UserSession result = await localDataSource.getSavedSession();
      if(result != null){
        return Right(result);
      }else{
        return Left(StorageReadFailure(NO_SAVED_SESSION));
      }
    }catch(e){
      if(e is MyStorageException){
        return Left(StorageReadFailure(e.message));
      }
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Failure> saveSession(UserSession session) async {
    try{
      await localDataSource.saveSession(session);
      return null;
    }catch(e){
      if(e is MyStorageException){
        return StorageWriteFailure(e.message);
      }
      return DartFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, UserSession>> startNewSession(String username, String password) async {
    try{
      final userSession = await remoteDataSource.login(username, password);
      return Right(userSession);
    } on DioError catch (e) {
      if(e.type == DioErrorType.RESPONSE && e.response.statusCode == 400){
        return Left(BadRequestFailure("Unable to login with provided credentials"));
      }
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Failure> forgetPassword(String email) async {
    try{
      await remoteDataSource.forgetPassword(email);
      return null;
    } on DioError catch (e) {
      return _mapDioErrorToFailure(e);
    } catch (e) {
      return DartFailure(e.toString());
    }
  }

  @override
  Future<Failure> register(Map<String, dynamic> data) async {
    try{
      await remoteDataSource.register(data);
      return null;
    } on DioError catch (e) {
      return _mapDioErrorToFailure(e);
    } catch (e) {
      return DartFailure(e.toString());
    }
  }

  Failure _mapDioErrorToFailure(DioError e){
    if(e.type == DioErrorType.CONNECT_TIMEOUT || 
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

}