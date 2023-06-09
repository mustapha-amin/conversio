class User {
  String? id;
  String? name;
  String? email;
  String? bio;

  User({this.id, this.name, this.bio, this.email});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
    };
  }
}
