part of 'feedback_bloc.dart';

@immutable
abstract class FeedbackState {
  final List<Answer> answers;
  FeedbackState(this.answers);
}

class FeedbackInitial extends FeedbackState {
  FeedbackInitial() : super(List<Answer>(0));
}

class FeedbackLoading extends FeedbackState {
  FeedbackLoading(List<Answer> answers) : super(answers);
}

class FeedbackError extends FeedbackState {
  final String error;
  FeedbackError(this.error, List<Answer> answers) : super(answers);
}

class FeedbackLoaded extends FeedbackState {
  final List<Answer> answers;
  FeedbackLoaded(this.answers) : super(answers);
}

class FeedbackSubmitted extends FeedbackState {
  FeedbackSubmitted(List<Answer> answers) : super(answers);
}