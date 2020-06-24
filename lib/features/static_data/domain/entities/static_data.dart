import 'package:equatable/equatable.dart';

import 'name_with_id.dart';

class StaticData extends Equatable{

  final Map<String,List<NameWithId>> data;

  static StaticData instance = StaticData._internal();
  StaticData._internal()
    : data = Map<String,List<NameWithId>>();

  factory StaticData({Map<String,List<NameWithId>> data}){
    if(data != null){
      instance.data.addAll(data);
    }
    return instance;
  }

  @override
  List<Object> get props => [data];

}

