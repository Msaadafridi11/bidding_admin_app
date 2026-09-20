import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? uid;
  String? name;
  String? email;
  bool? isVerified;
  int? phoneNum;
  String? compnyName;
  bool? isRole;


  UserModel({
    this.uid,
    this.name,
    this.email,
    this.isVerified,
    this.phoneNum,
    this.compnyName,
    this.isRole,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
