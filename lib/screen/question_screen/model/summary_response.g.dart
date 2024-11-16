// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryData _$SummaryDataFromJson(Map<String, dynamic> json) => SummaryData(
      submittedQuestions: (json['submittedQuestions'] as num).toInt(),
      score: (json['score'] as num).toInt(),
    );

Map<String, dynamic> _$SummaryDataToJson(SummaryData instance) =>
    <String, dynamic>{
      'submittedQuestions': instance.submittedQuestions,
      'score': instance.score,
    };
