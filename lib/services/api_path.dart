import 'dart:core';

class ApiPath {
  static String users() => '/users';
  static String user({required String uid}) => 'users/$uid';
  static String imagePath({required String imageName}) =>
      'assets/images/$imageName';

  static String courses() => '/courses';
  static String course(String id) => '/courses/$id';
}
