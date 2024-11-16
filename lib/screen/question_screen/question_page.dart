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
            backgroundColor: Colors.deepPurple,
            title: const Text(
              'QUIZ ISLAND',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 8),
                          child: Text(
                            "QUESTION : ${snapshot.data?.title}",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.choices.length,
                            itemBuilder: (context, index) {
                              final _choice = snapshot.data!.choices[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.grey.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    elevation: 4,
                                  ),
                                  onPressed: () {
                                    Provider.of<QuestionProvider>(context,
                                            listen: false)
                                        .onSubmitQuestion(
                                            providers.sessionId, _choice)
                                        .then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text(
                                    '${_choice.title}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "QUESTION ENDING",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 20),
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
                                  children: [
                                    Text('Score is',
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                      '${_summary.score} / ${_summary.submittedQuestions}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    Text(
                                      'Result : ${_checkScore(_summary.score)}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        minimumSize: const Size(200, 50),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      },
                                      child: const Text(
                                        'CONTINUE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('error',
                                    style: TextStyle(color: Colors.white));
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    );
                  }
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
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
