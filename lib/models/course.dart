import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String? id;
  final String name;
  final String code;
  final String? startTime;
  final String? endTime;
  final String teacherId;
  Course({
    this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
  });

  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? startTime,
    String? endTime,
    String? teacherId,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacherId: teacherId ?? this.teacherId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'startTime': startTime,
      'endTime': endTime,
      'teacherId': teacherId,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      teacherId: map['teacherId'],
    );
  }

  // factory Course.fromSnapshot(DocumentSnapshot doc) {
  //   Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
  //   print(data['code']);
  //   return Course(
  //     startTime: "00:00:00",
  //     endTime: dat,
  //     code: data['code'],
  //     id: "1234",
  //     name: "Maths",
  //     teacherId: "teacherId 1",
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(id: $id, name: $name, code: $code, startTime: $startTime, endTime: $endTime, teacherId: $teacherId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.teacherId == teacherId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        teacherId.hashCode;
  }
}
