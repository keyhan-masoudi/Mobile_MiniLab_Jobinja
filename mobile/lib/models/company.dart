class Company {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final String industry;

  Company({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    required this.industry,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      logo: json['logo'] as String?,
      industry: json['industry'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo,
      'industry': industry,
    };
  }
}