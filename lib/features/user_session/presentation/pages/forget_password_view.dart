import 'package:clean_ntmu/core/util/inputValidator.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/forget_password_bloc/forget_password_bloc.dart';
import 'package:clean_ntmu/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>sl<ForgetPasswordBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Forget password")),
        body: ForgetPasswordPage()
      )
    );
  }
}

class ForgetPasswordPage extends StatefulWidget {
  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage>{

  final formKey = GlobalKey<FormState>();
  String email;

  @override
  Widget build(BuildContext context){
    return BlocConsumer(
        bloc: BlocProvider.of<ForgetPasswordBloc>(context),
        listener: (context, ForgetPasswordState state){
          if(state is ForgetPasswordError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }else if(state is ForgetPasswordNetworkError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, ForgetPasswordState state){
          if(state is ForgetPasswordLoading){
            return Center(
              child: CircularProgressIndicator()
            );
          }else if(state is ForgetPasswordSubmitted){
            return Center(
              child: Text("Password reset link has been sent to $email. ")
            );
          }else{
            return ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    initialValue: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "john@e.ntu.edu.sg"
                    ),
                    validator: InputValidator.validateEmail,
                    onSaved: (String val){email = val;}
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    child: Text("Submit"),
                    onPressed: (){
                      final formState = formKey.currentState;
                      if(formState.validate()){
                        formState.save();
                        BlocProvider.of<ForgetPasswordBloc>(context).add(SubmitForgetPasswordForm(email));
                      }
                    },
                )
                )
              ],
            );
          }
        },
    );
  }
}