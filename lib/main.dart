import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_welcome/di/get_it.dart';
import 'package:flutter_welcome/screen/question_screen/bloc/question_bloc.dart';
import 'package:flutter_welcome/screen/question_screen/provider/question_provider.dart';
import 'package:flutter_welcome/screen/root_screen/provider/root_provider.dart';
import 'package:provider/provider.dart';

import 'screen/root_screen/root_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  setup();
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RootProvider>(create: (context) => RootProvider()),
        ChangeNotifierProvider<QuestionProvider>(create: (context) => QuestionProvider()),
        BlocProvider<QuestionBloc>(create: (context) => QuestionBloc()),
      ],
      child: MaterialApp(
        navigatorKey: getIt<NavigationService>().navigatorKey,
        home: const RootPage(),
      ),
    );
  }
}
