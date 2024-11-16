import 'package:flutter/material.dart';
import 'package:flutter_welcome/screen/question_screen/provider/question_provider.dart';
import 'package:flutter_welcome/screen/root_screen/provider/root_provider.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatefulWidget {
  static PageRoute route() {
    return MaterialPageRoute(builder: (context) => QuestionPage());
  }

  QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child:
          Consumer(builder: (BuildContext context, RootProvider providers, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'QUIZ ISLAND',
            ),
          ),
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: FutureBuilder(
                future: Provider.of<QuestionProvider>(context, listen: false)
                    .onReqQuestion(providers.sessionId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null) {
                      return Column(
                        children: [
                          Text("QUESTION : ${snapshot.data?.title}"),
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.choices.length,
                                itemBuilder: (context, index) {
                                  final _choice = snapshot.data!.choices[index];
                                  return TextButton(
                                      onPressed: () {
                                        Provider.of<QuestionProvider>(context,
                                                listen: false)
                                            .onSubmitQuestion(
                                                providers.sessionId, _choice)
                                            .then((_) {
                                          setState(() {});
                                        });
                                      },
                                      child: Text('${_choice.title}'));
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Text("QUESTION ENDING"),
                          FutureBuilder(
                              future: Provider.of<QuestionProvider>(context,
                                      listen: false)
                                  .summaryQuestion(providers.sessionId),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('error');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.data != null) {
                                    var _summary = snapshot.data!;
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Score is'),
                                        Text(
                                            '${_summary.score} / ${_summary.submittedQuestions}'),
                                        Text(
                                            'Result : ${_checkScore(_summary.score)}'),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).popUntil(
                                                  (route) => route.isFirst,
                                                ),
                                            child: Text('CONTINUE'))
                                      ],
                                    );
                                  } else {
                                    return Text('error');
                                  }
                                } else {
                                  return Center(child: CircularProgressIndicator());
                                }
                              })
                        ],
                      );
                    }
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                }),
          ),
        );
      }),
    );
  }

  String _checkScore(int score) {
    if (score > 0 && score <= 4) {
      return 'Fail';
    } else if (score > 4 && score <= 7) {
      return 'Pass';
    } else {
      return 'Excellent';
    }
  }
}
