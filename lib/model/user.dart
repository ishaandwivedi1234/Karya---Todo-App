class User {
  String name;
  String email;
  String userId;
  User({this.name, this.email, this.userId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'], email: json['email'], userId: json['_id']);
  }
}
