
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/presentation/blocs/preference_bloc/preference_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsEditWidget extends StatefulWidget {

  final List<DropdownMenuItem> daysToMatchList;

  SettingsEditWidget() : 
    daysToMatchList = List.generate(
      3, (i)=>DropdownMenuItem<int>(value: (i+1), child: Text("${i+1}"))
    ).toList();

  @override
  SettingsEditWidgetState createState() => SettingsEditWidgetState();
}

class SettingsEditWidgetState extends State<SettingsEditWidget>{

  final dataToUpdate = Map<String,dynamic>();
  int daysToMatch;
  bool interestedFlag;
  PreferenceBloc bloc;

  @override
  void initState(){
    super.initState();
    bloc = BlocProvider.of<PreferenceBloc>(context);
    interestedFlag = bloc.state.preference.interestedFlag;
    daysToMatch = bloc.state.preference.daysToMatch;
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void _saveChangedData(Preference pref){
    if(daysToMatch != pref.daysToMatch){
      dataToUpdate["number_of_days_to_receive_a_match"] = daysToMatch;
    }
    if(interestedFlag != pref.interestedFlag){
      dataToUpdate["interested_flag"] = interestedFlag;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Settings"),
        actions: <Widget>[
          BlocBuilder(
            bloc: bloc,
            builder: (context, PreferenceState state){
              if(state is PreferenceLoading){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                );
              }
              return FlatButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: (){
                  _saveChangedData(bloc.state.preference);
                  if(dataToUpdate.length == 0){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("No changes to save")));
                    return;
                  }
                  bloc.add(UpdatePreferenceEvent(dataToUpdate));              
                },
              );
            },
          )
        ]),
      body: BlocListener(
        bloc: bloc,
        listener: (context, PreferenceState state) async {
          if(state is PreferenceError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error),));
          }
          if(state is PreferenceUpdated){
            dataToUpdate.clear();
            // await showDialog(
            //   context: context,
            //   child: AlertDialog(
            //     content: Text("Settings updated"),
            //   )
            // );
          }
        },
        child: ListView(
          padding: EdgeInsets.all(10),
            children: <Widget>[
              CheckboxListTile(
                title: Text("I am interested in getting new recommendations"),
                value: interestedFlag, 
                onChanged: (bool newValue){
                  setState((){
                    interestedFlag = newValue;
                  });
                }),
              interestedFlag
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Number of days to receive a new recommendation"),
                      DropdownButton<int>(
                        value: daysToMatch,
                        items: widget.daysToMatchList,
                        onChanged: (int newValue){
                          setState((){
                            daysToMatch = newValue;
                          });
                        },
                      ),
                    ],
                  )
                )
              : Container()
            ]
        )
      )
    );
  }

}