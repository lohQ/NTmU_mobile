import 'package:clean_ntmu/features/profile/presentation/blocs/preference_bloc/preference_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:clean_ntmu/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PreferenceBlocWrapper extends StatelessWidget {
  final Widget child;
  const PreferenceBlocWrapper(this.child);

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => sl<PreferenceBloc>(),
      child: PreferencePage(child)
    );
  }
}

class PreferencePage extends StatefulWidget {
  final Widget child;
  const PreferencePage(this.child);
  @override
  PreferencePageState createState() => PreferencePageState();
}

class PreferencePageState extends State<PreferencePage>{

  @override
  void initState(){
    super.initState();
    final userSession = (BlocProvider.of<UserSessionBloc>(context).state as UserSessionLoaded).userSession;
    BlocProvider.of<PreferenceBloc>(context).add(InitializePreferenceEvent(userSession));
  }

  @override
  Widget build(BuildContext context){
    return BlocBuilder(
      bloc: BlocProvider.of<PreferenceBloc>(context),
      builder: (_, PreferenceState state){
        if(state.preference == null){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return widget.child;
        }
      },
    );
  }
}

