part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackEvent {}

class InitFeedbackEvent extends FeedbackEvent {
  final UserSession userSession;
  InitFeedbackEvent(this.userSession);
}

class SubmitFeedbackEvent extends FeedbackEvent {
  SubmitFeedbackEvent();
}

