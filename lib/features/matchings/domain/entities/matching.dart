import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Matching extends Equatable{
  final int id;
  final Profile oppProfile;
  final int selfChoice;
  final int oppChoice;
  final String matchDescription;

  Matching({
    @required this.id,
    @required this.oppProfile, 
    @required this.selfChoice, 
    @required this.oppChoice, 
    @required this.matchDescription
  });

  @override
  List<Object> get props => [oppProfile, selfChoice, oppChoice, matchDescription];
}
