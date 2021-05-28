import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_attendance_app/models/attendance_entry.dart';
import 'package:smart_attendance_app/models/course.dart';
import 'package:smart_attendance_app/models/user.dart';
import 'package:smart_attendance_app/services/api_path.dart';

abstract class FirestoreDatabase {
  Future<void> setUser(UserModel user);
  Future<UserModel> getUser(String nfcTagId);
  Stream<UserModel> streamUser(String uid);
  Future<bool> checkUserExists(UserModel user);
  Future<void> updateUser(Course course, UserModel user);
  Future<Course> getCourse(String courseId);
  Future<void> createCourse(Course course);
  Future<void> updateCourse(Course course);
  Stream<List<Course>> streamCourses();
  Stream<List<Course>> streamFacultyCourses(String teacherId);
  Future<void> setAttendance(String dateString, UserModel user, Course course);
  Stream<List<AttendanceEntry>> streamAttendance(
      String dateString, Course course);
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
  Stream<List<Course>> streamFacultyCourses(String teacherId) => _instance
      .collection(ApiPath.courses())
      .where('teacherId', isEqualTo: teacherId)
      .snapshots()
      .map(
        (event) => event.docs.map((e) => Course.fromMap(e.data())).toList(),
      );

  @override
  Future<void> setUser(UserModel user) async {
    DocumentReference _docRef = _instance.doc(ApiPath.user(uid: user.uid));
    _set(_docRef.path, user.toMap());
  }

  @override
  Future<void> updateCourse(Course course) async =>
      await _update(ApiPath.course(course.id!), course.toMap());

  @override
  Future<bool> checkUserExists(UserModel user) async {
    return _instance
        .doc(ApiPath.user(uid: user.uid))
        .get()
        .then((value) => value.exists);
  }

  @override
  Stream<UserModel> streamUser(String uid) => _instance
      .doc(ApiPath.user(uid: uid))
      .snapshots()
      .map((value) => UserModel.fromMap(value.data()!));

  @override
  Future<Course> getCourse(String courseId) async {
    DocumentSnapshot<Map<String, dynamic>> value =
        await _instance.doc(ApiPath.course(courseId)).get();
    return Course.fromMap(value.data()!);
  }

  @override
  Future<void> updateUser(Course course, UserModel user) async {
    List<String> updatedCoursesList = [...user.enrolledCourses!, course.id!];
    UserModel upadatedUser = user.copyWith(enrolledCourses: updatedCoursesList);
    await _update(ApiPath.user(uid: user.uid), upadatedUser.toMap());
  }

  Future<void> calculateAttendance(Course course, UserModel user) async {
    var attendance = 0;
    _instance
        .collection(ApiPath.attendanceCollection())
        .snapshots()
        .map((element) => element.docs.map((e) {
              // waiting on take attendance implementation
            }));
  }

  @override
  Future<void> setAttendance(
      String dateString, UserModel user, Course course) async {
    DocumentReference _docRef = _instance
        .collection(ApiPath.courseAttendanceDate(course.id!, "2021-05-26"))
        .doc();
    print("---------------------------------");
    print(_docRef.path);
    print("---------------------------------");
    _set(_docRef.path, {
      "id": _docRef.id,
      "name": user.name,
      "studentId": user.uid,
    });
  }

  @override
  Future<UserModel> getUser(String nfcTagId) => _instance
      .collection(ApiPath.users())
      .where('nfcTag', isEqualTo: nfcTagId)
      .get()
      .then((value) => UserModel.fromMap(value.docs.first.data()));

  @override
  Stream<List<AttendanceEntry>> streamAttendance(
          String dateString, Course course) =>
      _instance
          .collection(ApiPath.courseAttendanceDate(course.id!, dateString))
          .snapshots()
          .map((event) => event.docs
              .map((e) => AttendanceEntry.fromMap(e.data()))
              .toList());
  
}
