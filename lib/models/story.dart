class Story {
  String? id;
  String? imgUrl;
  DateTime? uploadTime;

  Story({String? id, this.imgUrl, this.uploadTime})
      : id = DateTime.now().microsecondsSinceEpoch.toString();

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      imgUrl: json['imgUrl'],
      uploadTime: json['uploadTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'uploadTime': uploadTime,
    };
  }

  Story copyWith({String? id, String? imgUrl, DateTime? uploadTime}) {
    return Story(
      id: id ?? this.id,
      imgUrl: imgUrl ?? this.imgUrl, 
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }
}
