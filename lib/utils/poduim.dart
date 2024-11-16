import 'package:flutter/material.dart';

class Participant {
  final String name;
  final int score;
  final String timeUsed;
  final String registrationDate;

  const Participant({
    required this.name,
    required this.score,
    required this.timeUsed,
    required this.registrationDate,
  });
}

class PodiumWidget extends StatelessWidget {
  final Participant firstPlace;
  final Participant secondPlace;
  final Participant thirdPlace;

  const PodiumWidget({
    Key? key,
    required this.firstPlace,
    required this.secondPlace,
    required this.thirdPlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumPlace(2, secondPlace, Colors.grey.shade500, 150, context),
        _buildPodiumPlace(1, firstPlace, Colors.yellow.shade600, 200, context),
        _buildPodiumPlace(
            3, thirdPlace, Colors.orangeAccent.shade400, 120, context),
      ],
    );
  }

  Widget _buildPodiumPlace(int rank, Participant participant, Color color,
      double height, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '#$rank',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: color,
          ),
          width: (MediaQuery.of(context).size.width / 3) - 10,
          height: height,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(participant.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Score: ${participant.score}'),
                Text('Time: ${participant.timeUsed}'),
                Text('Date: ${participant.registrationDate}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
