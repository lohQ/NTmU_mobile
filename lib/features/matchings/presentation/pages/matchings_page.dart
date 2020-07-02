import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:clean_ntmu/features/matchings/presentation/widgets/wrapped_matchings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MatchingsPage extends StatelessWidget {

  final mainController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<MatchingsBloc>(context),
      listener: (_, MatchingsState state){
        if(state is AllMatchingsUpdated){
          print("matchings updated");
          mainController.refreshCompleted();
        }
        if(state is MatchingsError){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          mainController.refreshCompleted();
        }
        if(state is MatchingsNetworkError){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          mainController.refreshCompleted();
        }
      },
      builder: (context, MatchingsState state){
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: ClassicHeader(),
          controller: mainController,
          onRefresh: (){
            BlocProvider.of<MatchingsBloc>(context).add(ReloadAllMatchingsEvent());
          },
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text("New", style: TextStyle(fontSize: 20)),
              ),
              NewMatchingsRow(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text("Pending", style: TextStyle(fontSize: 20)),
              ),
              PendingMatchingsRow(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Text("History", style: TextStyle(fontSize: 20)),
              ),
              HistoryMatchingsRow(),
              SizedBox(height: 30),
            ],
          ),
        );
      }
    ); 
  }

}