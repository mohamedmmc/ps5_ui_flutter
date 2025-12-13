enum ContentType { game, media }

class NewsItem {
  final String title;
  final String date;
  final String description;

  NewsItem({
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

  Trophies({
    required this.platinum,
    required this.gold,
    required this.silver,
    required this.bronze,
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

  Game({
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
  });
}

class FeaturedMedia {
  final String id;
  final String title;
  final String imageUrl;
  final String? logoUrl;
  final String serviceLogo;

  FeaturedMedia({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.logoUrl,
    required this.serviceLogo,
  });
}
