import 'package:clean_ntmu/core/util/inputValidator.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/widgets/obscurable_textformfield.dart';
import 'package:clean_ntmu/features/user_session/presentation/widgets/state_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import 'forget_password_view.dart';
import 'register_view.dart';

class LoginView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: BlocProvider<LoginBloc>(
        create: (_)=>sl<LoginBloc>(),
        child: LoginPage(),
      )
    );
  }
}


class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{

  final formKey = GlobalKey();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool saveSession = true;

  @override
  void dispose(){
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<LoginBloc>(context),
      listener: (context, state){
        if(state is LoginSuccess){
          BlocProvider.of<UserSessionBloc>(context).add(LoadSessionEvent(state.session));
          if(state.saveSession){
            BlocProvider.of<UserSessionBloc>(context).add(SaveSessionEvent(state.session));
          }
        }else if(state is LoginFailed){
          usernameController.text = "";
          passwordController.text = "";
        }
      },
      child: Container(
        padding: EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              _buildForm(context),
              StateDisplayWidget(),
              RaisedButton(
                child: Text("login"),
                onPressed: (){
                  final FormState formState = formKey.currentState;
                  if(formState.validate()){
                    BlocProvider.of<LoginBloc>(context).add(StartLoginEvent(
                      username: usernameController.text, 
                      password: passwordController.text,
                      saveSession: saveSession));
                  }
                },
              ),
              FlatButton(
                child: Text("Forgot password"),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_)=>ForgetPasswordView())
                  );
                },
              ),
              FlatButton(
                child: Text("No account? Register here"),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_)=>RegisterView())
                  );
                },
              ),
            ],
        ),
      )
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "username"),
            validator: InputValidator.validateUsername,
          ),
          ObscurableTextFormField(
            controller: passwordController,
            labelText: "Password",
            hintText: "password",
            validator: InputValidator.validatePassword,
          ),
          CheckboxListTile(
            title: Text("Remember me"),
            value: saveSession, 
            onChanged: (val){
              setState(() {
                saveSession = val;
              });
            }
          ),
        ],
      ),
    );
  }


}