class Experience {
  final String position;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final String? employmentType;
  final List<String> responsibilities;
  final List<String>? technologies;
  final String? companyUrl;

  Experience({
    required this.position,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.employmentType,
    required this.responsibilities,
    this.technologies,
    this.companyUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      position: json['position'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      employmentType: json['employmentType'] as String?,
      responsibilities: List<String>.from(json['responsibilities'] as List),
      technologies: json['technologies'] != null
          ? List<String>.from(json['technologies'] as List)
          : null,
      companyUrl: json['companyUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      if (employmentType != null) 'employmentType': employmentType,
      'responsibilities': responsibilities,
      if (technologies != null) 'technologies': technologies,
      if (companyUrl != null) 'companyUrl': companyUrl,
    };
  }

  /// Get first responsibility as description
  String get description {
    return responsibilities.isNotEmpty ? responsibilities.first : '';
  }

  /// Get remaining responsibilities as highlights
  List<String> get highlights {
    return responsibilities.length > 1
        ? responsibilities.sublist(1)
        : [];
  }
}
