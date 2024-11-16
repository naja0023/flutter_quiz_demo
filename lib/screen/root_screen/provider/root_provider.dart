import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_welcome/exception/http_exception.dart';
import 'package:flutter_welcome/screen/question_screen/question_page.dart';
import 'package:flutter_welcome/service/http_service.dart';

import '../../../di/get_it.dart';
import '../root_page.dart';

class RootProvider with ChangeNotifier {
  String get sessionId => _sessionId;
  String get userName => _userName;
  late String _sessionId;
  late String _userName;
  final _navigator = getIt<NavigationService>();
  final storage = FlutterSecureStorage();
  void onStart(String name) async {
    var _response = await HttpService.request(
        method: HttpMethod.post,
        url: '${dotenv.get('BASE_URL')}/api/v1/Quiz/Session',
        log: 'post on /api/v1/Quiz/Session');
    var body = jsonDecode(_response.body);
    _userName = name;
    _sessionId = body['data']['sessionId'];

    var recentUser = {
      "userName": _userName,
      "sessionId": _sessionId,
    };
    await storage.write(key: "recentUser", value: jsonEncode(recentUser));
    _navigator.navigatorKey.currentState!.push(QuestionPage.route());
  }

  void onResume(Map<String, dynamic> recentUser) {
    _userName = recentUser['userName'];
    _sessionId = recentUser['sessionId'];
    _navigator.navigatorKey.currentState!.push(QuestionPage.route());
  }

  void navigateToHome() {
       _navigator.navigatorKey.currentState!.pushAndRemoveUntil(RootPage.route(),(route) => route.isFirst);
  }
}
