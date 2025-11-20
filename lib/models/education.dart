class Education {
  final String degree;
  final String institution;
  final String location;
  final String startDate;
  final String endDate;
  final String? gpa;
  final List<String>? achievements;
  final String? description;

  Education({
    required this.degree,
    required this.institution,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.gpa,
    this.achievements,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      location: json['location'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      gpa: json['gpa'] as String?,
      achievements: json['achievements'] != null
          ? List<String>.from(json['achievements'] as List)
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      if (gpa != null) 'gpa': gpa,
      if (achievements != null) 'achievements': achievements,
      if (description != null) 'description': description,
    };
  }
}
