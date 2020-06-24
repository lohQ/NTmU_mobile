part of 'matchings_bloc.dart';

abstract class MatchingsEvent extends Equatable {
  const MatchingsEvent();
}

class InitMatchingsEvent extends MatchingsEvent{
  final UserSession userSession;
  InitMatchingsEvent(this.userSession);
  @override
  List<Object> get props => [];
}

class LoadMoreNewMatchingsEvent extends MatchingsEvent{
  @override
  List<Object> get props => [];
}

class LoadMorePendingMatchingsEvent extends MatchingsEvent{
  @override
  List<Object> get props => [];
}

class LoadMoreHistoryMatchingsEvent extends MatchingsEvent{
  @override
  List<Object> get props => [];
}

class ReloadAllMatchingsEvent extends MatchingsEvent {
  @override
  List<Object> get props => [];
}

class IndicateAcceptanceEvent extends MatchingsEvent {
  final int matchId;
  final bool accept;
  IndicateAcceptanceEvent(this.matchId, this.accept);
  @override
  List<Object> get props => [matchId];  
}

