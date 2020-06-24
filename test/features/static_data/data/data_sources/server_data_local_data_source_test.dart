// import 'package:clean_ntmu/features/static_data/data/data_sources/static_data_local_data_source.dart';
// import 'package:clean_ntmu/features/static_data/data/models/name_with_id_model.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main(){

//   StaticDataLocalDataSource localDataSource;

//   setUp((){
//     localDataSource = StaticDataLocalDataSource();
//   });

//   test("should_return_List<StaticDataModel>_if_success", () async {
//     final expectedResult = [
//       NameWithIdModel(id: 2, name: "Female"),
//       NameWithIdModel(id: 1, name: "Male"),
//       NameWithIdModel(id: 3, name: "Others"),
//     ];
//     final result = await localDataSource.getStaticData("genders.json");
//     expect(result, expectedResult);
//   });

//   test("should_return_null_if_file_not_found", () async {
//     final result = await localDataSource.getStaticData("gender.json");
//     expect(result, null);
//   });

// }