class Skill {
  final String name;
  final String category;
  final int? proficiency; // 1-100 scale
  final String? icon;
  final List<String>? subSkills;

  Skill({
    required this.name,
    required this.category,
    this.proficiency,
    this.icon,
    this.subSkills,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      category: json['category'] as String,
      proficiency: json['proficiency'] as int?,
      icon: json['icon'] as String?,
      subSkills: json['subSkills'] != null
          ? List<String>.from(json['subSkills'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      if (proficiency != null) 'proficiency': proficiency,
      if (icon != null) 'icon': icon,
      if (subSkills != null) 'subSkills': subSkills,
    };
  }

  /// Get proficiency level as a string
  String get level {
    if (proficiency == null) return 'Intermediate';
    if (proficiency! >= 90) return 'Expert';
    if (proficiency! >= 70) return 'Advanced';
    if (proficiency! >= 50) return 'Intermediate';
    return 'Beginner';
  }
}

class SkillCategory {
  final String name;
  final List<Skill> skills;
  final String? icon;

  SkillCategory({
    required this.name,
    required this.skills,
    this.icon,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      name: json['name'] as String,
      skills: (json['skills'] as List)
          .map((skill) => Skill.fromJson(skill as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'skills': skills.map((skill) => skill.toJson()).toList(),
      if (icon != null) 'icon': icon,
    };
  }
}
