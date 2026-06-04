// lib/services/mock_api_service.dart

import '../models/job.dart';
import '../models/company.dart';
import '../models/user.dart';

// --- HELPER CLASSES ---

// 1. Matches the response format your Presenters expect
class MockApiResponse {
  final bool success;
  final dynamic data;
  final String? message;

  MockApiResponse({required this.success, this.data, this.message});
}

// 2. Matches the Pagination format your JobListPresenter expects
class MockJobPagination {
  final List<Job> data;
  final int currentPage;
  final int lastPage;

  MockJobPagination({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });
}

class MockApiService {
  // --- MOCK DATABASE ---

  // 1. Mock Users
  static final List<Map<String, dynamic>> _mockUsers = [
    {'id': 1, 'name': 'Keyhan', 'email': 'keyhan@example.com', 'password': 'password123', 'phone': '+98 912 111 1111'},
    {'id': 2, 'name': 'Yousef', 'email': 'yousef@example.com', 'password': 'password123', 'phone': '+98 912 222 2222'},
    {'id': 3, 'name': 'Amirali', 'email': 'amirali@example.com', 'password': 'password123', 'phone': '+98 912 333 3333'},
  ];

// 2. Mock Companies (Increased to 6 corporate profiles)
  static final List<Map<String, dynamic>> _mockCompanies = [
    {
      'id': 'snapp',
      'name': 'Snapp',
      'industry': 'Information Technology & Super-Apps',
      'location': 'Tehran, Iran',
      'size': '1000+ employees',
      'jobCount': 24,
      'website': 'https://snapp.ir',
      'description': 'Snapp is the leading ride-hailing app in the Middle East and a pioneer in the super-app industry. We provide everyday digital solutions including food delivery, logistics, flights, and fintech services to millions of active users.',
    },
    {
      'id': 'digikala',
      'name': 'Digikala',
      'industry': 'E-commerce & Logistics',
      'location': 'Tehran, Iran',
      'size': '5000+ employees',
      'jobCount': 45,
      'website': 'https://digikala.com',
      'description': 'Digikala is the largest e-commerce ecosystem in the region, operating massive online marketplaces, full-scale logistics fleets, and digital content platforms focusing on customer-centric technology.',
    },
    {
      'id': 'tapsell',
      'name': 'Tapsell',
      'industry': 'Digital Advertising & Ad-Tech',
      'location': 'Tehran, Iran',
      'size': '200-500 employees',
      'jobCount': 8,
      'website': 'https://tapsell.ir',
      'description': 'Tapsell is a leading ad-tech network helping mobile application and web developers monetize their platforms through intelligent, data-driven, and highly optimized programmatic advertising solutions.',
    },
    {
      'id': 'cafebazaar',
      'name': 'Cafe Bazaar',
      'industry': 'Mobile App Store & Digital Services',
      'location': 'Tehran, Iran',
      'size': '500-1000 employees',
      'jobCount': 15,
      'website': 'https://cafebazaar.ir',
      'description': 'Cafe Bazaar is the premier local Android application marketplace in Iran, connecting tens of millions of smartphone users with thousands of software developers and creators nationwide.',
    },
    {
      'id': 'divar',
      'name': 'Divar',
      'industry': 'Online Classifieds & P2P Marketplace',
      'location': 'Tehran, Iran',
      'size': '500-1000 employees',
      'jobCount': 12,
      'website': 'https://divar.ir',
      'description': 'Divar is the largest peer-to-peer classified advertisements platform in Iran. We facilitate millions of daily local trading interactions across real estate, vehicles, goods, and employment services.',
    },
    {
      'id': 'irancell',
      'name': 'MTN Irancell',
      'industry': 'Telecommunications & Network Services',
      'location': 'Tehran, Iran',
      'size': '1000+ employees',
      'jobCount': 30,
      'website': 'https://irancell.ir',
      'description': 'MTN Irancell is a leading digital network provider and the second-largest mobile operator in Iran, delivering advanced high-speed mobile internet infrastructure, corporate data, and digital services.',
    }
  ];

  // 3. Mock Jobs (Increased to 10 highly detailed positions)
  static final List<Map<String, dynamic>> _mockJobs = [
    {
      'id': 'job_1',
      'title': 'Senior Flutter Developer',
      'company': {'id': 'snapp', 'name': 'Snapp'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '60M - 80M Tomans / month'},
      'published_at': '2 hours ago',
      'description': 'We are looking for an experienced Flutter developer to join our Super App mobile core team. You will be responsible for architecting high-performance modules and micro-frontends handled by millions of concurrent users.',
      'level_experience': 'Senior (3+ years)',
      'is_remote': true,
      'skills': ['Flutter', 'Dart', 'BLoC State Management', 'Clean Architecture', 'Git', 'CI/CD Pipelines'],
      'benefits': ['Flexible working hours', 'Supplementary health insurance', 'Free daily lunch', 'Gym corporate discount', 'Snapp travel credits'],
    },
    {
      'id': 'job_2',
      'title': 'Backend Software Engineer (Python)',
      'company': {'id': 'digikala', 'name': 'Digikala'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': 'Negotiable'},
      'published_at': '5 hours ago',
      'description': 'Join the core inventory and supply chain logistics team at Digikala. You will design, implement, and maintain low-latency distributed microservices to manage high-volume order updates and routing logic.',
      'level_experience': 'Mid-Level / Senior',
      'is_remote': false,
      'skills': ['Python', 'Django', 'FastAPI', 'PostgreSQL', 'Docker', 'Redis Caching', 'Microservices'],
      'benefits': ['Performance bonuses', 'Stock options', 'Professional training budget', 'On-site relaxation/games room', 'DigiPlus membership perks'],
    },
    {
      'id': 'job_3',
      'title': 'UI/UX Product Designer',
      'company': {'id': 'tapsell', 'name': 'Tapsell'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Part-time',
      'salary': {'display': '25M - 35M Tomans'},
      'published_at': '1 day ago',
      'description': 'We need a creative Product Designer to rethink our real-time marketing analytics dashboard. You will conduct user research, construct wireframes, and map complex data visualizations into highly intuitive layouts.',
      'level_experience': 'Junior / Mid-Level',
      'is_remote': true,
      'skills': ['Figma', 'Adobe XD', 'Interactive Prototyping', 'User Research', 'Design Systems management'],
      'benefits': ['Fully remote framework', 'Flexible time management', 'Friendly team environment', 'Educational books allowance'],
    },
    {
      'id': 'job_4',
      'title': 'Android Engineer (Kotlin)',
      'company': {'id': 'cafebazaar', 'name': 'Cafe Bazaar'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '50M - 70M Tomans / month'},
      'published_at': '2 days ago',
      'description': 'Maintain and implement new features for the native Cafe Bazaar Android client. You will solve platform compatibility challenges, optimize local storage mechanisms, and build flawless reactive application flows.',
      'level_experience': 'Mid-Level (2+ years)',
      'is_remote': false,
      'skills': ['Kotlin', 'Android SDK', 'Jetpack Compose', 'MVVM/MVI Patterns', 'Coroutines & Flow', 'Dagger Hilt Dependency Injection'],
      'benefits': ['Comprehensive medical insurance', 'Free internal catering (Breakfast & Lunch)', 'Modern workspace layout', 'Tech equipment provision'],
    },
    {
      'id': 'job_5',
      'title': 'Data Scientist / Machine Learning Engineer',
      'company': {'id': 'divar', 'name': 'Divar'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '70M - 100M Tomans / month'},
      'published_at': '3 days ago',
      'description': 'Help us build a smarter search and anti-fraud classifieds system. You will build computer vision and NLP models to detect fraudulent item submissions, auto-categorize uploads, and optimize recommendations.',
      'level_experience': 'Senior (4+ years)',
      'is_remote': true,
      'skills': ['Python', 'Machine Learning', 'TensorFlow / PyTorch', 'SQL Data Extraction', 'BigQuery', 'Natural Language Processing'],
      'benefits': ['Remote-first engineering culture', 'Premium supplementary coverage', 'Annual developer conferences access', 'High-end hardware budget'],
    },
    {
      'id': 'job_6',
      'title': 'Telecom Core Network Security Engineer',
      'company': {'id': 'irancell', 'name': 'MTN Irancell'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': 'Negotiable'},
      'published_at': '1 week ago',
      'description': 'Ensure the absolute perimeter protection and load integrity of our nation-wide infrastructure. You will manage enterprise firewalls, conduct active network vulnerability scans, and resolve security incident alerts.',
      'level_experience': 'Mid-Level / Senior',
      'is_remote': false,
      'skills': ['Cisco Networks', 'Network Security Architecture', 'Next-Gen Firewalls', 'CCNP / CCIE certification', 'Linux Administration', 'SIEM Systems'],
      'benefits': ['Corporate transportation support', 'Family insurance tier', 'Project completion bonuses', 'Complimentary internal internet package'],
    },
    {
      'id': 'job_7',
      'title': 'Technical Product Manager',
      'company': {'id': 'snapp', 'name': 'Snapp'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '55M - 80M Tomans / month'},
      'published_at': '1 week ago',
      'description': 'Own the strategic lifecycle of the Snapp Food dispatching system. You will gather cross-functional requirements, manage backlogs, translate complex business parameters into explicit user stories, and drive Agile sprints.',
      'level_experience': 'Senior Specialist',
      'is_remote': false,
      'skills': ['Agile / Scrum Methodologies', 'Product Analytics (Mixpanel/GA)', 'Jira Management', 'Technical Architecture mapping', 'A/B Testing execution'],
      'benefits': ['Snapp ecosystem credits', 'Executive healthcare tiers', 'Catered on-site meals', 'Quarterly performance payouts'],
    },
    {
      'id': 'job_8',
      'title': 'Senior DevOps / Cloud Platform Engineer',
      'company': {'id': 'digikala', 'name': 'Digikala'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '60M - 95M Tomans / month'},
      'published_at': '2 weeks ago',
      'description': 'We are looking for an expert to manage our large-scale on-premise Kubernetes clusters and cloud migrations. You will maximize server uptime, build resilient CI/CD flows, and enforce Infrastructure as Code patterns.',
      'level_experience': 'Senior Specialist',
      'is_remote': true,
      'skills': ['Kubernetes clustering', 'Docker Containers', 'Linux Systems Architecture', 'Jenkins / GitLab CI', 'Prometheus & Grafana Tracking', 'Ansible / Terraform'],
      'benefits': ['Flexible scheduling matrix', 'Partial work-from-home framework', 'Corporate equity options', 'Premium family health program'],
    },
    {
      'id': 'job_9',
      'title': 'iOS Application Engineer (Swift)',
      'company': {'id': 'divar', 'name': 'Divar'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '50M - 75M Tomans / month'},
      'published_at': '2 weeks ago',
      'description': 'Join the Divar iOS squad to construct ultra-smooth native views. You will navigate around platform constraints to deploy scalable architectures, optimizing image caching, search filtering responsiveness, and storage protocols.',
      'level_experience': 'Mid-Level',
      'is_remote': true,
      'skills': ['Swift Programming', 'iOS Core Frameworks', 'SwiftUI & Combine', 'UIKit legacy support', 'Local Data Caching architecture', 'XCode Performance analysis'],
      'benefits': ['Work from anywhere capability', 'Apple hardware refresh cycle allowance', 'Full medical and dentistry options'],
    },
    {
      'id': 'job_10',
      'title': 'Junior QA Automation / Tester',
      'company': {'id': 'tapsell', 'name': 'Tapsell'},
      'location': {'city': 'Tehran'},
      'contract_type': 'Full-time',
      'salary': {'display': '18M - 25M Tomans'},
      'published_at': '3 weeks ago',
      'description': 'Kickstart your engineering career in Quality Assurance. You will write automated integration and UI scripts using Appium or Selenium, discover application defects, write diagnostic bug tracking reports, and audit application releases.',
      'level_experience': 'Junior / Graduate',
      'is_remote': false,
      'skills': ['Manual Testing basics', 'Automated scripting foundations', 'Selenium / Appium toolsets', 'Bug tracking pipelines (Jira)', 'Basic Python or JS syntax'],
      'benefits': ['Dedicated mentorship path', 'Clear promotional career tracks', 'Young and collaborative team space'],
    }
  ];

  // --- API METHODS ---

  Future<MockApiResponse> login(dynamic request) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    try {
      final String email = request['email'].toString().toLowerCase().trim();
      final String password = request['password'].toString();

      final userJson = _mockUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );

      return MockApiResponse(
        success: true,
        data: User(
          id: userJson['id'], 
          name: userJson['name'],
          email: userJson['email'],
          phone: userJson['phone'],
        ),
        message: 'Login successful',
      );
    } catch (e) {
      return MockApiResponse(
        success: false,
        message: 'Invalid email or password. Please try again.',
      );
    }
  }

  Future<MockApiResponse> signup(dynamic request) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockApiResponse(
      success: true,
      data: User(id: DateTime.now().millisecondsSinceEpoch, name: 'New User', email: 'test@example.com'),
      message: 'Signup successful',
    );
  }

  Future<MockApiResponse> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockApiResponse(success: true);
  }

  Future<MockApiResponse> getJobCategories() async {
    return MockApiResponse(
      success: true,
      data: [{'id': '1', 'name': 'Software Engineering'}, {'id': '2', 'name': 'Design'}],
    );
  }

  Future<MockApiResponse> getLocations() async {
    return MockApiResponse(
      success: true,
      data: ['Tehran', 'Mashhad', 'Isfahan', 'Shiraz', 'Remote'],
    );
  }

  // UPDATED getJobs: Now wraps the List<Job> inside MockJobPagination!
  Future<MockApiResponse> getJobs({int page = 1, String? keyword, String? location, String? sortBy, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Convert to Job models
    List<Job> filteredJobs = _mockJobs.map((json) => Job.fromJson(json)).toList();

    // Mock search logic
    if (keyword != null && keyword.isNotEmpty) {
      filteredJobs = filteredJobs.where((j) => 
        j.title.toLowerCase().contains(keyword.toLowerCase()) || 
        j.company.name.toLowerCase().contains(keyword.toLowerCase())
      ).toList();
    }

    // If page is greater than 1, return an empty pagination object
    if (page > 1) {
      return MockApiResponse(
        success: true, 
        data: MockJobPagination(data: [], currentPage: page, lastPage: 1)
      );
    }

    // Return the correctly wrapped paginated data
    return MockApiResponse(
      success: true, 
      data: MockJobPagination(data: filteredJobs, currentPage: page, lastPage: 1)
    );
  }

  Future<MockApiResponse> getJobDetail(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final jobJson = _mockJobs.firstWhere((j) => j['id'] == jobId);
    return MockApiResponse(success: true, data: Job.fromJson(jobJson));
  }

  Future<MockApiResponse> applyForJob(String jobId) async {
    await Future.delayed(const Duration(seconds: 1));
    return MockApiResponse(success: true, message: 'Application submitted successfully');
  }

  Future<MockApiResponse> getCompany(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final companyJson = _mockCompanies.firstWhere((c) => c['id'] == companyId);
    return MockApiResponse(success: true, data: Company.fromJson(companyJson));
  }

  Future<MockApiResponse> getCompanyJobs(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final companyJobs = _mockJobs.where((j) => j['company']['id'] == companyId).toList();
    return MockApiResponse(success: true, data: companyJobs.map((json) => Job.fromJson(json)).toList());
  }

  Future<MockApiResponse> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockApiResponse(
      success: true, 
      data: User(id: 1, name: 'Keyhan', email: 'keyhan@example.com', phone: '+98 912 111 1111')
    );
  }

  Future<MockApiResponse> getAppliedJobs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockApiResponse(success: true, data: [Job.fromJson(_mockJobs[0])]);
  }
}