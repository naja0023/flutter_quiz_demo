import 'package:json_annotation/json_annotation.dart';

part 'question_response_result.g.dart';

@JsonSerializable()
class Question {
  final String questionId;
  final String title;
  final List<Choice> choices;

  Question({
    required this.questionId,
    required this.title,
    required this.choices,
  });
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Choice {
  final String choiceId;
  final String title;
  final String questionId;

  Choice({
    required this.choiceId,
    required this.title,
    required this.questionId,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
