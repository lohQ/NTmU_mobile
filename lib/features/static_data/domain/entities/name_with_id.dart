
import 'package:equatable/equatable.dart';

class NameWithId extends Equatable{
  final int id;
  final String name;
  NameWithId(this.id, this.name);

  @override
  List<Object> get props => [id,name];
}
