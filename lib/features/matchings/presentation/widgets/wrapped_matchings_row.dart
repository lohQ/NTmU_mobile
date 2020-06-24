import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:flutter/cupertino.dart';

import 'matchings_row.dart';

class NewMatchingsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MatchingsRow(MatchingsType.New);
  }
}

class PendingMatchingsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MatchingsRow(MatchingsType.Pending);
  }
}

class HistoryMatchingsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MatchingsRow(MatchingsType.History);
  }
}