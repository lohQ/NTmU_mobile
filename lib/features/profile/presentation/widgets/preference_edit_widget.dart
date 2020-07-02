
import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:clean_ntmu/features/profile/presentation/blocs/preference_bloc/preference_bloc.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferenceEditWidget extends StatefulWidget{

  final List<DropdownMenuItem> genderList;
  final List<DropdownMenuItem> countryList;
  final List<DropdownMenuItem> religionList;
  final List<DropdownMenuItem> courseList;
  final List<DropdownMenuItem> matricYearList;
  final List<DropdownMenuItem> ageList;

  PreferenceEditWidget() : 
    genderList = StaticData().data["genders"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    countryList = StaticData().data["countries"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    religionList = StaticData().data["religions"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    courseList = StaticData().data["courses"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    matricYearList = List.generate(12, 
      (i)=>DropdownMenuItem<int>(value: (DateTime.now().year-i), child: Text("${DateTime.now().year-i}"))).toList(),
    ageList = List.generate(DEFAULT_AGE_MAX - DEFAULT_AGE_MIN + 1,
      (i)=>DropdownMenuItem<int>(value: (DEFAULT_AGE_MIN+i), child: Text("${DEFAULT_AGE_MIN+i}"))).toList();

  @override
  PreferenceEditWidgetState createState() => PreferenceEditWidgetState();
}

class PreferenceEditWidgetState extends State<PreferenceEditWidget>{

  PreferenceBloc bloc;

  List<String> genderPref; String curGender;
  List<String> countryPref; String curCountry;
  List<String> religionPref; String curReligion;
  List<String> coursePref; String curCourse;
  int agePrefMin; int agePrefMax;
  int matricYearPrefMin; int matricYearPrefMax;

  final dataToUpdate = Map<String,dynamic>();

  @override
  void initState(){
    super.initState(); 
    bloc = BlocProvider.of<PreferenceBloc>(context);
    _updatePreference(bloc.state.preference);
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void _updatePreference(Preference pref){
    genderPref = pref.genderPref.toList();
    countryPref = pref.countryPref.toList();
    religionPref = pref.religionPref.toList();
    coursePref = pref.coursePref.toList();
    agePrefMin = pref.agePrefMin;
    agePrefMax = pref.agePrefMax;
    matricYearPrefMin = pref.matricYearPrefMin;
    matricYearPrefMax = pref.matricYearPrefMax;
  }

  void _saveChangedData(Preference pref){
    if(!listEquals(genderPref, pref.genderPref)){
      dataToUpdate["gender_preference"] = StaticData.mapNamesToIds("genders", genderPref);
    }
    if(!listEquals(countryPref, pref.countryPref)){
      dataToUpdate["country_of_origin_preference"] = StaticData.mapNamesToIds("countries", countryPref);
    }
    if(!listEquals(religionPref, pref.religionPref)){
      dataToUpdate["religion_preference"] = StaticData.mapNamesToIds("religions", religionPref);
    }
    if(!listEquals(coursePref, pref.coursePref)){
      dataToUpdate["course_preference"] = StaticData.mapNamesToIds("courses", coursePref);
    }
    if(agePrefMin != pref.agePrefMin || agePrefMax != pref.agePrefMax){
      dataToUpdate["age_preference_min"] = agePrefMin;
      dataToUpdate["age_preference_max"] = agePrefMax;
    }
    if(matricYearPrefMin != pref.matricYearPrefMin || matricYearPrefMax != pref.matricYearPrefMax){
      dataToUpdate["year_of_matriculation_min"] = matricYearPrefMin;
      dataToUpdate["year_of_matriculation_max"] = matricYearPrefMax;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Preference"),
        actions: <Widget>[
          BlocBuilder(
            bloc: bloc,
            builder: (context, PreferenceState state){
              if(state is PreferenceLoading){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                );
              }
              return FlatButton(
                child: Text("Save", style: TextStyle(color: Colors.white)),
                onPressed: (){
                  _saveChangedData(bloc.state.preference);
                  if(dataToUpdate.length == 0){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("No changes to save")));
                    return;
                  }
                  bloc.add(UpdatePreferenceEvent(dataToUpdate));              
                },
              );
            },
          )
        ]),
      body: BlocListener(
        bloc: bloc,
        listener: (context, PreferenceState state) async {
          if(state is PreferenceError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error),));
          }
          if(state is PreferenceUpdated){
            // _updatePreference(state.preference);
            dataToUpdate.clear();
            // await showDialog(
            //   context: context,
            //   child: AlertDialog(
            //     content: Text("Changes saved"),
            //   )
            // );
          }
        },
        child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: curGender,
                        items: widget.genderList,
                        hint: Text("Add gender preference"),
                        onChanged: (String newValue){
                          setState((){
                            curGender = newValue;
                          });},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
                        if(!genderPref.contains(curGender)){
                          setState((){
                            genderPref.add(curGender);
                            curGender = null;
                          });
                        }},
                    )],
                ),
              ),
              _buildChipList(genderPref),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: curCountry,
                        items: widget.countryList,
                        hint: Text("Add country preference"),
                        onChanged: (String newValue){
                          setState((){
                            curCountry = newValue;
                          });},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
                        if(!countryPref.contains(curCountry)){
                          setState((){
                            countryPref.add(curCountry);
                            curCountry = null;
                          });
                        }},
                    )],
                ),
              ),
              _buildChipList(countryPref),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: curReligion,
                        items: widget.religionList,
                        hint: Text("Add religion preference"),
                        onChanged: (String newValue){
                          setState((){
                            curReligion = newValue;
                          });},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
                        if(!religionPref.contains(curReligion)){
                          setState((){
                            religionPref.add(curReligion);
                            curReligion = null;
                          });
                        }},
                    )],
                ),
              ),
              _buildChipList(religionPref),
              Container(
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: 
                      DropdownButton<String>(
                        isExpanded: true,
                        value: curCourse,
                        items: widget.courseList,
                        hint: Text("Add course preference"),
                        onChanged: (String newValue){
                          setState((){
                            curCourse = newValue;
                          });},
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){
                        if(!coursePref.contains(curCourse)){
                          setState((){
                            coursePref.add(curCourse);
                            curCourse = null;
                          });
                        }},
                    )],
                ),
              ),
              _buildChipList(coursePref),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(height: 10),
                    Text("Preferred age range"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton<int>(
                          value: agePrefMin,
                          items: widget.ageList,
                          onChanged: (int newValue){
                            setState(() {
                              agePrefMin = newValue;
                            });
                          },
                        ),
                        DropdownButton<int>(
                          value: agePrefMax,
                          items: widget.ageList,
                          onChanged: (int newValue){
                            setState(() {
                              agePrefMax = newValue;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                )
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(height: 10),
                    Text("Preferred matric year range"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DropdownButton<int>(
                          value: matricYearPrefMin,
                          items: widget.matricYearList,
                          onChanged: (int newValue){
                            setState(() {
                              matricYearPrefMin = newValue;
                            });
                          },
                        ),
                        DropdownButton<int>(
                          value: matricYearPrefMax,
                          items: widget.matricYearList,
                          onChanged: (int newValue){
                            setState(() {
                              matricYearPrefMax = newValue;
                            });
                          },
                        )
                      ],
                    )
                  ],
                )
              ),
            ],
          )
      )
    );
  }

  Widget _buildChipList(List<dynamic> chipList){
    return Wrap(
      spacing: 5,
      children: List.from(chipList).map(
        (h)=>Chip(
          label: Text(h),
          labelPadding: EdgeInsets.all(5),
          onDeleted: (){
            setState((){
              chipList.remove(h);
            });
          })).toList()
    );
  }

}