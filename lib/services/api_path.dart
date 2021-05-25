import 'dart:core';

class ApiPath {
  static String faculties() => '/factulty';
  static String faculty({required String uid}) => 'factulty/$uid';

  static String students() => '/factulty';
  static String student({required String uid}) => 'factulty/$uid';

  static String imagePath({required String imageName}) =>
      'assets/images/$imageName';

  static String courses() => '/courses';
  static String course(String id) => '/courses/$id';
  static String courseAttendanceDate(String id, String dateString) =>
      '/courses/$id/attendance/$dateString';
}
