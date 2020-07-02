import 'name_with_id.dart';

class StaticData{

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

  static String mapIdToName(String keyName, int id){
    return instance.data[keyName].firstWhere((item) => item.id == id).name;
  }

  static int mapNameToId(String keyName, String name){
    return instance.data[keyName].firstWhere((item) => item.name == name).id;
  }

  static List<String> mapIdsToNames(String keyName, Iterable<int> ids){
    return instance.data[keyName]
      .where((item) => ids.contains(item.id))
      .map((item)=>item.name).toList();
  }

  static List<int> mapNamesToIds(String keyName, Iterable<String> names){
    return instance.data[keyName]
      .where((item) => names.contains(item.name))
      .map((item)=>item.id).toList();
  }
}

