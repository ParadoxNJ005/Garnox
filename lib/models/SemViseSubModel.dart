class SemViseSubject {
  SemViseSubject({
    this.itBi,
    this.ece,
    this.it,
    this.yearName,
  });

  final List<String>? itBi;
  final List<String>? ece;
  final List<String>? it;
  final String? yearName;

  SemViseSubject.fromJson(Map<dynamic, dynamic> json)
      : itBi = (json['IT-BI'] as List<dynamic>?)?.cast<String>(),
        ece = (json['ECE'] as List<dynamic>?)?.cast<String>(),
        it = (json['IT'] as List<dynamic>?)?.cast<String>(),
        yearName = json['yearName'] as String?;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (itBi != null) data['IT-BI'] = itBi;
    if (ece != null) data['ECE'] = ece;
    if (it != null) data['IT'] = it;
    if (yearName != null) data['yearName'] = yearName;
    return data;
  }
}
