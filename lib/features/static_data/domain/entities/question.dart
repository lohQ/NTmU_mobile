import 'package:clean_ntmu/features/static_data/domain/entities/name_with_id.dart';
import 'package:meta/meta.dart';

class Question extends NameWithId {
  final Type answerType;
  Question({
    @required int id, 
    @required String name, 
    this.answerType}) : super(id, name);

}