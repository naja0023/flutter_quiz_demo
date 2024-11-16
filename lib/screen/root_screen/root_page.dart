import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_welcome/screen/question_screen/question_page.dart';
import 'package:provider/provider.dart';

import '../../di/get_it.dart';
import 'provider/root_provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            'QUIZ ISLAND',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
                      return Column(
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
                          const SizedBox(height: 40),
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
                              Provider.of<RootProvider>(context, listen: false)
                                  .onStart();
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
  // Create storage
  final storage = FlutterSecureStorage();

// Read value
// String value = await storage.read(key: key);

// Read all values
  // Map<String, String> allValues = await storage.readAll();
  // print(allValues);

// Delete value
// await storage.delete(key: key);

// Delete all
  // await storage.deleteAll();

// Write value
  // var data = {"id": "0001", "sessionId": "0123456789"};

  // await storage.write(key: "sessionId", value: jsonEncode(data));
  String? recentId = await storage.read(key: "sessionId");
  if (recentId != null) {
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
        print(recentId);
        Provider.of<RootProvider>(navigator.navigatorKey.currentContext!,
                listen: false)
            .onResume(recentId);
      } else {
        final storage = FlutterSecureStorage();
        storage.delete(key: "sessionId");
      }
    });
  }
}
