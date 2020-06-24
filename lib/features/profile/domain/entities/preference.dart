import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Preference extends Equatable{
  final int id;
  final List<String> genderPref;
  final List<String> countryPref;
  final List<String> religionPref;
  final List<String> coursePref;
  final int agePrefMin;
  final int agePrefMax;
  final int matricYearPrefMin;
  final int matricYearPrefMax;
  final int daysToMatch;
  final bool interestedFlag;

  Preference({
    @required this.id,
    @required this.genderPref, 
    @required this.countryPref, 
    @required this.religionPref, 
    @required this.coursePref, 
    @required this.agePrefMin, 
    @required this.agePrefMax, 
    @required this.matricYearPrefMin, 
    @required this.matricYearPrefMax, 
    @required this.daysToMatch, 
    @required this.interestedFlag});

  @override
  List<Object> get props => [
    id, genderPref, countryPref, religionPref, coursePref, 
    agePrefMin, agePrefMax, matricYearPrefMin , matricYearPrefMax, 
    daysToMatch, interestedFlag
  ];

}