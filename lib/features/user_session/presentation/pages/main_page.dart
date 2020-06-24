import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/pages/home_view.dart';
import 'package:clean_ntmu/features/user_session/presentation/pages/splahs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_view.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return 
      BlocBuilder(
        bloc: BlocProvider.of<UserSessionBloc>(context),
        builder: (context, state){ 
          if(state is UserSessionInitial){
            return SplashPage();
          }else if(state is UserSessionEnded){
            return LoginView();
          }else if(state is UserSessionLoaded){
            return HomeView();
          }else if(state is UserSessionErrorOccurred){
            return _buildErrorPage(context, state.errorString);
          }
          return _buildLoadingPage(context);
        },
    ); 
  }

  Widget _buildLoadingPage(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(child: CircularProgressIndicator())
    );
  }

  Widget _buildErrorPage(BuildContext context, String errorString){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(child: Text(errorString))
    );
  }
}