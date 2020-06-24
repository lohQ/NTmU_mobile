import 'dart:convert';

import 'package:clean_ntmu/core/constants/network_constants.dart';
import 'package:clean_ntmu/features/user_session/data/models/user_session_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class UserSessionRemoteDataSource {
  Future<UserSessionModel> login(String username, String password);
  Future<void> register(Map<String,dynamic> data);
  Future<void> forgetPassword(String email);
}

class UserSessionRemoteDataSourceImpl extends UserSessionRemoteDataSource {

  final Dio dioClient;

  UserSessionRemoteDataSourceImpl({@required this.dioClient});

  @override
  Future<void> forgetPassword(String email) async {
    final url = "$BASE_URL/$FORGET_PASSWORD/";
    final data = {"email": email};
    await dioClient.post(url, data: data);
  }

  @override
  Future<UserSessionModel> login(String username, String password) async {
    final url = "$BASE_URL/$LOGIN_URL/";
    final data = {"username": username, "password": password};
    final response = await dioClient.post<Map<String,dynamic>>(url, data: data);
    return UserSessionModel.fromJson(response.data);
  }

  @override
  Future<void> register(Map<String, dynamic> data) async {
    final url = "$BASE_URL/$REGISTER/";
    data['avatar'] = await MultipartFile.fromFile(data['avatar']);
    data['hobbies'] = json.encode(data['hobbies']);
    final formData = FormData.fromMap(data);
    await dioClient.post(url, data:formData);
  }

}