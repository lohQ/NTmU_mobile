import 'dart:async';
import 'dart:convert';

import 'package:clean_ntmu/core/constants/network_constants.dart';
import 'package:clean_ntmu/features/profile/data/models/answer_model.dart';
import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:clean_ntmu/features/profile/data/models/report_model.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile(UserSession userSession);
  Future<ProfileModel> updateProfile(UserSession userSession, int id, Map<String,dynamic> data);
  Future<PreferenceModel> getPreference(UserSession userSession);
  Future<PreferenceModel> updatePreference(UserSession userSession, int id, Map<String,dynamic> data);
  Future<ReportModel> createReport(UserSession userSession, Map<String,dynamic> data);
  Future<void> changePassword(UserSession userSession, Map<String,String> data);
  Future<void> submitFeedback(String authToken, List<Map<String,dynamic>> answers);
  Future<List<AnswerModel>> viewFeedback(String authToken);
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final Dio dioClient;
  ProfileRemoteDataSourceImpl({@required this.dioClient});

  static const String TAG = "Profile Remote Data Source";

  Options getAuthOptions(String token){
    return Options(
      headers: {"Authorization": "Token $token"}, 
      sendTimeout: 5000, 
      receiveTimeout: 3000);
  }

  @override
  Future<ProfileModel> getProfile(UserSession userSession) async {
    final url = "$BASE_URL/$SELF_PROFILE/";
    final options = getAuthOptions(userSession.authToken);
    final response = await dioClient.get<Map<String,dynamic>>(url, options: options);
    final Map<String,dynamic> profileJson = response.data;
    return ProfileModel.fromJson(profileJson);
 }

  @override
  Future<PreferenceModel> getPreference(UserSession userSession) async {
    final url = "$BASE_URL/$SELF_PREFERENCE/";
    final options = getAuthOptions(userSession.authToken);
    final response = await dioClient.get<Map<String,dynamic>>(url, options: options);
    final Map<String,dynamic> preferenceJson = response.data;
    return PreferenceModel.fromJson(preferenceJson);
 }

  @override
  Future<PreferenceModel> updatePreference(UserSession userSession, int id, Map<String,dynamic> data) async {
    final url = "$BASE_URL/$ALL_PREFERENCE/$id/";
    final options = getAuthOptions(userSession.authToken);
    final response = await dioClient.patch<Map<String,dynamic>>(url, options: options, data: data);
    final Map<String,dynamic> newPrefJson = response.data;
    return PreferenceModel.fromJson(newPrefJson);
  }

  @override
  Future<ProfileModel> updateProfile(UserSession userSession, int id, Map<String,dynamic> data) async {
    final url = "$BASE_URL/$ALL_PROFILE/$id/";
    final options = getAuthOptions(userSession.authToken);
    if(data.containsKey('avatar')){
      data['avatar'] = await MultipartFile.fromFile(data['avatar']);
    }
    if(data.containsKey('hobbies')){
      data['hobbies'] = json.encode(data['hobbies']);
    }
    final formData = FormData.fromMap(data);
    final response = await dioClient.patch<Map<String,dynamic>>(url, options: options, data: formData);
    return ProfileModel.fromJson(response.data);
  }

  @override
  Future<ReportModel> createReport(UserSession userSession, Map<String,dynamic> data) async {
    final url = "$BASE_URL/$ALL_REPORT/";
    final options = getAuthOptions(userSession.authToken);
    final response = await dioClient.post<Map<String,dynamic>>(url, options: options, data: data);
    final Map<String,dynamic> newReportJson = response.data;
    return ReportModel.fromJson(newReportJson);
  }

  @override
  Future<void> changePassword(UserSession userSession, Map<String, String> data) async {
    final url = "$BASE_URL/$CHANGE_PASSWORD/";
    final options = getAuthOptions(userSession.authToken);
    await dioClient.post(url, options: options, data: data);
  }

  Future<void> submitFeedback(String authToken, List<Map<String,dynamic>> answers) async {
    final url = "$BASE_URL/$SUBMIT_FEEDBACK/";
    final options = getAuthOptions(authToken);
    final currentFeedback = await viewFeedback(authToken);
    if(currentFeedback.length == 0){
      await dioClient.post(url, options: options, data: answers);
    }else{
      throw Exception("Feedback already submitted");
    }
  }

  Future<List<AnswerModel>> viewFeedback(String authToken) async {
    final url = "$BASE_URL/$VIEW_FEEDBACK/";
    final options = getAuthOptions(authToken);
    final response = await dioClient.get<List<dynamic>>(url, options: options);
    if(response.data.length == 0){
      return List<AnswerModel>();
    }
    final responseJson = response.data.cast<Map<String,dynamic>>();
    return responseJson.map((json)=>AnswerModel.fromJson(json)).toList();
  }

}