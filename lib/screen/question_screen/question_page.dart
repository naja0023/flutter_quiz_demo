import 'dart:async';
import 'dart:ffi';

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
  Timer? timer;
  StreamController? timeCounter;
  @override
  Widget build(BuildContext context) {
    _timeConter();
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
            decoration: const BoxDecoration(
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
                  return const Text('error');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data != null) {
                    return Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 8, right: 8, bottom: 8),
                            alignment: Alignment.topRight,
                            child: StreamBuilder(
                                initialData: '0s',
                                stream: timeCounter!.stream,
                                builder: (context, snapshot) {
                                  return Text(snapshot.data!);
                                })),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "QUESTION : ${snapshot.data?.title}",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
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
                                        .onSubmitQuestion(providers.sessionId,
                                            _choice, _cancelTimer())
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
                    _cancelTimer();
                    return Center(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.blueAccent.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "🎉 QUESTION ENDING 🎉",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              FutureBuilder(
                                future: Provider.of<QuestionProvider>(context,
                                        listen: false)
                                    .summaryQuestion(providers.sessionId),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                      '⚠️ Error occurred!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data != null) {
                                      var _summary = snapshot.data!;
                                      return Column(
                                        children: [
                                          const Text(
                                            'Your Score:',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            '${_summary.score} / ${_summary.submittedQuestions}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.yellowAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          _checkScore(_summary.score),
                                          const SizedBox(height: 10),
                                          Visibility(
                                            visible: _summary.timeSpent != null,
                                            child: Text(
                                              'Time Spent : ${formatDuration(_summary.timeSpent!)} minutes',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 40,
                                                vertical: 16,
                                              ),
                                              elevation: 5,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                            },
                                            child: const Text(
                                              'CONTINUE',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const Text(
                                        '⚠️ No data available!',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      }),
    );
  }

  String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _timeConter() {
    timeCounter = StreamController<String>();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print(timer.tick);
      timeCounter!.add("${timer.tick.toString()}s");
    });
  }

  int _cancelTimer() {
    int count = 0;
    timeCounter = null;
    if (timer != null) {
      count = timer!.tick;
      timer!.cancel();
      timer = null;
    }
    return count;
  }

  Text _checkScore(int score) {
    if (score > 0 && score <= 4) {
      return const Text(
        'Result: Fail',
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (score > 4 && score <= 7) {
      return const Text(
        'Result: Pass',
        style: TextStyle(
          fontSize: 18,
          color: Colors.green,
          fontWeight: FontWeight.w500,
        ),
      );
    } else {
      return Text(
        'Result: Excelent!!!!',
        style: TextStyle(
          fontSize: 18,
          color: Colors.orange.shade400,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}
