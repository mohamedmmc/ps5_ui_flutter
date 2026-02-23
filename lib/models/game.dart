enum ContentType { game, media }

class NewsItem {
  final String title;
  final String date;
  final String description;

  const NewsItem({
    required this.title,
    required this.date,
    required this.description,
  });
}

class Trophies {
  final int platinum;
  final int gold;
  final int silver;
  final int bronze;

  const Trophies({
    required this.platinum,
    required this.gold,
    required this.silver,
    required this.bronze,
  });
}

class ProjectFact {
  final String label;
  final String value;

  const ProjectFact({
    required this.label,
    required this.value,
  });
}

class ProjectDetails {
  final String role;
  final String organization;
  final String period;
  final String summary;
  final List<String> technologies;
  final List<String> highlights;
  final List<ProjectFact> facts;

  const ProjectDetails({
    required this.role,
    required this.organization,
    required this.period,
    required this.summary,
    required this.technologies,
    required this.highlights,
    required this.facts,
  });
}

class Game {
  final String id;
  final ContentType type;
  final String title;
  final String icon;
  final String? iconBgColor;
  final String background;
  final String? logo;
  final int? progress;
  final Trophies? trophies;
  final String? earned;
  final String description;
  final NewsItem? news;
  final ProjectDetails? projectDetails;
  final String? status;

  const Game({
    required this.id,
    required this.type,
    required this.title,
    required this.icon,
    this.iconBgColor,
    required this.background,
    this.logo,
    this.progress,
    this.trophies,
    this.earned,
    required this.description,
    this.news,
    this.projectDetails,
    this.status,
  });
}

class FeaturedMedia {
  final String id;
  final String title;
  final String imageUrl;
  final String? logoUrl;
  final String serviceLogo;

  const FeaturedMedia({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.logoUrl,
    required this.serviceLogo,
  });
}
