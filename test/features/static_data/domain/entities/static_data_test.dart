import 'package:clean_ntmu/features/static_data/domain/entities/name_with_id.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  test("should_be_a_singleton", (){
    final staticData1 = StaticData();
    staticData1.data["key1"] = [NameWithId(1,"name1")];
    final staticData2 = StaticData();
    staticData2.data["key2"] = [NameWithId(2,"name2")];
    final isSingleton = staticData1.data.containsKey("key2");
    staticData1.data.clear();
    expect(isSingleton, true);
  });

}