class User {
  String? name;
  String? email;
  String? imageUrl;
  String? college;
  int? batch;
  int? semester;
  String? branch;
  String? uid;

  User({
    this.name,
    this.email,
    this.imageUrl,
    this.batch,
    this.college,
    this.branch,
    this.semester,
    this.uid,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['UID'];
    name = json['Name'];
    email = json['Email'];
    imageUrl = json['ImageURL'];
    college = json['College'];
    batch = json['Batch'];
    branch = json['Branch'];
    semester = json['Semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userDetail = {
      'UID': uid,
      'Name': name,
      'Email': email,
      'ImageURL': imageUrl,
      'College': college,
      'Batch': batch,
      'Branch': branch,
      'Semester': semester,
    };
    return userDetail;
  }
}
