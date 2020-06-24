import 'package:clean_ntmu/features/profile/presentation/blocs/change_password_bloc/changepassword_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class ChangePasswordView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>sl<ChangepasswordBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Change Password")),
        body: ChangePasswordPage()
      )
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage>{

  final oldController = TextEditingController();
  final newController1 = TextEditingController();
  final newController2 = TextEditingController();
  String validationError;

  @override
  void dispose(){
    oldController.dispose();
    newController1.dispose();
    newController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<ChangepasswordBloc>(context),
      builder: (context, ChangepasswordState state){
        if(state is ChangepasswordSubmitted){
          return Center(child: Text("Password changed successfully!"));
        }else if(state is ChangepasswordLoading){
          return Center(child: CircularProgressIndicator());
        }else{
          if(state is ChangepasswordError){
            setState(() {
              validationError = state.error;
            });
          }
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              TextField(
                controller: oldController,
                decoration: InputDecoration(
                  labelText: "Current password"
                ),
                obscureText: true,
              ),
              TextField(
                controller: newController1,
                decoration: InputDecoration(
                  labelText: "New password"
                ),
                obscureText: true,
              ),
              TextField(
                controller: newController2,
                decoration: InputDecoration(
                  labelText: "Retype new password"
                ),
                obscureText: true,
                onChanged: (String val){
                  setState(() {
                    if(val == newController1.text){
                      validationError = null;
                    }else{
                      validationError = "Both new password should be the same";
                    }
                  });
                },
              ),
              validationError == null
               ? Container()
               : Center(child: Text(validationError)),
              Padding(
                padding: EdgeInsets.all(10),
                child: 
                RaisedButton(
                  child: Text("Submit"),
                  onPressed: (){_submitForm(context);},
                  )
              )
            ],
          );
        }
      },
    );
  }

  void _submitForm(BuildContext context){
    if(validationError == "Both new password should be the same"){
      print("new password not confirmed, can't submit change password request");
      return;
    }else{
      final oldPassword = oldController.text;
      final newPassword1 = newController1.text;
      final newPassword2 = newController2.text;
      if(oldPassword.isEmpty || newPassword1.isEmpty || newPassword2.isEmpty){
        setState(() {
          validationError = "all three fields should not be empty";
        });
      }else{
        final userSession = (BlocProvider.of<UserSessionBloc>(context).state as UserSessionLoaded).userSession;
        BlocProvider.of<ChangepasswordBloc>(context).add(
          SubmitNewPassword(userSession, oldPassword, newPassword1));
      }
    }
  }

}