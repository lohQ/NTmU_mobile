import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget{
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 3))
      .whenComplete((){
        BlocProvider.of<UserSessionBloc>(context).add(LoadSessionEvent());
      });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fitHeight
        )
      )
    );
  }
}