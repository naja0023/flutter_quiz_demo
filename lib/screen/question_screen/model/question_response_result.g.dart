// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_response_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionId: json['questionId'] as String,
      title: json['title'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'questionId': instance.questionId,
      'title': instance.title,
      'choices': instance.choices,
    };

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      choiceId: json['choiceId'] as String,
      title: json['title'] as String,
      questionId: json['questionId'] as String,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'choiceId': instance.choiceId,
      'title': instance.title,
      'questionId': instance.questionId,
    };
