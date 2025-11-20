class Project {
  final String name;
  final String description;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String? imageUrl;
  final List<String>? features;
  final String? startDate;
  final String? endDate;
  final bool isFeatured;

  Project({
    required this.name,
    required this.description,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.imageUrl,
    this.features,
    this.startDate,
    this.endDate,
    this.isFeatured = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: List<String>.from(json['technologies'] as List),
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      features: json['features'] != null
          ? List<String>.from(json['features'] as List)
          : null,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies,
      if (githubUrl != null) 'githubUrl': githubUrl,
      if (liveUrl != null) 'liveUrl': liveUrl,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (features != null) 'features': features,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      'isFeatured': isFeatured,
    };
  }
}
