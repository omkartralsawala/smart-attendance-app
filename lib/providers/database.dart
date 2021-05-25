import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/services/api_path.dart';

abstract class FirestoreDatabase {
  Future<void> createCourse(Course course);
  Future<void> setUser(UserModel user);
  Stream<List<Course>> streamCourses();
}

class Database implements FirestoreDatabase {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  Future<void> _set(String path, Map<String, dynamic> data) async =>
      await _instance.doc(path).set(data);
  Future<void> _update(String path, Map<String, dynamic> data) async =>
      await _instance.doc(path).update(data);

  @override
  Future<void> createCourse(Course course) async {
    DocumentReference _docReference =
        _instance.collection(ApiPath.courses()).doc();
    Course updatedCourse = course.copyWith(id: _docReference.id);
    QuerySnapshot result = await _instance
        .collection(ApiPath.courses())
        .where('name', isEqualTo: course.name)
        .where('startTime', isEqualTo: course.startTime)
        .where('endTime', isEqualTo: course.endTime)
        .get();
    if (result.docs.length != 0) {
      throw "Course with name and time slot exists!";
    }
    return await _set(_docReference.path, updatedCourse.toMap());
  }

  @override
  Stream<List<Course>> streamCourses() =>
      _instance.collection(ApiPath.courses()).snapshots().map(
            (event) => event.docs.map((e) => Course.fromMap(e.data())).toList(),
          );

  @override
  Future<void> setUser(UserModel user) async {
    DocumentReference _docRef = _instance.doc(ApiPath.user(uid: user.uid));
    _set(_docRef.path, user.toMap());
  }
}
