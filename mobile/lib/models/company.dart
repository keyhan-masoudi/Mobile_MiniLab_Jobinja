// lib/models/company.dart

class Company {
  final String id;
  final String name;
  final String slug;
  final String? logo;
  final String? industry;
  final String? size;
  final String? description;
  final String? website;
  final String? location;
  final int? jobCount;

  Company({
    required this.id,
    required this.name,
    required this.slug,
    this.logo,
    this.industry,
    this.size,
    this.description,
    this.website,
    this.location,
    this.jobCount,
  });

  /// Factory constructor to safely unpack JSON maps from the server.
  /// Uses rigorous type protection to avoid runtime null-casting issues.
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: (json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      logo: json['logo'] as String?,
      industry: json['industry'] as String?,
      size: json['size'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      location: json['location'] as String?,
      jobCount: json['job_count'] as int?,
    );
  }

  /// Converts the Company object back into a key-value Map structure.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'logo': logo,
      'industry': industry,
      'size': size,
      'description': description,
      'website': website,
      'location': location,
      'job_count': jobCount,
    };
  }

  /// Helper method to safely update individual corporate properties 
  /// without re-instantiating every property.
  Company copyWith({
    String? id,
    String? name,
    String? slug,
    String? logo,
    String? industry,
    String? size,
    String? description,
    String? website,
    String? location,
    int? jobCount,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      logo: logo ?? this.logo,
      industry: industry ?? this.industry,
      size: size ?? this.size,
      description: description ?? this.description,
      website: website ?? this.website,
      location: location ?? this.location,
      jobCount: jobCount ?? this.jobCount,
    );
  }
}