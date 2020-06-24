import 'dart:io';

import 'package:clean_ntmu/features/static_data/domain/entities/name_with_id.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/widgets/profile_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../injection_container.dart';

class RegisterView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>sl<RegisterBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: RegisterPage()
      )
    );
  }
}

class RegisterPage extends StatelessWidget {

  final registerData = Map<String,dynamic>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: BlocProvider.of<RegisterBloc>(context),
      listener: (context, RegisterState state) async {
        if(state is RegisterNetworkError){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
        }else if(state is RegisterError){
          await showDialog(
            context: context,
            child: AlertDialog(
              title: Text("Input invalid"),
              content: Text(state.error),
            )
          );
        }
      },
      builder: (context, RegisterState state){
        if(state is RegisterLoading){
          return Center(child: CircularProgressIndicator());
        }else if(state is RegisterSuccess){
          return Center(child: Text("Registration success.\nVerify your email to activate your account now!"));
        }else{
          return RegisterWidget(registerData);
        }
      },
    );
  }
}

class RegisterWidget extends StatefulWidget {
  final Map<String,dynamic> registerData;
  final List<NameWithId> staticHobbyList;
  final List<DropdownMenuItem> hobbyList;
  RegisterWidget(this.registerData, {Key key}) :
    staticHobbyList = StaticData().data['hobbies'],
    hobbyList = StaticData().data['hobbies'].map(
      (item)=>DropdownMenuItem<int>(value: item.id, child: Text(item.name))).toList(),
    super(key: key);

  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget>{

  final profileFormKey = GlobalKey<FormState>();
  int hobby;
  PickedFile avatar;
  String hobbyOrAvatarError;
  final imagePicker = ImagePicker();

  @override
  void initState(){
    super.initState();
    if(widget.registerData.containsKey('avatar')){
      avatar = PickedFile(widget.registerData['avatar']);
    }
  }

  @override
  Widget build(BuildContext context){
    return 
    ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(30),
      children: <Widget>[
        ProfileForm(profileFormKey, widget.registerData),
        _buildHobbyAndAvatar(),
        RaisedButton(
          child: Text("Submit"),
          onPressed: (){
            final formState = profileFormKey.currentState;
            if(formState.validate()){
              formState.save();
              if(widget.registerData.containsKey('hobbies') && avatar != null){
                widget.registerData['avatar'] = avatar.path;
                print(widget.registerData);
                BlocProvider.of<RegisterBloc>(context).add(SubmitRegisterForm(widget.registerData));
              }else{
                setState(() {
                  hobbyOrAvatarError = "should have at least one hobby and a avatar";                
                });
              }
            }
          },
        )
      ],
    );
  }

  Widget _buildHobbyAndAvatar(){
    return Column(
        children: <Widget>[
        FlatButton(
          child: Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.width - 80,
            width: MediaQuery.of(context).size.width - 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.black12),
              child: Center(
                child: (avatar == null)
                  ? Text("Tap here to add a avatar")
                  : Image.file(File(avatar.path))
              ),
            ),
            onPressed: () async {
              final newImage = await imagePicker.getImage(source: ImageSource.gallery);
              setState(() {
                avatar = newImage;
              });}
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: hobby,
                  items: widget.hobbyList,
                  hint: Text("Add hobby"),
                  onChanged: (int newValue){
                    setState((){
                      hobby = newValue;
                    });},
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  if(widget.registerData.containsKey('hobbies')){
                    List hobbies = widget.registerData['hobbies'];
                    if(!hobbies.contains(hobby)){
                      setState((){
                        hobbies.add(hobby);
                        hobby = null;
                      });
                    }                        
                  }else{
                    setState(() {
                      widget.registerData['hobbies'] = [hobby];
                      hobby = null;
                    });
                  }
                },
              )],
          ),
        ),
        widget.registerData.containsKey('hobbies') 
          ? Wrap(
              spacing: 5,
              children: List.from(widget.registerData['hobbies']).map(
                (h)=>Chip(
                  label: Text(widget.staticHobbyList.firstWhere((hobbyItem)=>hobbyItem.id == h).name),
                  labelPadding: EdgeInsets.all(5),
                  onDeleted: (){
                    setState((){
                      widget.registerData['hobbies'].remove(h);
                    });
                  })).toList()
            )
          : Padding(padding: EdgeInsets.all(10),child: Text('Add some hobbies here!')),
        hobbyOrAvatarError != null
          ? Text(hobbyOrAvatarError, style: TextStyle(color: Colors.red))
          : Container()
        ],
    );
  }


}

