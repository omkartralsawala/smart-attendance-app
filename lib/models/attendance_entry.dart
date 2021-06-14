import 'dart:convert';

class AttendanceEntry {
  final String id;
  final String name;
  final String uid;
  AttendanceEntry({
    required this.id,
    required this.name,
    required this.uid,
  });

  AttendanceEntry copyWith({
    String? id,
    String? name,
    String? uid,
  }) {
    return AttendanceEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'uid': uid,
    };
  }

  factory AttendanceEntry.fromMap(Map<String, dynamic> map) {
    return AttendanceEntry(
      id: map['id'],
      name: map['name'],
      uid: map['uid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceEntry.fromJson(String source) => AttendanceEntry.fromMap(json.decode(source));

  @override
  String toString() => 'AttendanceEntry(id: $id, name: $name, uid: $uid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AttendanceEntry &&
      other.id == id &&
      other.name == name &&
      other.uid == uid;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ uid.hashCode;
}
