import 'package:flutter/material.dart';
import 'package:flutter_welcome/screen/question_screen/question_page.dart';
import 'package:provider/provider.dart';

import 'provider/root_provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'QUIZE ISLAND',
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          child: TextButton(
              onPressed: () =>
                  Provider.of<RootProvider>(context, listen: false).onStart(),
              child: const Text(
                'START',
                style: TextStyle(color: Colors.blue),
              )),
        ));
  }
}
