import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/static_data/domain/repositories/static_data_repository.dart';
import 'features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'features/user_session/presentation/pages/main_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await sl<StaticDataRepository>().loadDataFromFile();
  await sl.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=>sl<UserSessionBloc>(),
      child: 
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFF212121),
          primaryColorLight: Color(0xFF484848),
          primaryColorDark: Color(0xFF000000),
          accentColor: Color(0xFF1a237e),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF212121),
            textTheme: ButtonTextTheme.primary
          ),
        ),
        home: MainPage()
      )
    );
  }
}
