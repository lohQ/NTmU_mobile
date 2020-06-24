import 'package:connectivity/connectivity.dart';

abstract class InternetConnectionChecker {
  Future<bool> isConnected();
}

const String NO_CONNECTION = "No internet connection.";

class InternetConnectionCheckerImpl extends InternetConnectionChecker{

  final Connectivity connectivity;
  InternetConnectionCheckerImpl({this.connectivity});

  @override
  Future<bool> isConnected() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult != ConnectivityResult.none){
      return true;
    }
    return false;
  }

}