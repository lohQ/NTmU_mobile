import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/matchings/domain/usecases/indicateMatchAcceptance.dart';
import 'package:clean_ntmu/features/matchings/domain/usecases/loadAllMatchings.dart';
import 'package:clean_ntmu/features/matchings/domain/usecases/loadMatchings.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'matchings_event.dart';
part 'matchings_state.dart';

const int MATCH_PER_PAGE = 10;

class MatchingsBloc extends Bloc<MatchingsEvent, MatchingsState> {

  final LoadMatchings loadMatchings;
  final LoadAllMatchings loadAllMatchings;
  final IndicateMatchAcceptance indicateMatchAcceptance;
  final InternetConnectionChecker connectionChecker;

  MatchingsBloc({
    @required this.loadMatchings,
    @required this.loadAllMatchings,
    @required this.indicateMatchAcceptance, 
    @required this.connectionChecker});
  
  UserSession userSession;
  int newMatchingsMaxPage = 1;
  int pendingMatchingsMaxPage = 1;
  int historyMatchingsMaxPage = 1;

  Stream<MatchingsState> initMatchings() async* {
    yield MatchingsLoading(state);
    final params = LoadAllMatchingsParams(userSession, 1, 1, 1);
    final either = await loadAllMatchings(params);
    yield* either.fold(
      (failure) async* {
        yield MatchingsError(failure.message, state);
      },
      (matchingsMap) async* {
        final newMatchings = matchingsMap['new'];
        final pendingMatchings = matchingsMap['pending'];
        final historyMatchings = matchingsMap['history'];
        if(newMatchings.length != 0){newMatchingsMaxPage++;}
        if(pendingMatchings.length != 0){pendingMatchingsMaxPage++;}
        if(historyMatchings.length != 0){historyMatchingsMaxPage++;}
        yield AllMatchingsUpdated(
          newMatchings, pendingMatchings, historyMatchings
        );
      }
    );
  }

  int _getMaxPageOfType(MatchingsType type){
    if(type == MatchingsType.New){
      return newMatchingsMaxPage;
    }else if(type == MatchingsType.Pending){
      return pendingMatchingsMaxPage;
    }else{
      return historyMatchingsMaxPage;
    }    
  }

  void _incrementPageOfType(MatchingsType type){
    if(type == MatchingsType.New){
      newMatchingsMaxPage++;
    }else if(type == MatchingsType.Pending){
      pendingMatchingsMaxPage++;
    }else{
      historyMatchingsMaxPage++;
    }
  }

  Stream<MatchingsState> loadMatchingsOfType(MatchingsType type) async* {
    yield MatchingsLoading(state);
    final page = _getMaxPageOfType(type);
    final params = LoadMatchingsParam(userSession, page, type);
    final matchingsEither = await loadMatchings(params);
    yield* matchingsEither.fold(
      (failure) async* {
        yield MatchingsError(failure.message, state);
      },
      (matchings) async* {
        if(matchings.length == 0){
          yield NoMatchingsUpdated(state);
          return;
        }else{
          _incrementPageOfType(type);
        }
        if(type == MatchingsType.New){
          yield NewMatchingsUpdated((state.newMatchings+matchings), state);
        }else if(type == MatchingsType.Pending){
          yield PendingMatchingsUpdated((state.pendingMatchings+matchings), state);
        }else{
          yield HistoryMatchingsUpdated((state.historyMatchings+matchings), state);
        }
      }
    );

  }

  // from new to pending or to history
  void updateHandledMatch(
    Matching match, 
    List<Matching> newMatchings, 
    List<Matching> pending, 
    List<Matching> history
  ){
    newMatchings.removeWhere((m)=>m.id==match.id);
    if(match.selfChoice == -1){
      history.insert(0,match);
    }else if(match.oppChoice == 1){
      history.insert(0, match);
    }else{
      pending.insert(0, match);
    }
  }

  @override
  MatchingsState get initialState => MatchingsInitial();

  @override
  Stream<MatchingsState> mapEventToState(
    MatchingsEvent event,
  ) async* {
    if(event is InitMatchingsEvent){
      userSession = event.userSession;
      // yield local cached matchings
      if(await connectionChecker.isConnected()){
        yield* initMatchings();
      }else{
        yield MatchingsNetworkError("No connection", state);
      }

    } else if(event is LoadMoreNewMatchingsEvent){
      if(await connectionChecker.isConnected()){
        yield* loadMatchingsOfType(MatchingsType.New);
      }else{
        yield MatchingsNetworkError("No connection", state);
      }

    } else if(event is LoadMorePendingMatchingsEvent){
      if(await connectionChecker.isConnected()){
        yield* loadMatchingsOfType(MatchingsType.Pending);
      }else{
        yield MatchingsNetworkError("No connection", state);
      }

    } else if(event is LoadMoreHistoryMatchingsEvent){
      if(await connectionChecker.isConnected()){
        yield* loadMatchingsOfType(MatchingsType.History);
      }else{
        yield MatchingsNetworkError("No connection", state);
      }

    } else if (event is ReloadAllMatchingsEvent) {
      if(await connectionChecker.isConnected()){
        yield MatchingsLoading(state);
        final params = LoadAllMatchingsParams(
          userSession, 
          newMatchingsMaxPage, 
          pendingMatchingsMaxPage, 
          historyMatchingsMaxPage);
        final result = await loadAllMatchings(params);
        yield* result.fold(
          (failure) async* {
            print("yielded matchings error");
            yield MatchingsError(failure.message, state);
          },
          (matchings) async* {
            print("yielded matchings updated");
            yield AllMatchingsUpdated(
              matchings['new'],
              matchings['pending'],
              matchings['history']
            );
          }
        );
      }else{
        print("yielded matchings network error");
        yield MatchingsNetworkError("No connection", state);
      }

    } else if (event is IndicateAcceptanceEvent){
      if(await connectionChecker.isConnected()){
        final params = MatchAcceptanceParams(userSession, event.matchId, event.accept);
        final result = await indicateMatchAcceptance(params);
        yield* result.fold(
          (failure) async* {
            yield MatchingsError(failure.message, state);
          }, 
          (match) async* {
            // doesn't look efficient...
            final newListCopy = List.from(state.newMatchings).cast<Matching>();
            final pendingListCopy = List.from(state.pendingMatchings).cast<Matching>();
            final historyListCopy = List.from(state.historyMatchings).cast<Matching>();
            updateHandledMatch(match, newListCopy, pendingListCopy, historyListCopy);
            yield AllMatchingsUpdated(newListCopy, pendingListCopy, historyListCopy);
          }
        );
      }else{
        yield MatchingsNetworkError("No connection", state);
      }

    }

  }
}
