import 'package:clean_ntmu/core/constants/network_constants.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';

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
      gender: StaticData.mapIdToName("genders", json["gender"]),
      country: StaticData.mapIdToName("countries", json["country_of_origin"]),
      religion: StaticData.mapIdToName("religions", json["religion"]),
      course: StaticData.mapIdToName("courses", json["course_of_study"]),
      hobbies: StaticData.mapIdsToNames("hobbies", json["hobbies"].cast<int>()),
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
      "gender": StaticData.mapNameToId("genders", gender), 
      "country_of_origin": StaticData.mapNameToId("countries", country), 
      "religion": StaticData.mapNameToId("religions", religion), 
      "course_of_study": StaticData.mapNameToId("courses", course), 
      "hobbies": StaticData.mapNamesToIds("hobbies", hobbies),
      "year_of_matriculation": matricYear, 
      "date_of_birth": dateOfBirth.toString(),
    };
  }

  String toString(){
    return toJson().toString();
  }

}