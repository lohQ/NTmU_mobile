import 'package:clean_ntmu/features/user_session/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateDisplayWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      // height: MediaQuery.of(context).size.height/12,
      child: Center(
        child: BlocConsumer(
          bloc: BlocProvider.of<LoginBloc>(context),
          listener: (context, LoginState state){
            if (state is LoginError) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.errorString)));
            } 
          },
          builder: (context, LoginState state){
            if (state is LoginInProgress) {
              return Padding(padding: EdgeInsets.all(10),child: LinearProgressIndicator());
            } else if (state is LoginFailed) {
              return Text(state.failureString, style: TextStyle(color: Colors.red));
            } else {
              return Container();
            }
          },
        )
      )
    );
  }

}