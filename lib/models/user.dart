class ConversioUser {
  String? id;
  String? name;
  String? email;
  String? bio;
  String? profileImgUrl;

  ConversioUser({this.id, this.name, this.bio, this.email, this.profileImgUrl});

  factory ConversioUser.fromJson(Map<String, dynamic> json) {
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

  ConversioUser copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? profileImgUrl,
  }) {
    return ConversioUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImgUrl: profileImgUrl ?? profileImgUrl,
    );
  }

  @override
  String toString() {
    return 'ConversioUser(id: $id, name: $name, email: $email, bio: $bio, profileImgUrl: $profileImgUrl)';
  }
}
