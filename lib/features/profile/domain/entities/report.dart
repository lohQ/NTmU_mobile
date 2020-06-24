import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Report extends Equatable{
  final int reporterId;
  final int reporteeId;
  final String category;
  final String description;
  final DateTime timestamp;
  final bool reviewed;
  final String reviewedBy;
  final String actionTaken;

  Report({
    @required this.reporterId, 
    @required this.reporteeId, 
    @required this.category, 
    @required this.description, 
    @required this.timestamp, 
    this.reviewed = false, 
    this.reviewedBy,
    this.actionTaken});

  @override
  List<Object> get props => [
    reporterId, reporteeId, timestamp, 
    category, description, 
    reviewed, reviewedBy, actionTaken];
}