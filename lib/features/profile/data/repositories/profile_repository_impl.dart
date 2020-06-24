import 'dart:async';

import 'package:clean_ntmu/core/error/exception.dart';
import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/features/profile/data/data_sources/local_data_source.dart';
import 'package:clean_ntmu/features/profile/data/data_sources/remote_data_source.dart';
import 'package:clean_ntmu/features/profile/data/models/answer_model.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/domain/repositories/profile_repository.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/question.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class ProfileRepositoryImpl extends ProfileRepository {

  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  ProfileRepositoryImpl({@required this.remoteDataSource, @required this.localDataSource});

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

  @override
  Either<Failure, Profile> getLocalProfile() {
    try{
      final result = localDataSource.loadCachedProfile();
      return Right(result);
    } on MyStorageException catch (e) {
      return Left(StorageReadFailure(e.message));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> getRemoteProfile(UserSession userSession) async {
    try{
      final result = await remoteDataSource.getProfile(userSession);
      localDataSource.cacheProfile(result);
      return Right(result);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(
    UserSession userSession, int id, Map<String,dynamic> data
  ) async {
    try{
      final result = await remoteDataSource.updateProfile(userSession, id, data);
      localDataSource.cacheProfile(result);
      return Right(result);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Either<Failure, Preference> getLocalPreference() {
    try{
      final result = localDataSource.loadCachedPreference();
      return Right(result);
    } on MyStorageException catch (e) {
      return Left(StorageReadFailure(e.message));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Preference>> getRemotePreference(UserSession userSession) async {
    try{
      final result = await remoteDataSource.getPreference(userSession);
      localDataSource.cachePreference(result);
      return Right(result);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Preference>> updatePreference(
    UserSession userSession, int id, Map<String,dynamic> data
  ) async {
    try{
      final result = await remoteDataSource.updatePreference(userSession, id, data);
      localDataSource.cachePreference(result);
      return Right(result);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(UserSession userSession, Map<String, String> data) async {
    String validationError = _validateBothPassword(data['old_password'], data['new_password1']);
    if(validationError != null){
      return Left(InvalidInputFailure(validationError));
    }
    try{
      await remoteDataSource.changePassword(userSession, data);
      return Right(null);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  String _validateBothPassword(String oldPassword, String newPassword){
    if(oldPassword.length < 8 || newPassword.length < 8){
      return "Password must have at least 8 characters";
    }else if(oldPassword == newPassword){
      return "New password should be different from old password";
    }
    return null;
  }

  @override
  Future<Either<Failure, void>> submitFeedback(UserSession userSession, List<Answer> answers) async {
    try{
      final answerJsons = answers.map((a)=>(a as AnswerModel).toJson()).toList();
      await remoteDataSource.submitFeedback(userSession.authToken, answerJsons);
      return Right(null);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Answer>>> viewFeedback(UserSession userSession) async {
    try{
      List<Answer> answers = await remoteDataSource.viewFeedback(userSession.authToken);
      if(answers.length == 0){
        final questions = StaticData().data['questions'].cast<Question>();
        answers = questions.map((q)=>AnswerModel.fromQuestion(q)).toList(); 
      }
      return Right(answers);
    } on DioError catch (e) {
      return Left(_mapDioErrorToFailure(e));
    } catch (e) {
      return Left(DartFailure(e.toString()));
    }
  }

}