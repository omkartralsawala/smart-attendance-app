class UserModel {
  UserModel({
    this.email,
    this.name = "John Wick",
    this.imageUrl,
    required this.uid,
  });
  final String uid;
  String? name;
  String? imageUrl;
  final String? email;
  List<dynamic> urls = [];
}
