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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return UserModel(
      uid: (map['uid'] as String?) ?? docId,
      name: map['name']?.toString(),
      email: map['email']?.toString(),
      isVerified: map['isVerified'] as bool?,
      phoneNum: _parseInt(map['phoneNum']),
      compnyName: (map['compnyName'] ?? map['companyName'])?.toString(),
      isRole: map['isRole'] as bool?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (isVerified != null) 'isVerified': isVerified,
      if (phoneNum != null) 'phoneNum': phoneNum,
      if (compnyName != null) 'compnyName': compnyName,
      if (isRole != null) 'isRole': isRole,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    bool? isVerified,
    int? phoneNum,
    String? compnyName,
    bool? isRole,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      phoneNum: phoneNum ?? this.phoneNum,
      compnyName: compnyName ?? this.compnyName,
      isRole: isRole ?? this.isRole,
    );
  }
}
