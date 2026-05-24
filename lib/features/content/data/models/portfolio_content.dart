/// All portfolio content — mirrors the `content/portfolio` Firestore document.
class PortfolioContent {
  const PortfolioContent({
    required this.tagline,
    required this.contact,
    required this.about,
    required this.projects,
    required this.articles,
  });

  final String tagline;
  final ContactInfo contact;
  final AboutContent about;
  final List<ProjectContent> projects;
  final List<ArticleContent> articles;

  factory PortfolioContent.fromMap(Map<String, dynamic> map) {
    return PortfolioContent(
      tagline: map['tagline'] as String,
      contact: ContactInfo.fromMap(map['contact'] as Map<String, dynamic>),
      about: AboutContent.fromMap(map['about'] as Map<String, dynamic>),
      projects: (map['projects'] as List)
          .map((e) => ProjectContent.fromMap(e as Map<String, dynamic>))
          .toList(),
      articles: (map['articles'] as List)
          .map((e) => ArticleContent.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ContactInfo {
  const ContactInfo({
    required this.email,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.mediumUrl,
    required this.resumeUrl,
  });

  final String email;
  final String githubUrl;
  final String linkedinUrl;
  final String mediumUrl;
  final String resumeUrl;

  factory ContactInfo.fromMap(Map<String, dynamic> map) => ContactInfo(
        email: map['email'] as String,
        githubUrl: map['githubUrl'] as String,
        linkedinUrl: map['linkedinUrl'] as String,
        mediumUrl: map['mediumUrl'] as String,
        resumeUrl: map['resumeUrl'] as String,
      );
}

class AboutContent {
  const AboutContent({required this.prose});

  // Newline-separated paragraphs
  final String prose;

  factory AboutContent.fromMap(Map<String, dynamic> map) =>
      AboutContent(prose: map['prose'] as String);
}

class ProjectContent {
  const ProjectContent({
    required this.slug,
    required this.name,
    required this.description,
    required this.metrics,
    required this.techTags,
    this.caseStudy,
  });

  final String slug;
  final String name;
  final String description;
  final List<String> metrics; // e.g. ["15K+ users", "4h → 1-click releases"]
  final List<String> techTags; // max 3
  final CaseStudyContent? caseStudy;

  factory ProjectContent.fromMap(Map<String, dynamic> map) => ProjectContent(
        slug: map['slug'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        metrics: List<String>.from(map['metrics'] as List),
        techTags: List<String>.from(map['techTags'] as List),
        caseStudy: map['caseStudy'] != null
            ? CaseStudyContent.fromMap(map['caseStudy'] as Map<String, dynamic>)
            : null,
      );
}

class CaseStudyContent {
  const CaseStudyContent({
    required this.role,
    required this.timeline,
    required this.stack,
    required this.summary,
    required this.problem,
    required this.approach,
    required this.whatWasHard,
    required this.outcomes,
    required this.whatIdDoDifferently,
  });

  final String role;
  final String timeline;
  final String stack;
  final String summary;
  final String problem;
  final String approach;
  final String whatWasHard;
  final List<String> outcomes;
  final String whatIdDoDifferently;

  factory CaseStudyContent.fromMap(Map<String, dynamic> map) => CaseStudyContent(
        role: map['role'] as String,
        timeline: map['timeline'] as String,
        stack: map['stack'] as String,
        summary: map['summary'] as String,
        problem: map['problem'] as String,
        approach: map['approach'] as String,
        whatWasHard: map['whatWasHard'] as String,
        outcomes: List<String>.from(map['outcomes'] as List),
        whatIdDoDifferently: map['whatIdDoDifferently'] as String,
      );
}

class ArticleContent {
  const ArticleContent({
    required this.title,
    required this.summary,
    required this.publishedDate,
    required this.url,
  });

  final String title;
  final String summary;
  final String publishedDate;
  final String url;

  factory ArticleContent.fromMap(Map<String, dynamic> map) => ArticleContent(
        title: map['title'] as String,
        summary: map['summary'] as String,
        publishedDate: map['publishedDate'] as String,
        url: map['url'] as String,
      );
}
