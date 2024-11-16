import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_welcome/screen/history_screen/history_list_page.dart';
import 'package:flutter_welcome/screen/question_screen/question_page.dart';
import 'package:provider/provider.dart';

import '../../di/get_it.dart';
import 'provider/root_provider.dart';

class RootPage extends StatefulWidget {
   static PageRoute route(){
    return MaterialPageRoute(builder: (context)=>const RootPage());
   }
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QUIZ ISLAND',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              IconButton(
                  onPressed: () =>
                      Navigator.of(context).push(HistoryListPage.route()),
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                  )),
            ],
          ),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: FutureBuilder(
                  future: _getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Welcome to Quiz Island!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _textController,
                                maxLength: 20,
                                decoration: const InputDecoration(
                                  labelText: 'Enter user name in English',
                                  border: OutlineInputBorder(),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  counterText: '',
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z ]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 16,
                                ),
                                elevation: 10,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<RootProvider>(context,
                                          listen: false)
                                      .onStart(_textController.text);
                                }
                              },
                              child: const Text(
                                'START',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ));
  }
}

Future<void> _getCurrentUser() async {
  final storage = const FlutterSecureStorage();
  String? _recentUser = await storage.read(key: "recentUser");
  if (_recentUser != null) {
    final navigator = getIt<NavigationService>();
    await showDialog(
      barrierDismissible: false,
      context: navigator.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            "You have a quiz that you haven't completed yet.",
            style: TextStyle(fontSize: 26),
          )),
          content: const Text(
            'Do you want to continue?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text(
                'New quiz',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      var decide = value as bool;
      if (decide) {
        print(_recentUser);
        Provider.of<RootProvider>(navigator.navigatorKey.currentContext!,
                listen: false)
            .onResume(jsonDecode(_recentUser));
      } else {
        final storage = const FlutterSecureStorage();
        storage.delete(key: "recentUser");
      }
    });
  }
}
