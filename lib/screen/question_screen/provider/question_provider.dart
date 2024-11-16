import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_welcome/screen/question_screen/model/question_response_result.dart';
import 'package:flutter_welcome/screen/question_screen/model/summary_response.dart';

import '../../../di/get_it.dart';
import '../../../service/http_service.dart';

class QuestionProvider with ChangeNotifier {
  Future<Question?> onReqQuestion(String sessionId) async {
    try {
      var _response = await HttpService.request(
          method: HttpMethod.get,
          url: '${dotenv.get('BASE_URL')}/api/v1/Quiz/Questions/${sessionId}',
          log: 'post on /api/v1/Quiz/Session');
      var body = jsonDecode(_response.body);
      if (body['data'] != null) {
        var _question = Question.fromJson(body['data']);
        return _question;
      }

      return null;
    } catch (e, s) {
      print(s);
      print(e);
    }
  }

  Future<void> onSubmitQuestion(String sessionId, Choice choice,int timeCounter) async {
    try {
      var _reqBody = {
        "sessionId": sessionId,
        "questionId": choice.questionId,
        "choiceId": choice.choiceId,
        "timeSpent": timeCounter
      };
      var _response = await HttpService.request(
          method: HttpMethod.post,
          url: '${dotenv.get('BASE_URL')}/api/v1/Quiz/Answer',
          body: _reqBody,
          log: 'post on /api/v1/Quiz/Session');
      var body = jsonDecode(_response.body);
      print(body);
      await _showAlertDialog(body['data']['isCorrect']);
    } catch (e, s) {
      print(s);
      print(e);
    }
  }

  Future<SummaryData?> summaryQuestion(String sessionId) async {
    try {
      var _response = await HttpService.request(
          method: HttpMethod.get,
          url: '${dotenv.get('BASE_URL')}/api/v1/Quiz/Summary/${sessionId}',
          log: 'post on /api/v1/Quiz/Session');
      var body = jsonDecode(_response.body);
      print(body);
      var answer = SummaryData.fromJson(body['data']);
      // await _showAlertDialog(body['data']['isCorrect']);
      return answer;
    } catch (e, s) {
      print(s);
      print(e);
    }
  }
}

Future<void> _showAlertDialog(bool ans) async {
  final _navigator = getIt<NavigationService>();
  await showDialog(
    barrierDismissible: false,
    context: _navigator.navigatorKey.currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
            child: Text(
          'Your answer is',
          style: TextStyle(fontSize: 20),
        )),
        content: Text(
          ans ? 'Correct' : 'Incoret',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32,
              fontStyle: FontStyle.italic,
              color: ans ? Colors.green : Colors.red),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              _navigator.navigatorKey.currentState!.pop();
            },
            child: const Text('Next'),
          ),
        ],
      );
    },
  );
}
