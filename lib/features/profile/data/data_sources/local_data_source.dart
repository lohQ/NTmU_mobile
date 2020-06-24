import 'package:clean_ntmu/core/error/exception.dart';
import 'package:clean_ntmu/features/profile/data/models/preference_model.dart';
import 'package:clean_ntmu/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class ProfileLocalDataSource {
  ProfileModel loadCachedProfile();
  void cacheProfile(ProfileModel profileModel);
  PreferenceModel loadCachedPreference();
  void cachePreference(PreferenceModel preferenceModel);
}

const List<String> PROFILE_KEYS = [
  "id", "fullname", "description", "avatar", "gender", 
  "country_of_origin", "religion", "course_of_study", "hobbies", 
  "year_of_matriculation", "date_of_birth"
];
const List<String> PREF_KEYS = [
  "id", "gender_preference", "country_of_origin_preference", 
  "religion_preference", "course_preference", 
  "age_preference_min", "age_preference_max", 
  "year_of_matriculation_min", "year_of_matriculation_max", 
  "number_of_days_to_receive_a_match", "interested_flag"
];


class ProfileLocalDataSourceImpl extends ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProfileLocalDataSourceImpl({@required this.sharedPreferences});

  void _cacheMap(Map<String,dynamic> json){
    final keys = json.keys;
    for(final key in keys){
      final val = json[key];
      if(val is String){
        sharedPreferences.setString(key, val);
      }else if(val is int){
        sharedPreferences.setInt(key, val);
      }else if(val is bool){
        sharedPreferences.setBool(key, val);
      }else if(val is List<String>){
        sharedPreferences.setStringList(key, val);
      }else if(val is double){
        sharedPreferences.setDouble(key, val);
      }else{
        throw MyStorageException("invalid value type");
      }
    }
  }

  Map<String,dynamic> _loadMap(List<String> keys){
    final resultMap = Map<String,dynamic>();
    for(final key in keys){
      resultMap[key] = sharedPreferences.get(key);
    }
    return resultMap;
  }

  @override
  void cacheProfile(ProfileModel profileModel) {
    final profileJson = profileModel.toJson();
    _cacheMap(profileJson);
  }

  @override
  void cachePreference(PreferenceModel preferenceModel){
    final preferenceJson = preferenceModel.toJson();
    _cacheMap(preferenceJson);
  }

  @override
  ProfileModel loadCachedProfile() {
    final profileJson = _loadMap(PROFILE_KEYS);
    return ProfileModel.fromJson(profileJson);
  }

  @override
  PreferenceModel loadCachedPreference() {
    final preferenceJson = _loadMap(PREF_KEYS);
    return PreferenceModel.fromJson(preferenceJson);
  }

}