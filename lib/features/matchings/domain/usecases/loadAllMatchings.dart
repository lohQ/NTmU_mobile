import 'package:clean_ntmu/core/error/failure.dart';
import 'package:clean_ntmu/core/usecase/usecase.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class LoadAllMatchings extends Usecase<Map<String,List<Matching>>, LoadAllMatchingsParams>{

  final MatchingsRepository matchingsRepo;

  LoadAllMatchings({@required this.matchingsRepo});

  @override
  Future<Either<Failure, Map<String, List<Matching>>>> call(LoadAllMatchingsParams params) async {
    final newMatchings = await matchingsRepo.getNewMatchingsTill(params.userSession, params.newPageMax);
    final pendingMatchings = await matchingsRepo.getPendingMatchingsTill(params.userSession, params.pendingPageMax);
    final historyMatchings = await matchingsRepo.getHistoryMatchingsTill(params.userSession, params.historyPageMax);
    return newMatchings.fold(
      (failure) => Left(failure),
      (allNew)  => pendingMatchings.fold(
          (failure)     => Left(failure),
          (allPending)  => historyMatchings.fold(
              (failure)     => Left(failure),
              (allHistory)  => Right({
                  "new": allNew,
                  "pending": allPending,
                  "history": allHistory
                }
              )
          )
      )
    );
  }

}

class LoadAllMatchingsParams{
  final UserSession userSession;
  final int newPageMax;
  final int pendingPageMax;
  final int historyPageMax;

  LoadAllMatchingsParams(this.userSession, this.newPageMax, this.pendingPageMax, this.historyPageMax);
}