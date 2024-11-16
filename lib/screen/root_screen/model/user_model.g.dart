// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      name: json['name'] as String,
      data: SummaryData.fromJson(json['data'] as Map<String, dynamic>),
      dateSubmit: json['dateSubmit'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
      'dateSubmit': instance.dateSubmit,
    };
