import '../../../../models/education.dart';
import '../../../../models/experience.dart';
import '../../../../models/skill.dart';
import '../../../../models/personal_info.dart';

sealed class ResumeSection {
  const ResumeSection();
}

class BioSection extends ResumeSection {
  final PersonalInfo info;
  const BioSection(this.info);
}

class EducationSection extends ResumeSection {
  final List<Education> education;
  const EducationSection(this.education);
}

class ExperienceSection extends ResumeSection {
  final List<Experience> experiences;
  const ExperienceSection(this.experiences);
}

class SkillsSection extends ResumeSection {
  final List<SkillCategory> skills;
  const SkillsSection(this.skills);
}

class EmptySection extends ResumeSection {
  const EmptySection();
}
