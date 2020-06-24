import 'package:clean_ntmu/core/constants/network_constants.dart';

import '../../domain/entities/profile.dart';
import 'package:meta/meta.dart';

class ProfileModel extends Profile {
  ProfileModel({
    @required int id,
    @required String fullname, 
    @required String description, 
    @required String photoUrl, 
    @required String gender, 
    @required String country, 
    @required String religion, 
    @required String course, 
    @required List<String> hobbies, 
    @required int matricYear, 
    @required DateTime dateOfBirth
  }) : super(
    id: id, fullname: fullname, description: description, photoUrl: photoUrl, 
    gender: gender, country: country, religion: religion, course: course, hobbies: hobbies, 
    matricYear: matricYear, dateOfBirth: dateOfBirth
  );

  factory ProfileModel.fromJson(Map<String,dynamic> json){
    return ProfileModel(
      id: json["id"],
      fullname: json["fullname"],
      description: json["description"],
      photoUrl: "$BASE_MEDIA_URL${json["avatar"]}",
      gender: json["gender"],
      country: json["country_of_origin"],
      religion: json["religion"],
      course: json["course_of_study"],
      hobbies: json["hobbies"].cast<String>(),
      matricYear: json["year_of_matriculation"],
      dateOfBirth: DateTime.parse(json["date_of_birth"])
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id, 
      "fullname": fullname, 
      "description": description, 
      "avatar": photoUrl.substring(BASE_MEDIA_URL.length), 
      "gender": gender, 
      "country_of_origin": country, 
      "religion": religion, 
      "course_of_study": course, 
      "hobbies": hobbies,
      "year_of_matriculation": matricYear, 
      "date_of_birth": dateOfBirth.toString(),
    };
  }

}