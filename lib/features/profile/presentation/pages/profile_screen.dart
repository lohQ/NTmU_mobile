import 'package:clean_ntmu/features/profile/presentation/pages/profile_view.dart';
import 'package:clean_ntmu/features/profile/presentation/widgets/preference_bloc_wrapper.dart';
import 'package:clean_ntmu/features/profile/presentation/widgets/preference_edit_widget.dart';
import 'package:clean_ntmu/features/profile/presentation/widgets/settings_edit_widget.dart';
import 'package:clean_ntmu/features/user_session/presentation/widgets/end_session_widget.dart';
import 'package:flutter/material.dart';

import 'change_password_view.dart';
import 'feedback_view.dart';

class ProfileScreen extends StatefulWidget{
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>{
  final List<IconData> iconList = [
    Icons.portrait, Icons.favorite_border, Icons.settings, Icons.chat_bubble_outline, Icons.lock_outline];
  final List<String> titleList = [
    "Profile", "Preference", "Settings", "Feedback", "Change Password"];
  final List<String> subtitleList = [
    "View and edit your profile information", 
    "View and edit your matching preferences", 
    "View and edit your matching settings", 
    "Submit your feedback to help us improve!",
    "Change your password regularly for enhanced security"];
  List<Widget> targetPageList;

  @override
  void initState(){
    super.initState();
    targetPageList = [
      ProfileView(), 
      PreferenceBlocWrapper(PreferenceEditWidget()),
      PreferenceBlocWrapper(SettingsEditWidget()),
      FeedbackView(),
      ChangePasswordView()
    ];
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemCount: iconList.length,
              itemBuilder: (_, i)=>ListTile(
                leading: Icon(iconList[i]),
                title: Text(titleList[i]), 
                subtitle: Text(subtitleList[i]),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_)=>targetPageList[i])
                  );
                }
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: EndSessionWidget()
          )
        ],
      )
    );
  }

}

