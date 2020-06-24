import 'package:clean_ntmu/features/profile/domain/entities/answer.dart';
import 'package:clean_ntmu/features/profile/presentation/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:clean_ntmu/features/user_session/presentation/bloc/user_session_bloc/user_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class FeedbackView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (_)=>sl<FeedbackBloc>(),
      child: FeedbackPage()
    );
  }
}

class FeedbackPage extends StatefulWidget{
  @override
  FeedbackPageState createState() => FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage>{

  @override
  void initState(){
    super.initState();
    final userSession = (BlocProvider.of<UserSessionBloc>(context).state as UserSessionLoaded).userSession;
    BlocProvider.of<FeedbackBloc>(context)
      .add(InitFeedbackEvent(userSession));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        actions: <Widget>[
          BlocBuilder(
            bloc: BlocProvider.of<FeedbackBloc>(context),
            builder: (_, FeedbackState state){
              if(state is FeedbackLoading){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                );
              }else{
                return FlatButton(
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                  onPressed: (){
                    BlocProvider.of<FeedbackBloc>(context).add(SubmitFeedbackEvent());
                  },
                );
              }
            },
          )
        ],
      ),
      body: FeedbackWidget()
    );
  }

}

class FeedbackWidget extends StatefulWidget{
  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget>{
  List<Answer> answers = List<Answer>();

  @override
  Widget build(BuildContext context){
    return BlocListener(
        bloc: BlocProvider.of<FeedbackBloc>(context),
        listener: (_, FeedbackState state) async {
          if(state is FeedbackError){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.error),));
          }else if(state is FeedbackLoaded){
            setState(() {
              answers = state.answers;
            });
          }else if(state is FeedbackSubmitted){
            await showDialog(
              context: context, 
              child: AlertDialog(
                title: Text("Feedback Submitted"),
                content: Text("Thanks for your feedback!"),
              )
            );
          }
        },
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          itemCount: answers.length,
          itemBuilder: (context, i) => _buildQuestionTile(i+1, answers[i])
        )
      );
  }

  Widget _buildQuestionTile(int i, Answer answer){
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          title: Text("$i. ${answer.question.name}", style: TextStyle(fontSize: 16))
        ),
        answer.question.answerType == Choice
         ? _buildChoiceField(answer)
         : _buildTextField(answer)
      ],
    );
  }

  Widget _buildChoiceField(Answer answer){
    return Column(
      children: <Widget>[
        ListTile(
          dense: true,
          title: Text("Strongly agree"),
          leading: Radio<Choice>(
            value: Choice.strongly_agree,
            groupValue: answer.answer,
            onChanged: (Choice choice){
              setState(() {
                answer.answer = choice;                
              });
            },
          )),
        ListTile(
          dense: true,
          title: Text("Agree"),
          leading: Radio<Choice>(
            value: Choice.agree,
            groupValue: answer.answer,
            onChanged: (Choice choice){
              setState(() {
                answer.answer = choice;                
              });
            },
          )),
        ListTile(
          dense: true,
          title: Text("Neutral"),
          leading: Radio<Choice>(
            value: Choice.neutral,
            groupValue: answer.answer,
            onChanged: (Choice choice){
              setState(() {
                answer.answer = choice;                
              });
            },
          )),
        ListTile(
          dense: true,
          title: Text("Disagree"),
          leading: Radio<Choice>(
            value: Choice.disagree,
            groupValue: answer.answer,
            onChanged: (Choice choice){
              setState(() {
                answer.answer = choice;                
              });
            },
          )),
        ListTile(
          dense: true,
          title: Text("Strongly disagree"),
          leading: Radio<Choice>(
            value: Choice.strongly_disagree,
            groupValue: answer.answer,
            onChanged: (Choice choice){
              setState(() {
                answer.answer = choice;                
              });
            },
          )),
      ],
    );
  }

  Widget _buildTextField(Answer answer){
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder()
      ),
      onSubmitted: (String value){
        answer.answer = value;
      },
    );
  }



}