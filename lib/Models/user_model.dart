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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int? parsedPhone;
    if (json['phoneNum'] != null) {
      if (json['phoneNum'] is int) {
        parsedPhone = json['phoneNum'] as int;
      } else {
        parsedPhone = int.tryParse(json['phoneNum'].toString());
      }
    }

    return UserModel(
      uid: json['uid']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      isVerified: json['isVerified'] as bool?,
      phoneNum: parsedPhone,
      compnyName: (json['compnyName'] ?? json['companyName'])?.toString(),
      isRole: json['isRole'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid,
    'name': name,
    'email': email,
    'isVerified': isVerified,
    'phoneNum': phoneNum,
    'compnyName': compnyName,
    'isRole': isRole,
  };
}
