import 'package:clean_ntmu/features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:clean_ntmu/features/profile/presentation/widgets/profile_edit_widget.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: ProfilePage()
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  @override
  void initState(){
    super.initState();
    final userSession = (BlocProvider.of<UserSessionBloc>(context).state as UserSessionLoaded).userSession;
    BlocProvider.of<ProfileBloc>(context).add(InitializeProfileEvent(userSession));
  }

  @override
  Widget build(BuildContext context){
    return BlocConsumer(
      bloc: BlocProvider.of<ProfileBloc>(context),
      listener: (context, ProfileState state){
        if(state is ProfileError){
          print(state.error);
        }
      },
      builder: (context, ProfileState state){
        if(state.profile == null){
          return Center(child: CircularProgressIndicator());
        }else{
          return ProfileEditWidget();
        }
      },
    );
  }
}

