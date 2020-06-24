import 'dart:convert';

import 'package:clean_ntmu/features/profile/data/models/report_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){

  final reportJson = json.decode(fixture("report_fixture.json"));
  final reportModel = ReportModel(
    id: 31, 
    reporterId: 316,
    reporteeId: 306,
    category: "Others",
    description: "I think you should ask him to get a better photo.", 
    timestamp: DateTime.parse("2019-10-21T15:49:06.087988+08:00"),
    reviewed: true,
    reviewedBy: "admin", 
    actionTaken: "i have sent him an email regarding that request.", 
  );

  test("should_convert_to_and_from_json_successfully", (){
    final model = ReportModel.fromJson(reportJson);
    expect(model, reportModel);
    final json = model.toJson();
    // datetime format would be different 
    json.remove('timestamp');
    reportJson.remove('timestamp');
    expect(json, reportJson);
  });

}