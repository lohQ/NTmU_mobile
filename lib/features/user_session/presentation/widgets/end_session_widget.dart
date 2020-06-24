import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndSessionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Logout"),
      onPressed: () async {
        bool confirmLogout;
        await showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: Text("Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){
                  confirmLogout = false;
                  Navigator.pop(context);}),
              FlatButton(
                child: Text("Logout"),
                onPressed: (){
                  confirmLogout = true;
                  Navigator.pop(context);})
            ],
          )
        ).whenComplete((){
            if(confirmLogout){
              BlocProvider.of<UserSessionBloc>(context).add(EndSessionEvent());
            }}
        );
      }
    );
  }
}