class PersonalInfo {
  final String name;
  final String title;
  final String email;
  final String? phone;
  final String? location;
  final String bio;
  final String? avatarUrl;
  final SocialLinks socialLinks;

  PersonalInfo({
    required this.name,
    required this.title,
    required this.email,
    this.phone,
    this.location,
    required this.bio,
    this.avatarUrl,
    required this.socialLinks,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'] as String,
      title: json['title'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      socialLinks: SocialLinks.fromJson(json['socialLinks'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'email': email,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      'bio': bio,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'socialLinks': socialLinks.toJson(),
    };
  }
}

class SocialLinks {
  final String? github;
  final String? linkedin;
  final String? twitter;
  final String? website;
  final String? medium;
  final String? stackoverflow;
  final Map<String, String>? others;

  SocialLinks({
    this.github,
    this.linkedin,
    this.twitter,
    this.website,
    this.medium,
    this.stackoverflow,
    this.others,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      github: json['github'] as String?,
      linkedin: json['linkedin'] as String?,
      twitter: json['twitter'] as String?,
      website: json['website'] as String?,
      medium: json['medium'] as String?,
      stackoverflow: json['stackoverflow'] as String?,
      others: json['others'] != null
          ? Map<String, String>.from(json['others'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (github != null) 'github': github,
      if (linkedin != null) 'linkedin': linkedin,
      if (twitter != null) 'twitter': twitter,
      if (website != null) 'website': website,
      if (medium != null) 'medium': medium,
      if (stackoverflow != null) 'stackoverflow': stackoverflow,
      if (others != null) 'others': others,
    };
  }

  /// Convert to Map for easier iteration in UI
  Map<String, String> toMap() {
    final map = <String, String>{};
    if (github != null) map['GitHub'] = github!;
    if (linkedin != null) map['LinkedIn'] = linkedin!;
    if (twitter != null) map['Twitter'] = twitter!;
    if (website != null) map['Website'] = website!;
    if (medium != null) map['Medium'] = medium!;
    if (stackoverflow != null) map['StackOverflow'] = stackoverflow!;
    if (others != null) map.addAll(others!);
    return map;
  }
}
