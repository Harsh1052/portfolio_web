import 'education.dart';
import 'experience.dart';
import 'personal_info.dart';
import 'project.dart';
import 'skill.dart';

class Resume {
  final PersonalInfo personalInfo;
  final List<Experience> experience;
  final List<Project> projects;
  final List<SkillCategory> skills;
  final List<Education> education;

  Resume({
    required this.personalInfo,
    required this.experience,
    required this.projects,
    required this.skills,
    required this.education,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      personalInfo: PersonalInfo.fromJson(json['personalInfo'] as Map<String, dynamic>),
      experience: (json['experience'] as List)
          .map((exp) => Experience.fromJson(exp as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List)
          .map((proj) => Project.fromJson(proj as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List)
          .map((skill) => SkillCategory.fromJson(skill as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List)
          .map((edu) => Education.fromJson(edu as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'experience': experience.map((exp) => exp.toJson()).toList(),
      'projects': projects.map((proj) => proj.toJson()).toList(),
      'skills': skills.map((skill) => skill.toJson()).toList(),
      'education': education.map((edu) => edu.toJson()).toList(),
    };
  }
}
