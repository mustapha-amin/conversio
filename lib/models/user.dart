class ConversioUser {
  String? id;
  String? name;
  String? email;
  String? bio;
  String? profileImgUrl;

  ConversioUser({this.id, this.name, this.bio, this.email, this.profileImgUrl});

  static ConversioUser fromJson(Map<String, dynamic> json) {
    return ConversioUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      profileImgUrl: json['profileImgUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImgUrl': profileImgUrl,
    };
  }
}
