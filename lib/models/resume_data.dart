import 'personal_info.dart';
import 'skill.dart';
import 'experience.dart';
import 'project.dart';
import 'education.dart';

/// Comprehensive resume data model that encompasses all portfolio information
class ResumeData {
  final PersonalInfo personalInfo;
  final List<Experience> experience;
  final List<Project> projects;
  final List<SkillCategory> skills;
  final List<Education> education;

  ResumeData({
    required this.personalInfo,
    required this.experience,
    required this.projects,
    required this.skills,
    required this.education,
  });

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
      experience: (json['experience'] as List)
          .map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List)
          .map((p) => Project.fromJson(p as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List)
          .map((s) => SkillCategory.fromJson(s as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List)
          .map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'experience': experience.map((e) => e.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
    };
  }

  /// Create a copy with updated fields
  ResumeData copyWith({
    PersonalInfo? personalInfo,
    List<Experience>? experience,
    List<Project>? projects,
    List<SkillCategory>? skills,
    List<Education>? education,
  }) {
    return ResumeData(
      personalInfo: personalInfo ?? this.personalInfo,
      experience: experience ?? this.experience,
      projects: projects ?? this.projects,
      skills: skills ?? this.skills,
      education: education ?? this.education,
    );
  }
}
