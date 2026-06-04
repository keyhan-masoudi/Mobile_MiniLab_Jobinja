// lib/models/job.dart

import 'company.dart';

class JobLocation {
  final String province;
  final String city;

  JobLocation({required this.province, required this.city});

  factory JobLocation.fromJson(Map<String, dynamic> json) {
    return JobLocation(
      province: json['province'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'province': province, 'city': city};

  String get formattedLocation => '$province، $city'.trim();
}

class JobSalary {
  final double? amount;
  final bool isNegotiable;
  final String display;

  JobSalary({
    this.amount,
    required this.isNegotiable,
    required this.display,
  });

  factory JobSalary.fromJson(Map<String, dynamic> json) {
    return JobSalary(
      amount: (json['amount'] as num?)?.toDouble(),
      isNegotiable: json['is_negotiable'] as bool? ?? false,
      display: json['display'] as String? ?? 'توافقی',
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'is_negotiable': isNegotiable,
        'display': display,
      };
}

class Job {
  final String id;
  final String title;
  final String contractType;
  final String publishedAt;
  final String levelExperience;
  final bool isRemote;
  final JobLocation jobLocation;
  final JobSalary salary;
  final Company company;
  final List<String> skills;
  final List<String> benefits;
  final String? description;

  Job({
    required this.id,
    required this.title,
    required this.contractType,
    required this.publishedAt,
    required this.levelExperience,
    this.isRemote = false,
    required this.jobLocation,
    required this.salary,
    required this.company,
    required this.skills,
    required this.benefits,
    this.description,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    // 1. Parse or recreate the clean Company Object
    Company companyObject;
    if (json['company'] != null) {
      companyObject = Company.fromJson(json['company'] as Map<String, dynamic>);
    } else {
      // Graceful fallback parser if the raw input structure happened to be flat
      companyObject = Company(
        id: (json['company_id'] ?? '').toString(),
        name: json['company_name'] as String? ?? '',
        slug: json['company_slug'] as String? ?? '',
        logo: json['company_logo'] as String?,
        industry: json['company_industry'] as String?,
      );
    }

    // 2. Parse the mandatory JobLocation Object
    JobLocation locationObject;
    if (json['job_location'] != null || json['location'] != null) {
      final locData = (json['job_location'] ?? json['location']) as Map<String, dynamic>;
      locationObject = JobLocation.fromJson(locData);
    } else {
      locationObject = JobLocation(province: '', city: '');
    }

    // 3. Parse the mandatory JobSalary Object
    JobSalary salaryObject;
    if (json['salary'] != null) {
      salaryObject = JobSalary.fromJson(json['salary'] as Map<String, dynamic>);
    } else {
      salaryObject = JobSalary(
        isNegotiable: true,
        display: json['salary_display'] as String? ?? 'توافقی',
      );
    }

    return Job(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      contractType: json['contract_type'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      levelExperience: json['level_experience'] as String? ?? json['experience_level'] as String? ?? '',
      isRemote: json['is_remote'] as bool? ?? false,
      jobLocation: locationObject,
      salary: salaryObject,
      company: companyObject,
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      benefits: (json['benefits'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'contract_type': contractType,
      'published_at': publishedAt,
      'level_experience': levelExperience,
      'is_remote': isRemote,
      'job_location': jobLocation.toJson(),
      'salary': salary.toJson(),
      'company': company.toJson(),
      'skills': skills,
      'benefits': benefits,
      'description': description,
    };
  }

  Job copyWith({
    String? id,
    String? title,
    String? contractType,
    String? publishedAt,
    String? levelExperience,
    bool? isRemote,
    JobLocation? jobLocation,
    JobSalary? salary,
    Company? company,
    List<String>? skills,
    List<String>? benefits,
    String? description,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      contractType: contractType ?? this.contractType,
      publishedAt: publishedAt ?? this.publishedAt,
      levelExperience: levelExperience ?? this.levelExperience,
      isRemote: isRemote ?? this.isRemote,
      jobLocation: jobLocation ?? this.jobLocation,
      salary: salary ?? this.salary,
      company: company ?? this.company,
      skills: skills ?? this.skills,
      benefits: benefits ?? this.benefits,
      description: description ?? this.description,
    );
  }
}