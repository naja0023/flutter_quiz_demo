import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_welcome/screen/root_screen/model/user_model.dart';

import '../../utils/poduim.dart';

class HistoryListPage extends StatefulWidget {
  static PageRoute route() {
    return MaterialPageRoute(builder: (context) => const HistoryListPage());
  }

  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'TOP 10 OF SCORE 🎉',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
            future: _getHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: MediaQuery.of(context).size.height * 0.3,
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Builder(builder: (context) {
                          final first = snapshot.data![0];
                          final second = snapshot.data![1];
                          final third = snapshot.data![2];
                          return PodiumWidget(
                            firstPlace: Participant(
                                name: first.name,
                                score: first.data.score,
                                timeUsed: '${first.data.timeSpent} secons',
                                registrationDate: first.dateSubmit),
                            secondPlace: Participant(
                                name: second.name,
                                score: second.data.score,
                                timeUsed: '${second.data.timeSpent} secons',
                                registrationDate: second.dateSubmit),
                            thirdPlace: Participant(
                                name: third.name,
                                score: third.data.score,
                                timeUsed: '${third.data.timeSpent} secons',
                                registrationDate: third.dateSubmit),
                          );
                        }),
                      ),
                      Expanded(
                        child: Builder(builder: (context) {
                          final anotherDate = snapshot.data!.skip(3).toList();
                          return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              itemCount: anotherDate.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blueGrey,
                                          Colors.white54
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '#${index + 4}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Name : ${anotherDate[index].name}'),
                                              Text(
                                                  'Score : ${anotherDate[index].data.score}'),
                                              Text(
                                                  'Time to spent : ${anotherDate[index].data.timeSpent} seconds'),
                                              Text(
                                                  'Date to submit : ${anotherDate[index].dateSubmit}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '⚠️ No history !!!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: const Text('Refresh'))
                      ],
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

Future<List<UserData>?> _getHistory() async {
  final storage = const FlutterSecureStorage();
  var all = await storage.read(key: 'history');
  if (all != null) {
    List rawData = jsonDecode(all);
    List<UserData> listUser = [];
    for (var element in rawData) {
      // print(element);
      var userData = UserData.fromJson(element);
      listUser.add(userData);
    }
    return listUser;
  }
}
