import '../../domain/entities/experience_entry.dart';
import '../../domain/entities/education_entry.dart';

/// In-memory data source for career history.
///
/// Data mirrors resume.json — ordered newest → oldest.
class ExperienceMockSource {
  const ExperienceMockSource();

  List<ExperienceEntry> getExperience() => const [
        ExperienceEntry(
          position: 'Senior Flutter Developer',
          company: 'FarmSetu Pvt. Limited',
          location: 'Surat, Gujarat',
          startDate: 'June 2024',
          endDate: 'Present',
          employmentType: 'Full-time',
          responsibilities: [
            'Architected mobile & Flutter web apps for the Agri-Food Supply Chain, serving 10,000+ users',
            'Implemented Clean Architecture with Bloc, reducing code complexity by 35% and boosting performance by 45%',
            'Led 5 major releases, collaborating with 8+ cross-functional team members',
            'Mentored 3 junior Flutter developers through code reviews and pair programming',
            'Optimized CI/CD pipelines — cut release time from 4 hours to 30 minutes',
          ],
          technologies: [
            'Flutter',
            'Flutter Web',
            'Clean Architecture',
            'Bloc',
            'CI/CD',
            'Firebase',
          ],
        ),
        ExperienceEntry(
          position: 'Senior Flutter Developer',
          company: 'Elision Infotech',
          location: 'Surat, Gujarat',
          startDate: 'Jan 2023',
          endDate: 'June 2024',
          employmentType: 'Full-time',
          responsibilities: [
            'Developed 8+ enterprise Flutter apps serving 50,000+ active users',
            'Led a team of 3 Flutter developers with daily code reviews and best practices enforcement',
            'Integrated 15+ third-party services including Razorpay, Stripe, and Firebase',
            'Reduced crash rates by 60% through comprehensive testing and error handling',
            'Optimized build processes — 50% faster compilation, 30% smaller APK/IPA',
          ],
          technologies: [
            'Flutter',
            'Bloc',
            'Provider',
            'Razorpay',
            'Stripe',
            'Firebase',
          ],
        ),
        ExperienceEntry(
          position: 'Flutter Developer',
          company: 'Tagline Infotech',
          location: 'Surat, Gujarat',
          startDate: 'Aug 2021',
          endDate: 'Dec 2022',
          employmentType: 'Full-time',
          responsibilities: [
            'Built responsive UI for 10+ mobile apps across Android and iOS',
            'Implemented Redux state management, improving code maintainability by 30%',
            'Created custom animations using Flutter\'s animation framework',
            'Integrated Firebase Auth, Firestore, Storage, and Cloud Functions',
          ],
          technologies: [
            'Flutter',
            'Redux',
            'SQLite',
            'Hive',
            'Firebase',
            'Animations',
          ],
        ),
        ExperienceEntry(
          position: 'Flutter Developer Intern',
          company: 'Across the Glob',
          location: 'Bangalore, Karnataka',
          startDate: 'Jan 2021',
          endDate: 'Aug 2021',
          employmentType: 'Internship',
          responsibilities: [
            'Assisted in Flutter app development while learning industry best practices',
            'Gained hands-on experience with Dart and the complete mobile app development lifecycle',
            'Participated in daily standups and sprint planning following Scrum methodology',
          ],
          technologies: [
            'Flutter',
            'Dart',
            'Scrum',
            'Agile',
          ],
        ),
      ];

  List<EducationEntry> getEducation() => const [
        EducationEntry(
          degree: 'B.E. in Computer Engineering',
          institution: 'Gujarat Technological University',
          location: 'Gujarat, India',
          startYear: '2017',
          endYear: '2021',
          description:
              'Specialized in Mobile Application Development and modern software engineering practices.',
        ),
      ];
}
