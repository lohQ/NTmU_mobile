import 'package:clean_ntmu/features/profile/domain/entities/preference.dart';
import 'package:meta/meta.dart';

const int DEFAULT_AGE_MIN = 18;
const int DEFAULT_AGE_MAX = 49;

class PreferenceModel extends Preference {
  PreferenceModel({
    @required int id,
    @required List<String> genderPref,
    @required List<String> countryPref,
    @required List<String> religionPref,
    @required List<String> coursePref,
    @required int agePrefMin, @required int agePrefMax,
    @required int matricYearPrefMin, @required int matricYearPrefMax,
    @required int daysToMatch, @required bool interestedFlag
  }) : super(
    id: id, genderPref: genderPref, countryPref: countryPref, 
    religionPref: religionPref, coursePref: coursePref,
    agePrefMin: agePrefMin, agePrefMax: agePrefMax, 
    matricYearPrefMin: matricYearPrefMin, matricYearPrefMax: matricYearPrefMax,
    daysToMatch: daysToMatch, interestedFlag: interestedFlag
  );

  factory PreferenceModel.fromJson(Map<String,dynamic> json){
    final ageMin = json["age_preference_min"] == -1 ? DEFAULT_AGE_MIN : json["age_preference_min"];
    final ageMax = json["age_preference_max"] == -1 ? DEFAULT_AGE_MAX : json["age_preference_max"];
    return PreferenceModel(
      id: json["id"],
      genderPref: json["gender_preference"].cast<String>(),
      countryPref: json["country_of_origin_preference"].cast<String>(),
      religionPref: json["religion_preference"].cast<String>(),
      coursePref: json["course_preference"].cast<String>(),
      agePrefMin: ageMin,
      agePrefMax: ageMax,
      matricYearPrefMin: json["year_of_matriculation_min"],
      matricYearPrefMax: json["year_of_matriculation_max"],
      daysToMatch: json["number_of_days_to_receive_a_match"],
      interestedFlag: json["interested_flag"]
    );
  }  

  Map<String,dynamic> toJson(){
    return {
      "id": id, 
      "gender_preference": genderPref, 
      "country_of_origin_preference": countryPref, 
      "religion_preference": religionPref, 
      "course_preference": coursePref, 
      "age_preference_min": agePrefMin, 
      "age_preference_max": agePrefMax, 
      "year_of_matriculation_min": matricYearPrefMin, 
      "year_of_matriculation_max": matricYearPrefMax,
      "number_of_days_to_receive_a_match": daysToMatch, 
      "interested_flag": interestedFlag
    };
  }


}