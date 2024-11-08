class SpecificSubject {
  SpecificSubject({
    required this.questionPapers,
    required this.subjectCode,
    required this.moderators,
    required this.recommendedBooks,
    required this.material,
    required this.importantLinks,
  });

  late final List<QuestionPapers> questionPapers;
  late final String subjectCode;
  late final List<MODERATORS> moderators;
  late final List<RecommendedBooks> recommendedBooks;
  late final List<Material> material;
  late final List<ImportantLinks> importantLinks;

  SpecificSubject.fromJson(Map<String, dynamic> json){
    questionPapers = List.from(json['QuestionPapers']).map((e) => QuestionPapers.fromJson(e)).toList();
    subjectCode = json['SubjectCode'] ?? "";
    moderators = List.from(json['MODERATORS']).map((e) => MODERATORS.fromJson(e)).toList();
    recommendedBooks = List.from(json['Recommended Books']).map((e) => RecommendedBooks.fromJson(e)).toList();
    material = List.from(json['Material']).map((e) => Material.fromJson(e)).toList();
    importantLinks = List.from(json['Important Links']).map((e) => ImportantLinks.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['QuestionPapers'] = questionPapers.map((e) => e.toJson()).toList();
    _data['SubjectCode'] = subjectCode;
    _data['MODERATORS'] = moderators.map((e) => e.toJson()).toList();
    _data['Recommended Books'] = recommendedBooks.map((e) => e.toJson()).toList();
    _data['Material'] = material.map((e) => e.toJson()).toList();
    _data['Important Links'] = importantLinks.map((e) => e.toJson()).toList();
    return _data;
  }
}

class QuestionPapers {
  QuestionPapers({
    required this.type,
    required this.year,
    required this.title,
    required this.id,
    required this.url,
  });

  late final String type;
  late final String year;
  late final String title;
  late final String id;
  late final String url;

  QuestionPapers.fromJson(Map<String, dynamic> json){
    type = json['Type'] ?? "";
    year = json['Year'] ?? "";
    title = json['Title'] ?? "";
    id = json['id'] ?? "";
    url = json['URL'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Type'] = type;
    _data['Year'] = year;
    _data['Title'] = title;
    _data['id'] = id;
    _data['URL'] = url;
    return _data;
  }
}

class MODERATORS {
  MODERATORS({
    required this.contactNumber,
    required this.uid,
    required this.name,
  });

  late final String contactNumber;
  late final String uid;
  late final String name;

  MODERATORS.fromJson(Map<String, dynamic> json){
    contactNumber = json['Contact Number'] ?? "";
    uid = json['uid'] ?? "";
    name = json['Name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Contact Number'] = contactNumber;
    _data['uid'] = uid;
    _data['Name'] = name;
    return _data;
  }
}

class RecommendedBooks {
  RecommendedBooks({
    required this.author,
    required this.publication,
    required this.bookTitle,
  });

  late final String author;
  late final String publication;
  late final String bookTitle;

  RecommendedBooks.fromJson(Map<String, dynamic> json){
    author = json['Author'] ?? "";
    publication = json['Publication'] ?? "";
    bookTitle = json['BookTitle'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Author'] = author;
    _data['Publication'] = publication;
    _data['BookTitle'] = bookTitle;
    return _data;
  }
}

class Material {
  Material({
    required this.contentURL,
    required this.title,
    required this.id,
  });

  late final String contentURL;
  late final String title;
  late final String id;

  Material.fromJson(Map<String, dynamic> json){
    contentURL = json['Content URL'] ?? "";
    title = json['Title'] ?? "";
    id = json['id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Content URL'] = contentURL;
    _data['Title'] = title;
    _data['id'] = id;
    return _data;
  }
}

class ImportantLinks {
  ImportantLinks({
    required this.contentURL,
    required this.title,
  });

  late final String contentURL;
  late final String title;

  ImportantLinks.fromJson(Map<String, dynamic> json){
    contentURL = json['Content URL'] ?? "";
    title = json['Title'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Content URL'] = contentURL;
    _data['Title'] = title;
    return _data;
  }
}
