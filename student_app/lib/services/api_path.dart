import 'dart:core';

class ApiPath {
  // static String faculties() => '/factulty';
  // static String faculty({required String uid}) => 'factulty/$uid';

  static String users() => '/users';
  static String user({required String uid}) => '/users/$uid';

  static String imagePath({required String imageName}) =>
      'assets/images/$imageName';

  static String courses() => '/courses';
  static String course(String id) => '/courses/$id';

  static String attendanceCollection() => '/attendance';
  static String courseAttendanceDate(String id, String dateString) =>
      '/attendance/$dateString/courses/$id/record';
}
