import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:clean_ntmu/features/matchings/presentation/pages/opp_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchingCard extends StatelessWidget{

  final Matching matching;
  const MatchingCard(this.matching);

  Widget cardStateDisplay(){
    if(matching.selfChoice == -1 || matching.oppChoice == -1){
      return Text("Rejected", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800));
    }else if(matching.selfChoice == 1 && matching.oppChoice == 1){
      return Text("Matched", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height/4,
      width: MediaQuery.of(context).size.width/4,
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OppProfilePage(
                matching, 
                BlocProvider.of<MatchingsBloc>(context)
              ))
          );
        },
        child: Card(
          margin: EdgeInsets.all(5),
          elevation: 5,
          shape: RoundedRectangleBorder(
            // side: BorderSide(),
            borderRadius: BorderRadius.circular(10), 
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(matching.oppProfile.photoUrl),
                    fit: BoxFit.fill
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(matching.oppProfile.fullname),
                )
              ),
              cardStateDisplay()
            ],
          )
        )
      ),
    );
  }
}