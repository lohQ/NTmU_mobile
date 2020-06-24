import 'package:clean_ntmu/features/static_data/domain/entities/name_with_id.dart';
import 'package:meta/meta.dart';

class NameWithIdModel extends NameWithId{

  NameWithIdModel({
    @required int id, 
    @required String name
  }) : super(id, name);

  factory NameWithIdModel.fromJson(Map<String, dynamic> json){
    return NameWithIdModel(
      id: json["id"],
      name: json["name"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "name": name
    };
  }

}
