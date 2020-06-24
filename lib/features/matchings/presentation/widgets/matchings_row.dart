import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/domain/repositories/matchings_repository.dart';
import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'matching_card.dart';

class MatchingsRow extends StatelessWidget {
  final MatchingsType matchingsType;
  final refreshController = RefreshController();

  MatchingsRow(this.matchingsType);

  List<Matching> getListOfConcern(MatchingsState state){
    if(matchingsType == MatchingsType.New){
      return state.newMatchings;
    }else if(matchingsType == MatchingsType.Pending){
      return state.pendingMatchings;
    }else{
      return state.historyMatchings;
    }
  }

  @override
  Widget build(BuildContext context){
    final height = MediaQuery.of(context).size.height/4;
    final sideWidth = MediaQuery.of(context).size.width/10;
    void onLoad(){
      if(matchingsType == MatchingsType.New){
        BlocProvider.of<MatchingsBloc>(context).add(LoadMoreNewMatchingsEvent());
      }else if(matchingsType == MatchingsType.Pending){
        BlocProvider.of<MatchingsBloc>(context).add(LoadMorePendingMatchingsEvent());
      }else{
        BlocProvider.of<MatchingsBloc>(context).add(LoadMoreHistoryMatchingsEvent());
      }
    }
    return Container(
      height: height,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: sideWidth,
          ),
          Expanded(
            child: BlocConsumer(
              bloc: BlocProvider.of<MatchingsBloc>(context),
              listener: (context, MatchingsState state){
                if(state is NoMatchingsUpdated){
                  refreshController.loadNoData();
                }else if(matchingsType == MatchingsType.New && state is NewMatchingsUpdated){
                  refreshController.loadComplete();
                }else if(matchingsType == MatchingsType.Pending && state is PendingMatchingsUpdated){
                  refreshController.loadComplete();
                }else if(matchingsType == MatchingsType.History && state is HistoryMatchingsUpdated){
                  refreshController.loadComplete();
                }
              },
              builder: (context, MatchingsState state){
                final matchings = getListOfConcern(state);
                bool enablePullUp = matchings.length >= MATCH_PER_PAGE;
                return 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: matchings.length == 0 ? Colors.blue.withOpacity(0.2) : Colors.white,
                  ),
                  child: 
                  SmartRefresher(
                    controller: refreshController,
                    enablePullDown: false,
                    enablePullUp: enablePullUp,
                    footer: ClassicFooter(),
                    onLoading: onLoad,
                    child: matchings.length == 0
                    ? ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10), child: Text("Seems like you have no matches here!"))
                      ])
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: matchings.length,
                      itemBuilder: (context, i) => MatchingCard(matchings[i])
                    ),
                  )
                );
              },
            )
          ),
          SizedBox(
            width: sideWidth,
          ),
        ],
      )
    );
  }
}