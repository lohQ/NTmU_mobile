
import 'dart:io';

import 'package:clean_ntmu/core/util/date_formatter.dart';
import 'package:clean_ntmu/features/profile/domain/entities/profile.dart';
import 'package:clean_ntmu/features/profile/presentation/blocs/profile_bloc/profile_bloc.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditWidget extends StatefulWidget {
  final List<DropdownMenuItem> genderList; 
  final List<DropdownMenuItem> countryList;
  final List<DropdownMenuItem> religionList; 
  final List<DropdownMenuItem> courseList;
  final List<DropdownMenuItem> hobbyList; 
  final List<DropdownMenuItem> matricYearList;

  ProfileEditWidget() : 
    genderList = StaticData().data["genders"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    countryList = StaticData().data["countries"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    religionList = StaticData().data["religions"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    courseList = StaticData().data["courses"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    hobbyList = StaticData().data["hobbies"].map(
      (item)=>DropdownMenuItem<String>(value: item.name, child: Text(item.name))).toList(),
    matricYearList = List.generate(10, 
      (i)=>DropdownMenuItem<int>(value: (DateTime.now().year-i), child: Text("${DateTime.now().year-i}"))).toList();

  @override 
  ProfileEditWidgetState createState() => ProfileEditWidgetState();

}



class ProfileEditWidgetState extends State<ProfileEditWidget>{
  ProfileBloc bloc;

  TextEditingController nameController; TextEditingController descContorller; 
  TextEditingController dobController; ImagePicker picker;
  String gender; String country; String religion; String course; String curHobby; int matricYear;
  List<String> hobbies; DateTime dateOfBirth; PickedFile avatarFile;
  DateTime initialDate; 
  final firstDate = DateTime(1980); final lastDate = DateTime(DateTime.now().year);

  final Map<String,dynamic> dataToUpdate = {};

  @override
  void initState(){
    super.initState();
    bloc = BlocProvider.of<ProfileBloc>(context);
    _updateProfileData(bloc.state.profile);
    _initControllers(bloc.state.profile);
  }

  void _updateProfileData(Profile profile){
    dateOfBirth = profile.dateOfBirth;
    initialDate = dateOfBirth;
    gender = profile.gender;
    country = profile.country;
    religion = profile.religion;
    // print("profile.course: ${profile.course}");
    // final tempCourse =StaticData().data['courses'].firstWhere((c)=>c.id == 260).name;
    // print("tempCourse: $tempCourse");
    // print("profile.course == tempCourse: ${profile.course == tempCourse}");
    course = profile.course;
    hobbies = List.from(profile.hobbies);
    matricYear = profile.matricYear;
  }

  void _initControllers(Profile profile){
    nameController = TextEditingController(text: profile.fullname);
    descContorller = TextEditingController(text: profile.description);
    dobController = TextEditingController();
    dobController.text = DateFormatter.formatToYYYYMMDD(dateOfBirth);
    picker = ImagePicker();
  }

  Widget _buildSaveButton(){
    return BlocBuilder(
      bloc: bloc,
      builder: (context, ProfileState state){
        if(state is ProfileLoading){
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
          );
        }
        return FlatButton(
          child: Text("Save", style: TextStyle(color: Colors.white)),
          onPressed: (){
            _saveChangedData(bloc.state.profile);
            if(dataToUpdate.length == 0){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("No changes to save")));
              return;
            }
            bloc.add(UpdateProfileEvent(dataToUpdate));              
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context){
    return 
    Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
          _buildSaveButton()
        ]),
      body: BlocListener(
        bloc: bloc,
        listener: (context, ProfileState state) async {
          if(state is ProfileError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
          if(state is ProfileUpdated){
            dataToUpdate.clear();
            setState(() {
              _updateProfileData(state.profile);
              avatarFile = null; 
            });
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
            Stack(
              children: <Widget>[
              GestureDetector(
                child: 
                BlocBuilder(
                  bloc: bloc,
                  builder: (context, ProfileState state){
                    final image = (avatarFile == null)
                    ? NetworkImage(state.profile.photoUrl)
                    : FileImage(File(avatarFile.path));
                    return Container(
                      height: MediaQuery.of(context).size.height/2,
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black12,
                        image: DecorationImage(image: image, fit: BoxFit.fitHeight)
                      ),
                    );
                  },
                ),
                onTap: () async {
                  final newImage = await picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    avatarFile = newImage;
                  });}
                ),
                Positioned(
                  right: 10, bottom: 10,
                  child: RaisedButton(
                    child: Text("Reset"),
                    onPressed: (){
                      setState(() {
                        avatarFile = null; 
                      });
                    },
                  )
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Fullname",
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: descContorller,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                maxLines: null,
              ),
            ),
            TextField(
              controller: dobController,
              readOnly: true,
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context, 
                  initialDate: initialDate, 
                  firstDate: firstDate, 
                  lastDate: lastDate);
                if(newDate != null && newDate != dateOfBirth){
                  dateOfBirth = newDate;
                  setState((){
                    dobController.text = DateFormatter.formatToYYYYMMDD(dateOfBirth);
                  });
                }},
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.date_range)
              ),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: gender,
              items: widget.genderList,
              onChanged: (String newValue){
                setState((){
                  gender = newValue;
                });
              },
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: country,
              items: widget.countryList,
              onChanged: (String newValue){
                setState((){
                  country = newValue;
                });
              },
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: religion,
              items: widget.religionList,
              onChanged: (String newValue){
                setState((){
                  religion = newValue;
                });
              },
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: course,
              items: widget.courseList,
              onChanged: (String newValue){
                setState((){
                  course = newValue;
                });
              },
            ),
            DropdownButton<int>(
              isExpanded: true,
              value: matricYear,
              items: widget.matricYearList,
              onChanged: (int newValue){
                setState((){
                  matricYear = newValue;
                });
              },
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: curHobby,
                      items: widget.hobbyList,
                      hint: Text("Add hobby"),
                      onChanged: (String newValue){
                        setState((){
                          curHobby = newValue;
                        });},
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      if(!hobbies.contains(curHobby)){
                        setState((){
                          hobbies.add(curHobby);
                          curHobby = null;
                        });
                      }},
                  )],
              ),
            ),
            Wrap(
              spacing: 5,
              children: List.from(hobbies).map(
                (h)=>Chip(
                  label: Text(h),
                  labelPadding: EdgeInsets.all(5),
                  onDeleted: (){
                    setState((){
                      hobbies.remove(h);
                    });
                  })).toList()
            )
          ]
        )
      )
    );
  }

  void _saveChangedData(Profile profile){
    if(nameController.text != profile.fullname){
      dataToUpdate["fullname"] = nameController.text;
    }
    if(descContorller.text != profile.description){
      dataToUpdate["description"] = descContorller.text;
    }
    if(gender != profile.gender){
      dataToUpdate["gender"] = gender;
    }
    if(country != profile.country){
      dataToUpdate["country_of_origin"] = country;
    }
    if(religion != profile.religion){
      dataToUpdate["religion"] = religion;
    }
    if(course != profile.course){
      dataToUpdate["course_of_study"] = course;
    }
    if(matricYear != profile.matricYear){
      dataToUpdate["year_of_matriculation"] = matricYear;
    }
    if(dateOfBirth != profile.dateOfBirth){
      dataToUpdate["date_of_birth"] = DateFormatter.formatToYYYYMMDD(dateOfBirth);
    }
    if(avatarFile != null){
      dataToUpdate["avatar"] = avatarFile.path;
    }
    if(!listEquals(hobbies, profile.hobbies)){
      dataToUpdate["hobbies"] = hobbies;
    }
  }

  @override
  void dispose() {
    dobController.dispose();
    descContorller.dispose();
    nameController.dispose();
    bloc.close();
    super.dispose();
  }

}
