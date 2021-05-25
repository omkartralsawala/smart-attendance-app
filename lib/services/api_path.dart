import 'dart:core';

class ApiPath {
  static String user({required String uid}) => 'users/$uid';
  static String imagePath({required String imageName}) =>
      'assets/images/$imageName';
}
