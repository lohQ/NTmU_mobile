part of 'matchings_bloc.dart';

abstract class MatchingsState extends Equatable {
  final List<Matching> newMatchings;
  final List<Matching> pendingMatchings;
  final List<Matching> historyMatchings;
  MatchingsState(this.newMatchings, this.pendingMatchings, this.historyMatchings);
}

class MatchingsInitial extends MatchingsState {
  MatchingsInitial() : super(List<Matching>(0), List<Matching>(0), List<Matching>(0));
  @override
  List<Object> get props => [];
}

class MatchingsLoading extends MatchingsState {
  MatchingsLoading(MatchingsState state)
   : super(state.newMatchings, state.pendingMatchings, state.historyMatchings);
  @override
  List<Object> get props => [];
}

class AllMatchingsUpdated extends MatchingsState {
  AllMatchingsUpdated(
    List<Matching> newMatchings, 
    List<Matching> pending, 
    List<Matching> history) : super(newMatchings, pending, history);
  @override
  List<Object> get props => [newMatchings, pendingMatchings, historyMatchings];
}

class NewMatchingsUpdated extends MatchingsState {
  NewMatchingsUpdated(List<Matching> newMatchings, MatchingsState state)
   : super(newMatchings, state.pendingMatchings, state.historyMatchings);
  @override
  List<Object> get props => [newMatchings];
}
class PendingMatchingsUpdated extends MatchingsState {
  PendingMatchingsUpdated(List<Matching> pending, MatchingsState state)
   : super(state.newMatchings, pending, state.historyMatchings);
  @override
  List<Object> get props => [pendingMatchings];
}
class HistoryMatchingsUpdated extends MatchingsState {
  HistoryMatchingsUpdated(List<Matching> historyMatchings, MatchingsState state)
   : super(state.newMatchings, state.pendingMatchings, historyMatchings);
  @override
  List<Object> get props => [historyMatchings];
}

class NoMatchingsUpdated extends MatchingsState {
  NoMatchingsUpdated(MatchingsState state)
   : super(state.newMatchings, state.pendingMatchings, state.historyMatchings);
  @override
  List<Object> get props => [];
}

class MatchingsError extends MatchingsState {
  final String error;
  MatchingsError(this.error, MatchingsState state)
   : super(state.newMatchings, state.pendingMatchings, state.historyMatchings);
  @override
  List<Object> get props => [error];
}

class MatchingsNetworkError extends MatchingsState {
  final String error;
  MatchingsNetworkError(this.error, MatchingsState state)
   : super(state.newMatchings, state.pendingMatchings, state.historyMatchings);
  @override
  List<Object> get props => [error];
}
