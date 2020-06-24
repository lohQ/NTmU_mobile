
class MyException implements Exception {
  final String message;
  MyException(this.message);
}

class MyServerException extends MyException {
  MyServerException(String message) : super(message);
}
class MyClientException extends MyException {
  MyClientException(String message) : super(message);
}

class MyNetworkException extends MyException {
  MyNetworkException(String message) : super(message);
}
class MyStorageException extends MyException {
  MyStorageException(String message) : super(message);
}
