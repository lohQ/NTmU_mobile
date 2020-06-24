
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  Failure(this.message);
  @override
  String toString() => message;
}

// input
class InvalidInputFailure extends Failure {
  InvalidInputFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
class IncompleteInputFailure extends Failure {
  IncompleteInputFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}

// remote data source
class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
// 400
class BadRequestFailure extends Failure{
  BadRequestFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
// 401
class UnauthenticatedFailure extends Failure {
  UnauthenticatedFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
// 403
class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
// 5xx
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
// 204
class NoDataFailure extends Failure {
  NoDataFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
class UncategorizedFailure extends Failure {
  UncategorizedFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}

// local data source
class StorageWriteFailure extends Failure {
  StorageWriteFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}
class StorageReadFailure extends Failure {
  StorageReadFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}

// dart
class DartFailure extends Failure {
  DartFailure(String message) : super(message);
  @override
  List<Object> get props => [message];
}

