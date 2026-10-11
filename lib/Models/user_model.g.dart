// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['uid'] as String?,
  name: json['name'] as String?,
  email: json['email'] as String?,
  isVerified: json['isVerified'] as bool?,
  phoneNum: (json['phoneNum'] as num?)?.toInt(),
  compnyName: (json['compnyName'] ?? json['companyName']) as String?,
  isRole: json['isRole'] as bool?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'isVerified': instance.isVerified,
  'phoneNum': instance.phoneNum,
  'compnyName': instance.compnyName,
  'isRole': instance.isRole,
};
