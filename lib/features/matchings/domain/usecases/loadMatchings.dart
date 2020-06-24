import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class LoadMatchings extends Usecase<List<Matching>, LoadMatchingsParam>{

  final MatchingsRepository matchingsRepo;
  LoadMatchings({@required this.matchingsRepo});

  @override
  Future<Either<Failure, List<Matching>>> call(LoadMatchingsParam params) async {
    return await matchingsRepo.getMatchingsAt(params.userSession, params.page, params.type);
  }
  
}

class LoadMatchingsParam{
  final UserSession userSession;
  final int page;
  final MatchingsType type;

  LoadMatchingsParam(this.userSession, this.page, this.type);
}
