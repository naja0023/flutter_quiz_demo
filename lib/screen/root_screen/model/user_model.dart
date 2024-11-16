import 'package:json_annotation/json_annotation.dart';

import '../../question_screen/model/summary_response.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserData {
  final String name;
  final SummaryData data;
  final String dateSubmit;

  UserData({
    required this.name,
    required this.data,
    required this.dateSubmit,
  });
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
