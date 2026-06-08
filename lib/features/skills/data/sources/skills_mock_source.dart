import '../../domain/entities/skill_entry.dart';
import '../../domain/entities/timeline_year.dart';

/// In-memory data source for the skills timeline.
///
/// Year range is derived from the resume:
///   2021 — internship / first Flutter work
///   2022 — first professional delivery at Elision Infotech
///   2023 — NUG e-commerce (Elision Infotech)
///   2024 — FarmSetu (sole mobile & web engineer)
///   2025+ — full-stack pivot
///
/// Each skill tooltip gives recruiter-readable context tying
/// the skill to a real project outcome.
class SkillsMockSource {
  const SkillsMockSource();

  List<TimelineYear> getTimeline() => const [
        TimelineYear(
          year: 2021,
          skills: [
            SkillEntry(
              label: 'Flutter',
              tooltip: 'First Flutter project — built foundational mobile UI skills',
            ),
            SkillEntry(
              label: 'Dart',
              tooltip: 'Core language — async/await, streams, null safety',
            ),
            SkillEntry(
              label: 'Firebase',
              tooltip:
                  'Auth + Firestore — first exposure to real-time backend',
            ),
            SkillEntry(
              label: 'REST APIs',
              tooltip: 'HTTP client integration, JSON parsing, error handling',
            ),
            SkillEntry(
              label: 'Git',
              tooltip: 'Version control workflow, branching strategies',
            ),
          ],
        ),
        TimelineYear(
          year: 2022,
          skills: [
            SkillEntry(
              label: 'BLoC',
              tooltip:
                  'State management pattern — first production use at Elision Infotech',
            ),
            SkillEntry(
              label: 'Provider',
              tooltip: 'Reactive state in early Elision projects',
            ),
            SkillEntry(
              label: 'FlutterFlow',
              tooltip:
                  'Used to scaffold NUG auth & basic screens at speed; critical logic written in Flutter',
            ),
            SkillEntry(
              label: 'Material Design',
              tooltip: 'Component-level UI system, theme + typography tokens',
            ),
            SkillEntry(
              label: 'Android / iOS',
              tooltip: 'Platform-specific config, signing, flavors',
            ),
          ],
        ),
        TimelineYear(
          year: 2023,
          skills: [
            SkillEntry(
              label: 'Deeplinks',
              tooltip:
                  'NUG — shipped Android App Links + iOS Universal Links for payment return flow',
            ),
            SkillEntry(
              label: 'Chrome Custom Tabs',
              tooltip:
                  'NUG — used system browser to handle a payment provider with no Flutter SDK',
            ),
            SkillEntry(
              label: 'RevenueCat',
              tooltip:
                  'Trovo — in-app subscription paywall, purchase restoration, entitlement checks',
            ),
            SkillEntry(
              label: 'Google Maps SDK',
              tooltip:
                  'Trovo — GPS-based checkpoint geofencing using Haversine formula',
            ),
            SkillEntry(
              label: 'iOS Universal Links',
              tooltip:
                  'NUG — AASA file setup, Associated Domains, cache debugging across test devices',
            ),
          ],
        ),
        TimelineYear(
          year: 2024,
          skills: [
            SkillEntry(
              label: 'Clean Architecture',
              tooltip:
                  'FarmSetu — established as the team standard for all new features, including SetuBooks',
            ),
            SkillEntry(
              label: 'TDD',
              tooltip:
                  'FarmSetu — test-driven development adopted alongside Clean Architecture',
            ),
            SkillEntry(
              label: 'GraphQL',
              tooltip: 'FarmSetu — primary data-fetching protocol for the mobile app',
            ),
            SkillEntry(
              label: 'Codemagic CI/CD',
              tooltip:
                  'FarmSetu — cut release time from 4-hour ceremony to single click; 3 flavors, 2 stores',
            ),
            SkillEntry(
              label: 'Dart Isolates',
              tooltip:
                  'FarmSetu — moved SetuBooks chart calculations off the main thread via compute()',
            ),
            SkillEntry(
              label: 'Flutter Web',
              tooltip:
                  'FarmSetu — extended mobile codebase to web for the farmer-facing dashboard',
            ),
            SkillEntry(
              label: 'Sentry',
              tooltip:
                  'FarmSetu — added production observability; crash reports, breadcrumbs, alert routing',
            ),
            SkillEntry(
              label: 'Firebase Crashlytics',
              tooltip:
                  'FarmSetu — paired with Sentry for crash capture on Android + iOS',
            ),
          ],
        ),
        TimelineYear(
          year: 2025,
          skills: [
            SkillEntry(
              label: 'Python',
              tooltip: 'Full-stack pivot — learning backend to design APIs, not just consume them',
            ),
            SkillEntry(
              label: 'System Design',
              tooltip: 'Studying API design, scalability patterns, and backend architecture',
            ),
            SkillEntry(
              label: 'Firebase Hosting',
              tooltip:
                  'Portfolio — CI/CD with GitHub Actions; auto-deploy on push to main',
            ),
            SkillEntry(
              label: 'GitHub Actions',
              tooltip: 'Portfolio — automated Flutter web build + Firebase deploy pipeline',
            ),
          ],
        ),
      ];
}
