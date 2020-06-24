import 'package:clean_ntmu/core/util/date_formatter.dart';
import 'package:clean_ntmu/core/util/inputValidator.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'obscurable_textformfield.dart';

class ProfileForm extends StatefulWidget {
  final Map<String,dynamic> data;
  final GlobalKey formKey;
  final List<DropdownMenuItem> genderList;
  final List<DropdownMenuItem> courseList;
  final List<DropdownMenuItem> religionList;
  final List<DropdownMenuItem> countryList;
  final List<DropdownMenuItem> matricYearList;

  ProfileForm(this.formKey, this.data) :
    genderList = StaticData().data["genders"].map(
      (item)=>DropdownMenuItem<int>(value: item.id, child: Text(item.name))).toList(),
    countryList = StaticData().data["countries"].map(
      (item)=>DropdownMenuItem<int>(value: item.id, child: Text(item.name))).toList(),
    religionList = StaticData().data["religions"].map(
      (item)=>DropdownMenuItem<int>(value: item.id, child: Text(item.name))).toList(),
    courseList = StaticData().data["courses"].map(
      (item)=>DropdownMenuItem<int>(value: item.id, child: Text(item.name.trim()))).toList(),
    matricYearList = List.generate(10, 
      (i)=>DropdownMenuItem<int>(value: (DateTime.now().year-i), child: Text("${DateTime.now().year-i}"))).toList();

  @override
  ProfileFormState createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm>{

  final firstDate = DateTime(1980); 
  final lastDate = DateTime(DateTime.now().year);
  final initialDate = DateTime(DateTime.now().year - 20);
  final dobController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();

  @override
  void dispose(){
    passwordController1.dispose();
    passwordController2.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    if(widget.data.containsKey('date_of_birth')){
      dobController.text = widget.data['date_of_birth'];
    }
    if(widget.data.containsKey('password1')){
      passwordController1.text = widget.data['password1'];
    }
    if(widget.data.containsKey('password2')){
      passwordController1.text = widget.data['password2'];
    }
  }

  String password2Validator(String val){
    if(val != passwordController1.text){
      return "Both passwords should be the same";
    }
    return null;
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: widget.data.containsKey('email') ? widget.data['email'] : "",
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "john@e.ntu.edu.sg"
            ),
            validator: InputValidator.validateEmail,
            onSaved: (String val){
              widget.data['email'] = val;
            },
          ),
          TextFormField(
            initialValue: widget.data.containsKey('username') ? widget.data['username'] : "",
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "john"
            ),
            validator: InputValidator.validateNonNull,
            onSaved: (String val){
              widget.data['username'] = val;
            },
          ),
          ObscurableTextFormField(
            controller: passwordController1,
            labelText: "Password",
            hintText: "alphanumeric password with at least 8 characters",
            validator: InputValidator.validatePassword,
            onSaved: (String val){
              widget.data['password1'] = val;
            },
          ),
          ObscurableTextFormField(
            controller: passwordController2,
            labelText: "Retype password",
            hintText: "alphanumeric password with at least 8 characters",
            validator: password2Validator,
            onSaved: (String val){
              widget.data['password2'] = val;
            },
          ),
          TextFormField(
            initialValue: widget.data.containsKey('full_name') ? widget.data['full_name'] : "",
            decoration: InputDecoration(
              labelText: "Fullname",
              hintText: "Johnny"
            ),
            validator: InputValidator.validateNonNull,
            onSaved: (String val){
              widget.data['full_name'] = val;
            },
          ),
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(labelText: "Gender"),
            value: widget.data.containsKey('gender') ? widget.data['gender'] : null,
            items: widget.genderList, 
            validator: InputValidator.validateNonNull,
            onChanged: (int val){
              setState(() {
                widget.data['gender'] = val;
              });
            }),
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(labelText: "Course"),
            value: widget.data.containsKey('course_of_study') ? widget.data['course_of_study'] : null,
            items: widget.courseList, 
            validator: InputValidator.validateNonNull,
            onChanged: (int val){
              setState(() {
                widget.data['course_of_study'] = val;
              });
            }),
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(labelText: "Country"),
            value: widget.data.containsKey('country_of_origin') ? widget.data['country_of_origin'] : null,
            items: widget.countryList, 
            validator: InputValidator.validateNonNull,
            onChanged: (int val){
              setState(() {
                widget.data['country_of_origin'] = val;
              });
            }),
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(labelText: "Religion"),
            value: widget.data.containsKey('religion') ? widget.data['religion'] : null,
            items: widget.religionList, 
            validator: InputValidator.validateNonNull,
            onChanged: (int val){
              setState(() {
                widget.data['religion'] = val;
              });
            }),
          DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(labelText: "Year of matriculation"),
            value: widget.data.containsKey('year_of_matriculation') ? widget.data['year_of_matriculation'] : null,
            items: widget.matricYearList, 
            validator: InputValidator.validateNonNull,
            onChanged: (int val){
              setState(() {
                widget.data['year_of_matriculation'] = val;
              });
            }),
          TextFormField(
            controller: dobController,
            validator: InputValidator.validateNonNull,
            readOnly: true,
            onTap: () async {
              final newDate = await showDatePicker(
                context: context, 
                initialDate: initialDate, 
                firstDate: firstDate, 
                lastDate: lastDate);
              if(newDate != null){
                String newDateString = DateFormatter.formatToYYYYMMDD(newDate);
                widget.data['date_of_birth'] = newDateString;
                setState((){
                  dobController.text = newDateString;
                });
              }},
            decoration: InputDecoration(
              labelText: "Date of birth",
              suffixIcon: Icon(Icons.date_range)
            ),
          ),
          TextFormField(
            initialValue: widget.data.containsKey('description') ? widget.data['description'] : "",
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Describe yourself",
              border: OutlineInputBorder()
            ),
            validator: InputValidator.validateNonNull,
            onSaved: (String val){
              widget.data['description'] = val;
            },
          ),
        ],
      )
   );
  }
}