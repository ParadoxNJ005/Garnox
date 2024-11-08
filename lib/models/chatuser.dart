class ChatUser {
  ChatUser({
    required this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.college,
    this.batch,
    this.semester,
    this.branch,
  });

  String? name;
  String? email;
  String? imageUrl;
  String? college;
  int? batch;
  int? semester;
  String? branch;
  String uid;

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      name: json['name'] as String?,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      college: json['college'] as String?,
      batch: json['batch'] as int?,
      semester: json['semester'] as int?,
      branch: json['branch'] as String?,
      uid: json['uid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['imageUrl'] = imageUrl;
    data['college'] = college;
    data['batch'] = batch;
    data['semester'] = semester;
    data['branch'] = branch;
    data['uid'] = uid;
    return data;
  }
}
