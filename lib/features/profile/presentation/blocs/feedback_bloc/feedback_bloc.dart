import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_ntmu/core/util/internetConnectionChecker.dart';
import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/submit_feedback.dart';
import 'package:clean_ntmu/features/profile/domain/usecases/view_feedback.dart';
import 'package:clean_ntmu/features/user_session/domain/entities/user_session.dart';
import 'package:meta/meta.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {

  final SubmitFeedback submitFeedback;
  final ViewFeedback viewFeedback;
  UserSession userSession;
  final InternetConnectionChecker connectionChecker;

  FeedbackBloc({@required this.submitFeedback, @required this.viewFeedback, @required this.connectionChecker});

  Stream<FeedbackState> getFeedback() async* {
    yield FeedbackLoading(state.answers);
    final answersEither = await viewFeedback(userSession);
    yield* answersEither.fold(
      (failure) async* {
        yield FeedbackError(failure.message, state.answers);
      },
      (answers) async* {
        yield FeedbackLoaded(answers);
      }
    );
  }


  @override
  FeedbackState get initialState => FeedbackInitial();

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {

    if(event is InitFeedbackEvent){
      userSession = event.userSession;
      if(await connectionChecker.isConnected()){
        yield* getFeedback();
      }else{
        yield FeedbackError("No connection", state.answers);
      }      

    }else if(event is SubmitFeedbackEvent){
      if(await connectionChecker.isConnected()){
        yield FeedbackLoading(state.answers);
        final params = SubmitFeedbackParams(userSession, state.answers);
        final either = await submitFeedback(params);
        yield* either.fold(
          (failure) async* {
            yield FeedbackError(failure.message, state.answers);
          },
          (_) async* {
            yield FeedbackSubmitted(state.answers);
          }
        );
      }else{
        yield FeedbackError("No connection", state.answers);
      }
    }
  }
}
