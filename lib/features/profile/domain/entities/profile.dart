import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Profile extends Equatable{
  final int id;
  final String fullname;
  final String description;
  final String photoUrl;
  final String gender;
  final String country;
  final String religion;
  final String course;
  final List<String> hobbies;
  final int matricYear;
  final DateTime dateOfBirth;

  Profile({
    @required this.id, 
    @required this.fullname, 
    @required this.description, 
    @required this.photoUrl, 
    @required this.gender, 
    @required this.country, 
    @required this.religion, 
    @required this.course, 
    @required this.hobbies, 
    @required this.matricYear, 
    @required this.dateOfBirth});

  @override
  List<Object> get props => [
    id, fullname, description, photoUrl, 
    gender, country, religion, course, hobbies, 
    matricYear, dateOfBirth];

}