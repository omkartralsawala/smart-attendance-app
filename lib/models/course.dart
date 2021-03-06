import 'dart:convert';

class Course {
  final String? id;
  final String name;
  final String code;
  final String startTime;
  final String endTime;
  final String teacherId;
  final int lecturesHeld;
  Course({
    this.id,
    required this.name,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
    required this.lecturesHeld,
  });

  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? startTime,
    String? endTime,
    String? teacherId,
    int? lecturesHeld,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacherId: teacherId ?? this.teacherId,
      lecturesHeld: lecturesHeld ?? this.lecturesHeld,
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
      'lecturesHeld': lecturesHeld,
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
      lecturesHeld: map['lecturesHeld'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Course(id: $id, name: $name, code: $code, startTime: $startTime, endTime: $endTime, teacherId: $teacherId, lecturesHeld: $lecturesHeld)';
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
      other.teacherId == teacherId &&
      other.lecturesHeld == lecturesHeld;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      teacherId.hashCode ^
      lecturesHeld.hashCode;
  }
}
