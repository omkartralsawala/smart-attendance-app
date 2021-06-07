import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    this.email,
    required this.userType,
    this.nfcTag,
    this.enrolledCourses,
  });
  final String uid;
  final String? name;
  final String? email;
  final String userType;
  final String? nfcTag;
  final List<String>? enrolledCourses;

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? userType,
    String? nfcTag,
    List<String>? enrolledCourses,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      nfcTag: nfcTag ?? this.nfcTag,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'userType': userType,
      'nfcTag': nfcTag,
      'enrolledCourses': enrolledCourses,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      userType: map['userType'],
      nfcTag: map['nfcTag'],
      enrolledCourses: List<String>.from(map['enrolledCourses']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, userType: $userType, nfcTag: $nfcTag, enrolledCourses: $enrolledCourses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.userType == userType &&
        other.nfcTag == nfcTag &&
        listEquals(other.enrolledCourses, enrolledCourses);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        userType.hashCode ^
        nfcTag.hashCode ^
        enrolledCourses.hashCode;
  }
}
