import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class IndicateMatchAcceptance extends Usecase<Matching, MatchAcceptanceParams>{
  final MatchingsRepository matchingRepo;
  IndicateMatchAcceptance({@required this.matchingRepo});

  @override
  Future<Either<Failure, Matching>> call(MatchAcceptanceParams params) {
    if(params.accept){
      return matchingRepo.acceptMatch(params.userSession, params.matchId);
    }else{
      return matchingRepo.rejectMatch(params.userSession, params.matchId);
    }
  }

}

class MatchAcceptanceParams {
  final UserSession userSession;
  final int matchId;
  final bool accept;
  
  MatchAcceptanceParams(this.userSession, this.matchId, this.accept);
}