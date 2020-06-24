import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class UserSession extends Equatable{
  final String authToken;
  UserSession({
    @required this.authToken
  });

  @override
  List<Object> get props => [authToken];
}