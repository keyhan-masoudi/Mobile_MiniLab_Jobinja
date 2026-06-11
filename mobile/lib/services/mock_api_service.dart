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

  static User? _currentUser;
  // 1. Mock Users
  static final List<Map<String, dynamic>> _mockUsers = [
    {'id': 1, 'name': 'Keyhan', 'email': 'keyhan@gmail.com', 'password': '123456', 'phone': '+98 912 111 1111'},
    {'id': 2, 'name': 'Yousef', 'email': 'usef@gmail.com', 'password': '123456', 'phone': '+98 912 222 2222'},
    {'id': 3, 'name': 'Amirali', 'email': 'amirali@gmail.com', 'password': '123456', 'phone': '+98 912 333 3333'},
  ];

// 2. Mock Companies
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


  // 3. Mock Jobs
  static final List<Map<String, dynamic>> _mockJobs = [
    {
      'id': 'job_1', 'categoryId': 'tech', 'timestamp': 100, 
      'title': 'Senior Flutter Developer', 'company': {'id': 'snapp', 'name': 'Snapp'},
      'location': {'city': 'Tehran'}, 'contract_type': 'Full-time', 'salary': {'display': '60M - 80M Tomans / month'},
      'published_at': '2 hours ago', 'description': 'We are looking for an experienced Flutter developer...',
      'level_experience': 'Senior (3+ years)', 'is_remote': true, 'skills': ['Flutter', 'Dart', 'BLoC'],
      'benefits': ['Flexible working hours', 'Insurance'],
    },
    {
      'id': 'job_2', 'categoryId': 'tech', 'timestamp': 95, 
      'title': 'Backend Software Engineer (Python)', 'company': {'id': 'digikala', 'name': 'Digikala'},
      'location': {'city': 'Tehran'}, 'contract_type': 'Full-time', 'salary': {'display': 'Negotiable'},
      'published_at': '5 hours ago', 'description': 'Join the core logistics team at Digikala...',
      'level_experience': 'Mid-Level', 'is_remote': false, 'skills': ['Python', 'Django', 'Docker'],
      'benefits': ['Performance bonuses', 'Stock options'],
    },
    {
      'id': 'job_3', 'categoryId': 'design', 'timestamp': 90, 
      'title': 'UI/UX Product Designer', 'company': {'id': 'tapsell', 'name': 'Tapsell'},
      'location': {'city': 'Shiraz'}, 'contract_type': 'Part-time', 'salary': {'display': '25M - 35M Tomans'},
      'published_at': '1 day ago', 'description': 'We need a creative Product Designer...',
      'level_experience': 'Junior / Mid-Level', 'is_remote': true, 'skills': ['Figma', 'Adobe XD'],
      'benefits': ['Fully remote framework', 'Flexible time'],
    },
    {
      'id': 'job_4', 'categoryId': 'tech', 'timestamp': 85, 
      'title': 'Android Engineer (Kotlin)', 'company': {'id': 'cafebazaar', 'name': 'Cafe Bazaar'},
      'location': {'city': 'Tehran'}, 'contract_type': 'Full-time', 'salary': {'display': '50M - 70M Tomans / month'},
      'published_at': '2 days ago', 'description': 'Maintain and implement new features...',
      'level_experience': 'Mid-Level', 'is_remote': false, 'skills': ['Kotlin', 'Android SDK'],
      'benefits': ['Comprehensive medical insurance', 'Free internal catering'],
    },
    {
      'id': 'job_5', 'categoryId': 'data', 'timestamp': 80, 
      'title': 'Data Scientist / ML Engineer', 'company': {'id': 'divar', 'name': 'Divar'},
      'location': {'city': 'Mashhad'}, 'contract_type': 'Full-time', 'salary': {'display': '70M - 100M Tomans / month'},
      'published_at': '3 days ago', 'description': 'Help us build a smarter search...',
      'level_experience': 'Senior', 'is_remote': true, 'skills': ['Python', 'Machine Learning', 'TensorFlow'],
      'benefits': ['Remote-first engineering culture', 'Hardware budget'],
    },
    {
      'id': 'job_6', 'categoryId': 'tech', 'timestamp': 75, 
      'title': 'Telecom Security Engineer', 'company': {'id': 'irancell', 'name': 'MTN Irancell'},
      'location': {'city': 'Isfahan'}, 'contract_type': 'Full-time', 'salary': {'display': 'Negotiable'},
      'published_at': '1 week ago', 'description': 'Ensure the absolute perimeter protection...',
      'level_experience': 'Mid-Level', 'is_remote': false, 'skills': ['Cisco Networks', 'Network Security'],
      'benefits': ['Corporate transportation', 'Family insurance'],
    },
    {
      'id': 'job_7', 'categoryId': 'product', 'timestamp': 70, 
      'title': 'Technical Product Manager', 'company': {'id': 'snapp', 'name': 'Snapp'},
      'location': {'city': 'Tehran'}, 'contract_type': 'Full-time', 'salary': {'display': '55M - 80M Tomans / month'},
      'published_at': '1 week ago', 'description': 'Own the strategic lifecycle...',
      'level_experience': 'Senior Specialist', 'is_remote': false, 'skills': ['Agile / Scrum', 'Product Analytics'],
      'benefits': ['Snapp ecosystem credits', 'Quarterly performance payouts'],
    },
    {
      'id': 'job_8', 'categoryId': 'tech', 'timestamp': 65, 
      'title': 'Senior DevOps Engineer', 'company': {'id': 'digikala', 'name': 'Digikala'},
      'location': {'city': 'Mashhad'}, 'contract_type': 'Full-time', 'salary': {'display': '60M - 95M Tomans / month'},
      'published_at': '2 weeks ago', 'description': 'Manage our large-scale on-premise Kubernetes...',
      'level_experience': 'Senior Specialist', 'is_remote': true, 'skills': ['Kubernetes', 'Docker', 'Linux'],
      'benefits': ['Flexible scheduling matrix', 'Corporate equity options'],
    },
    {
      'id': 'job_9', 'categoryId': 'tech', 'timestamp': 60, 
      'title': 'iOS Application Engineer', 'company': {'id': 'divar', 'name': 'Divar'},
      'location': {'city': 'Tehran'}, 'contract_type': 'Full-time', 'salary': {'display': '50M - 75M Tomans / month'},
      'published_at': '2 weeks ago', 'description': 'Join the Divar iOS squad...',
      'level_experience': 'Mid-Level', 'is_remote': true, 'skills': ['Swift Programming', 'iOS Core Frameworks'],
      'benefits': ['Work from anywhere capability', 'Apple hardware refresh'],
    },
    {
      'id': 'job_10', 'categoryId': 'tech', 'timestamp': 55, 
      'title': 'Junior QA Automation', 'company': {'id': 'tapsell', 'name': 'Tapsell'},
      'location': {'city': 'Shiraz'}, 'contract_type': 'Full-time', 'salary': {'display': '18M - 25M Tomans'},
      'published_at': '3 weeks ago', 'description': 'Kickstart your engineering career in QA...',
      'level_experience': 'Junior / Graduate', 'is_remote': false, 'skills': ['Manual Testing basics', 'Selenium'],
      'benefits': ['Dedicated mentorship path', 'Clear promotional career tracks'],
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

      // Create the user object
      final loggedInUser = User(
        id: userJson['id'], 
        name: userJson['name'],
        email: userJson['email'],
        phone: userJson['phone'],
      );

      // SAVE the user locally in the service memory!
      _currentUser = loggedInUser;

      return MockApiResponse(
        success: true,
        data: loggedInUser,
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

Future<MockApiResponse> getJobCategories() async {
    return MockApiResponse(
      success: true,
      data: [
        {'id': 'tech', 'name': 'Software & Engineering'},
        {'id': 'design', 'name': 'Design & UI/UX'},
        {'id': 'data', 'name': 'Data Science & AI'},
        {'id': 'product', 'name': 'Product Management'},
      ],
    );
  }

  Future<MockApiResponse> getLocations() async {
    return MockApiResponse(
      success: true,
      data: ['All', 'Tehran', 'Mashhad', 'Isfahan', 'Shiraz', 'Remote'],
    );
  }

  // getJobs: Now wraps the List<Job> inside MockJobPagination!
Future<MockApiResponse> getJobs({int page = 1, String? keyword, String? location, String? sortBy, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network latency

    // Start with all raw data so we can access hidden fields like categoryId and timestamp
    List<Map<String, dynamic>> filteredRawJobs = List.from(_mockJobs);

    // 1. Keyword Filter (Search by Title or Company Name)
    if (keyword != null && keyword.trim().isNotEmpty) {
      filteredRawJobs = filteredRawJobs.where((j) => 
        j['title'].toString().toLowerCase().contains(keyword.toLowerCase()) || 
        j['company']['name'].toString().toLowerCase().contains(keyword.toLowerCase())
      ).toList();
    }

    // 2. Location & Remote Filter
    if (location != null && location.isNotEmpty && location != 'All') {
      if (location.toLowerCase() == 'remote') {
        filteredRawJobs = filteredRawJobs.where((j) => j['is_remote'] == true).toList();
      } else {
        filteredRawJobs = filteredRawJobs.where((j) => 
          j['location']['city'].toString().toLowerCase() == location.toLowerCase()
        ).toList();
      }
    }

    // 3. Category Filter (Using the hidden categoryId)
    if (category != null && category.isNotEmpty && category != 'All') {
      // Assuming 'category' passed from UI is the ID (e.g., 'tech', 'design')
      filteredRawJobs = filteredRawJobs.where((j) => j['categoryId'] == category).toList();
    }

    // 4. Sorting Filter (Using the hidden timestamp)
    if (sortBy != null && sortBy.isNotEmpty) {
      if (sortBy == 'newest') {
        filteredRawJobs.sort((a, b) => b['timestamp'].compareTo(a['timestamp'])); // Descending
      } else if (sortBy == 'oldest') {
        filteredRawJobs.sort((a, b) => a['timestamp'].compareTo(b['timestamp'])); // Ascending
      }
    }

    // Finally, convert the filtered raw maps into Job models
    List<Job> finalJobs = filteredRawJobs.map((json) => Job.fromJson(json)).toList();

    // Handle Pagination (Empty list if page > 1 since we only have 10 items)
    if (page > 1) {
      return MockApiResponse(
        success: true, 
        data: MockJobPagination(data: [], currentPage: page, lastPage: 1)
      );
    }

    return MockApiResponse(
      success: true, 
      data: MockJobPagination(data: finalJobs, currentPage: page, lastPage: 1)
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
    
    // If no one is logged in, default to Keyhan so your app doesn't crash on start
    final activeUser = _currentUser ?? User(id: 1, name: 'Keyhan', email: 'keyhan@example.com', phone: '+98 912 111 1111');

    return MockApiResponse(
      success: true, 
      data: activeUser,
    );
  }

  Future<MockApiResponse> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null; // Clear the session on logout
    return MockApiResponse(success: true);
  }

  Future<MockApiResponse> getAppliedJobs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockApiResponse(success: true, data: [Job.fromJson(_mockJobs[0])]);
  }
}