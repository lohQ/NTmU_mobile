import 'package:clean_ntmu/features/static_data/data/data_sources/static_data_local_data_source.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/name_with_id.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/question.dart';
import 'package:clean_ntmu/features/static_data/domain/entities/static_data.dart';
import 'package:clean_ntmu/features/static_data/domain/repositories/static_data_repository.dart';
import 'package:meta/meta.dart';

const List<String> CONST_DATA_NAME = 
[
  "genders",
  "countries",
  "religions",
  "courses",
  "hobbies"
];

class StaticDataRepositoryImpl extends StaticDataRepository {

  final StaticDataLocalDataSource localDataSource;
  StaticDataRepositoryImpl({@required this.localDataSource});

  @override
  Future<void> loadDataFromFile() async {
    final StaticData staticData = StaticData();
    for(final dataName in CONST_DATA_NAME){
      final List<NameWithId> dataList = await localDataSource.getNameWithIds("$dataName.json");
      staticData.data[dataName] = dataList ?? List<NameWithId>(0);
    }
    final List<Question> questionList = await localDataSource.getQuestions("questions.json");
    staticData.data["questions"] = questionList ?? List<Question>(0);
  }

}