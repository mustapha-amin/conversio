class ConversioUser {
  String? id;
  String? name;
  String? email;
  String? bio;

  ConversioUser({this.id, this.name, this.bio, this.email});

  static ConversioUser fromJson(Map<String, dynamic> json) {
    return ConversioUser(
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
