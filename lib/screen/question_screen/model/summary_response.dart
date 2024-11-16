import 'package:json_annotation/json_annotation.dart';

part 'summary_response.g.dart';

@JsonSerializable()
class SummaryData {
  final int submittedQuestions;
  final int score;

  SummaryData({
    required this.submittedQuestions,
    required this.score,
  });
  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryDataToJson(this);
}
