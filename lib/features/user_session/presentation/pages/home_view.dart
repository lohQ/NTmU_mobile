import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:clean_ntmu/features/matchings/presentation/pages/matchings_page.dart';
import 'package:clean_ntmu/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class HomeView extends StatefulWidget{
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>{
  MatchingsBloc matchingsBloc;

  @override
  void initState(){
    super.initState();
    final userSession = (BlocProvider.of<UserSessionBloc>(context).state as UserSessionLoaded).userSession;
    matchingsBloc = sl<MatchingsBloc>();
    matchingsBloc.add(InitMatchingsEvent(userSession));
  }

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>matchingsBloc,
      child: HomePage()
    );
  }

  @override
  void dispose(){
    matchingsBloc.close();
    super.dispose();
  }
}



class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  int _tabIndex;

  List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.find_in_page),
      title: Text("Matchings")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      title: Text("Chats")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text("Settings")
    )
  ];
  List<Widget> _tabs = [
    MatchingsPage(),
    // TestRefresherPage(),
    Text("chat page"),
    ProfileScreen(),
  ];


  @override
  void initState(){
    super.initState();
    _tabIndex = 0;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("NTmU")),
      body: Center(child: _tabs[_tabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        items: _navItems,
        onTap: (newIndex){
          setState(() {
            _tabIndex = newIndex;
          });
        }
      ),
    );
  }

}
