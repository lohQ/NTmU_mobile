import 'package:clean_ntmu/features/profile/domain/entities/report.dart';
import 'package:meta/meta.dart';

class ReportModel extends Report {
  final int id;
  ReportModel({
    this.id,
    @required int reporterId, 
    @required int reporteeId, 
    @required String category, 
    @required String description, 
    @required DateTime timestamp, 
    @required bool reviewed, 
    @required String reviewedBy, 
    @required String actionTaken 
  }) : super(
    reporterId: reporterId, 
    reporteeId: reporteeId,
    category: category, 
    description: description, 
    timestamp: timestamp, 
    reviewed: reviewed, 
    reviewedBy: reviewedBy,
    actionTaken: actionTaken
  );

  factory ReportModel.fromJson(Map<String,dynamic> json){
    return ReportModel(
      id: json["id"],
      reporterId: json["reporter"],
      reporteeId: json["reportee"],
      category: json["category"],
      description: json["description"],
      timestamp: DateTime.parse(json["timestamp"]),
      reviewed: json["reviewed"],
      reviewedBy: json["reviewedby"],
      actionTaken: json["actiontaken"]
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "reporter": reporterId,
      "reportee": reporteeId,
      "category": category,
      "description": description, 
      "timestamp": timestamp.toString(), 
      "reviewed": reviewed,
      "reviewedby": reviewedBy,
      "actiontaken": actionTaken
    };
  }

}