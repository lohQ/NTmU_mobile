import 'dart:math';

import 'package:clean_ntmu/features/matchings/domain/entities/matching.dart';
import 'package:clean_ntmu/features/matchings/presentation/bloc/matchings_bloc.dart';
import 'package:flutter/material.dart';

class OppProfilePage extends StatelessWidget {
  final Matching matching;
  final MatchingsBloc bloc;
  final titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  OppProfilePage(this.matching, this.bloc);

  @override
  Widget build(BuildContext context){
    final profile = matching.oppProfile;
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.fullname),
      ),
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/3,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(profile.photoUrl)),
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              )),
            _buildDescriptionBox(),
            _buildGenderRow(profile.gender),
            _buildDoubleAttributeRow(profile.religion, profile.country),
            _buildAttributeRow("${profile.course.trim()} (matriculated in ${profile.matricYear})"),
            _buildHobbyList(profile.hobbies),
            _buildMatchDescription()
          ]
      ),
      bottomNavigationBar: 
        matching.selfChoice == 0 && matching.oppChoice != -1
        ? _buildActionRow()
        : null
    );
  }

  Widget _buildDescriptionBox(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description", style: titleStyle),
          Text(matching.oppProfile.description)
        ],
      ),
    );
  }

  Widget _buildActionRow(){
    return Row(children: <Widget>[
      Expanded(
        child: 
        RaisedButton(
          color: Colors.red,
          child: Text("Reject"),
          onPressed: (){
            bloc.add(IndicateAcceptanceEvent(matching.id, false));
          },
        )
      ),
      Expanded(
        child: 
        RaisedButton(
          color: Colors.green,
          child: Text("Accept"),
          onPressed: (){
            bloc.add(IndicateAcceptanceEvent(matching.id, true));
          },
        )
      )
    ]);
  }

  Widget _genderItem(String itemGender, String profileGender){
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(itemGender, style: TextStyle(color: profileGender == itemGender ? Colors.white : Colors.black)),
        ),
        decoration: BoxDecoration(
          color: profileGender == itemGender ? Colors.black87 : Colors.black12,
          borderRadius: BorderRadius.circular(5),
        ),
      )
    );
  }

  Widget _buildGenderRow(String gender){
    return Row(
      children: [
        _genderItem("Female", gender),
        _genderItem("Male", gender),
        _genderItem("Others", gender),
      ],
    );
  }

  Widget _attributeItem(String value, Color color){
    return Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(value, style: TextStyle(color: Colors.white))
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
    );
  }

  Widget _buildAttributeRow(String value){
    return Row(
      children: [
        Expanded(
          child: _attributeItem(value, Colors.black87),
        )
      ],
    );
  }
  Widget _buildDoubleAttributeRow(String value1, String value2){
    return Row(
      children: [
        Expanded(
          child: _attributeItem(value1, Colors.black87),
        ),
        Expanded(
          child: _attributeItem(value2, Colors.black87),
        )
      ],
    );
  }

  static const hobbyColorList = [
    Colors.amberAccent, Colors.lightBlueAccent, 
    Colors.greenAccent, Colors.cyanAccent, 
    Colors.limeAccent, Colors.orangeAccent];

  Widget _hobbyItem(String hobby, int i){
    return Chip(
      elevation: 3,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      label: Text(hobby, style: TextStyle(fontStyle: FontStyle.italic),),
      backgroundColor: hobbyColorList[i%6],
    );
  }

  Widget _buildHobbyList(List<String> hobbies){
    int i = Random().nextInt(3);
    return Container(
      margin: EdgeInsets.all(5),
      child: Wrap(
        spacing: 5,
        children: hobbies.map((h)=>_hobbyItem(h, i++)).toList(),
      )
    );
  }

  Widget _buildMatchDescription(){
    return ListTile(
      subtitle: Text(matching.matchDescription, style: TextStyle(fontStyle: FontStyle.italic)),
    );
  }

}


