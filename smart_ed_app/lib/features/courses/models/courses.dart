class Course {
  final String id;
  final String title;
  final String description;
  final String instructorId;
  final String category;
  final String level;
  final double price;
  final String thumbnailUrl;
  final List<String> learningObjectives;
  final List<String> prerequisites;
  final List<String> moduleIds;
  final double rating;
  final int numberOfRatings;
  final List<String> tags;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorId,
    required this.category,
    required this.level,
    required this.price,
    required this.thumbnailUrl,
    required this.learningObjectives,
    required this.prerequisites,
    required this.moduleIds,
    required this.rating,
    required this.numberOfRatings,
    required this.tags,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructorId: json['instructorId'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      learningObjectives: List<String>.from(json['learningObjectives'] as List<dynamic>? ?? []),
      prerequisites: List<String>.from(json['prerequisites'] as List<dynamic>? ?? []),
      moduleIds: List<String>.from(json['moduleIds'] as List<dynamic>? ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      numberOfRatings: json['numberOfRatings'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructorId': instructorId,
      'category': category,
      'level': level,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
      'learningObjectives': learningObjectives,
      'prerequisites': prerequisites,
      'moduleIds': moduleIds,
      'rating': rating,
      'numberOfRatings': numberOfRatings,
      'tags': tags,
    };
  }
}