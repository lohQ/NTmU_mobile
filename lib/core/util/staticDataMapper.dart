import 'package:clean_ntmu/features/static_data/data/repositories/server_data_repostiory_impl.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';

class StaticDataMapper {

  static final data = StaticData.instance.data;

  static String nameFromId(String dataName, int id){
    if(!CONST_DATA_NAME.contains(dataName)){
      throw FormatException("invalid data name");
    }
    return data[dataName].firstWhere((item)=>item.id == id).name;
  }
  static int idFromName(String dataName, String name){
    if(!CONST_DATA_NAME.contains(dataName)){
      throw FormatException("invalid data name");
    }
    return data[dataName].firstWhere((item)=>item.name == name).id;
  }

}