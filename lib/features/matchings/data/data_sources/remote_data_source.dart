import 'package:clean_ntmu/core/constants/network_constants.dart';
import 'package:clean_ntmu/features/matchings/data/models/matching_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class MatchingsRemoteDataSource {
  Future<List<MatchingModel>> getNewMatchingsAtPage(String authToken, int pageNum);
  Future<List<MatchingModel>> getPendingMatchingsAtPage(String authToken, int pageNum);
  Future<List<MatchingModel>> getHistoryMatchingsAtPage(String authToken, int pageNum);
  Future<MatchingModel> acceptMatch(String authToken, int matchId);
  Future<MatchingModel> rejectMatch(String authToken, int matchId);
}

class MatchingsRemoteDataSourceImpl extends MatchingsRemoteDataSource{
  final Dio dioClient;

  MatchingsRemoteDataSourceImpl({@required this.dioClient});

  Options _getAuthOptions(String token){
    return Options(
      headers: {"Authorization": "Token $token"}, 
      sendTimeout: 5000, 
      receiveTimeout: 3000);
  }

  @override
  Future<List<MatchingModel>> getNewMatchingsAtPage(String authToken, int pageNum) async {
    final url = "$BASE_URL/$GET_NEW_MATCH/$pageNum/";
    return await _getMatchings(authToken, url);
  }

  @override
  Future<List<MatchingModel>> getPendingMatchingsAtPage(String authToken, int pageNum) async {
    final url = "$BASE_URL/$GET_PENDING_MATCH/$pageNum/";
    return await _getMatchings(authToken, url);
  }

  @override
  Future<List<MatchingModel>> getHistoryMatchingsAtPage(String authToken, int pageNum) async {
    final url = "$BASE_URL/$GET_NOT_PENDING_MATCH/$pageNum/";
    return await _getMatchings(authToken, url);
  }

  Future<List<MatchingModel>> _getMatchings(String authToken, String url) async {
    final options = _getAuthOptions(authToken);
    print("sending get request to $url");
    final response = await dioClient.get(url, options: options);
    if(response.statusCode == 204){
      print("no data retrieved");
      return List<MatchingModel>(0);
    }
    final matchingsJson = (response.data as List).cast<Map<String,dynamic>>();
    final matchings = matchingsJson.map((json)=>MatchingModel.fromJson(json)).toList();
    print("retrived matchings of length: ${matchings.length}");
    return matchings;
  }

  @override
  Future<MatchingModel> acceptMatch(String authToken, int matchId) async {
    final url = "$BASE_URL/$ACCEPT_MATCH/$matchId/";
    final options = _getAuthOptions(authToken);
    final response = await dioClient.get<Map<String,dynamic>>(url, options: options);
    return MatchingModel.fromJson(response.data);
  }

  @override
  Future<MatchingModel> rejectMatch(String authToken, int matchId) async {
    final url = "$BASE_URL/$REJECT_MATCH/$matchId/";
    final options = _getAuthOptions(authToken);
    final response = await dioClient.get<Map<String,dynamic>>(url, options: options);
    return MatchingModel.fromJson(response.data);
  }  

}