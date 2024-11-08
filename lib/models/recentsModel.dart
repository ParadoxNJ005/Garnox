class Recents {
  Recents({
    required this.Title,
    required this.URL,
    required this.Type,
  });
  late final String Title;
  late final String URL;
  late final String Type;

  Recents.fromJson(Map<String, dynamic> json){
    Title = json['Title']??"";
    URL = json['URL']??"";
    Type = json['Type']??"";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Title'] = Title;
    _data['URL'] = URL;
    _data['Type'] = URL;
    return _data;
  }
}