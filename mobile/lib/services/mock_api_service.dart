// lib/services/mock_api_service.dart

import '../models/job.dart';
import '../models/user.dart';
import '../models/company.dart';
import '../models/api_response.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';

class MockApiService {
  // شبیه‌سازی تاخیر شبکه برای واقعی‌تر شدن رفتار اپلیکیشن
  static Future<void> _delay() => Future.delayed(const Duration(milliseconds: 800));

  static final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'کاربر تست',
      'email': 'test@example.com',
      'password': '123456',
      'token': 'mock_token_123',
    },
  ];

  // لیست شناسه‌های مشاغلی که کاربر فعلی برای آن‌ها رزومه ارسال کرده است
  final List<String> _appliedJobIds = [];

  // POST /api/auth/signup
  Future<ApiResponse<User>> signup(SignupRequest request) async {
    await _delay();
    final exists = _users.any((u) => u['email'] == request.email);
    if (exists) {
      return ApiResponse.error('این ایمیل قبلاً ثبت شده است');
    }
    final newUser = {
      'id': _users.length + 1,
      'name': request.name,
      'email': request.email,
      'password': request.password,
      'token': 'mock_token_${_users.length + 1}',
    };
    _users.add(newUser);
    final user = User(
      id: newUser['id'] as int,
      name: newUser['name'] as String,
      email: newUser['email'] as String,
      token: newUser['token'] as String,
    );
    return ApiResponse.success(user);
  }

  // POST /api/auth/login
  Future<ApiResponse<User>> login(LoginRequest request) async {
    await _delay();
    try {
      final found = _users.firstWhere(
        (u) => u['email'] == request.email && u['password'] == request.password,
      );
      final user = User(
        id: found['id'] as int,
        name: found['name'] as String,
        email: found['email'] as String,
        token: found['token'] as String,
      );
      return ApiResponse.success(user);
    } catch (_) {
      return ApiResponse.error('ایمیل یا رمز عبور اشتباه است', statusCode: 401);
    }
  }

  // POST /api/auth/logout
  Future<ApiResponse<bool>> logout() async {
    await _delay();
    return ApiResponse.success(true);
  }

  // GET /api/jobs?keyword=&location=&page=
  Future<ApiResponse<PaginatedResponse<Job>>> getJobs({
    int page = 1,
    String? keyword,
    String? location,
    String? category,
    String? sortBy,
  }) async {
    await _delay();
    var jobs = _mockJobs();

    if (keyword != null && keyword.isNotEmpty) {
      jobs = jobs.where((j) => 
        j.title.contains(keyword) || 
        j.company.name.contains(keyword) // استفاده صحیح از شیء Company
      ).toList();
    }
    if (location != null && location.isNotEmpty) {
      jobs = jobs.where((j) => 
        j.jobLocation.province.contains(location) || 
        j.jobLocation.city.contains(location)
      ).toList();
    }

    const perPage = 20;
    final total = jobs.length;
    final lastPage = (total / perPage).ceil();
    final start = (page - 1) * perPage;
    final end = (start + perPage).clamp(0, total);
    final pageJobs = jobs.sublist(start.clamp(0, total), end);

    return ApiResponse.success(
      PaginatedResponse<Job>(
        data: pageJobs,
        currentPage: page,
        lastPage: lastPage < 1 ? 1 : lastPage,
        perPage: perPage,
        total: total,
      ),
    );
  }

  // GET /api/jobs/{id}
  Future<ApiResponse<Job>> getJobDetail(String id) async {
    await _delay();
    try {
      final job = _mockJobs().firstWhere((j) => j.id == id);
      return ApiResponse.success(job);
    } catch (_) {
      return ApiResponse.error('شغل یافت نشد', statusCode: 404);
    }
  }

  // POST /api/v10/jobseeker-app/applications/{app_id} (ارسال رزومه)
  Future<ApiResponse<bool>> applyForJob(String jobId) async {
    await _delay();
    if (!_appliedJobIds.contains(jobId)) {
      _appliedJobIds.add(jobId);
      return ApiResponse.success(true);
    }
    return ApiResponse.error('شما قبلاً برای این شغل رزومه ارسال کرده‌اید');
  }

  // GET /api/user/applied-jobs
  Future<ApiResponse<List<Job>>> getAppliedJobs() async {
    await _delay();
    final allJobs = _mockJobs();
    final applied = allJobs.where((j) => _appliedJobIds.contains(j.id)).toList();
    return ApiResponse.success(applied);
  }

  // GET /api/companies/{slug}
  Future<ApiResponse<Company>> getCompany(String slug) async {
    await _delay();
    try {
      final company = _mockCompanies().firstWhere((c) => c.slug == slug);
      return ApiResponse.success(company);
    } catch (_) {
      return ApiResponse.error('شرکت یافت نشد', statusCode: 404);
    }
  }

  // GET /api/companies/{slug}/jobs
  Future<ApiResponse<List<Job>>> getCompanyJobs(String slug) async {
    await _delay();
    final jobs = _mockJobs().where((j) => j.company.slug == slug).toList();
    return ApiResponse.success(jobs);
  }

  // GET /api/user/profile
  Future<ApiResponse<User>> getUserProfile() async {
    await _delay();
    final user = User(
      id: 1,
      name: 'کاربر تست',
      email: 'test@example.com',
      phone: '09123456789',
    );
    return ApiResponse.success(user);
  }

  // GET /api/jobs/categories
  Future<ApiResponse<List<Map<String, dynamic>>>> getJobCategories() async {
    await _delay();
    return ApiResponse.success([
      {'id': 1, 'name': 'وب، برنامه‌نویسی و نرم‌افزار'},
      {'id': 2, 'name': 'طراحی و تجربه کاربری'},
      {'id': 8, 'name': 'مهندسی و فناوری'},
    ]);
  }

  // GET /api/jobs/locations
  Future<ApiResponse<List<String>>> getLocations() async {
    await _delay();
    return ApiResponse.success(['تهران', 'اصفهان', 'شیراز', 'مشهد', 'تبریز']);
  }

  // ─── Mock Data Generators ──────────────────────────────────────────────────

  static List<Company> _mockCompanies() {
    return [
      Company(
        id: 'company_1',
        name: 'شرکت نمونه',
        slug: 'sample-company',
        industry: 'کامپیوتر، فناوری اطلاعات و اینترنت',
        size: '۵۰ تا ۲۰۰ نفر',
        description: 'شرکت نمونه یک شرکت فناوری پیشرو در ایران است.',
        website: 'https://sample-company.ir',
        location: 'تهران',
        jobCount: 5,
      ),
      Company(
        id: 'company_2',
        name: 'دیجی‌کالا',
        slug: 'digikala',
        industry: 'تجارت الکترونیک',
        size: 'بیش از ۱۰۰۰ نفر',
        description: 'دیجی‌کالا بزرگ‌ترین فروشگاه اینترنتی ایران است.',
        website: 'https://digikala.com',
        location: 'تهران',
        jobCount: 45,
      ),
      Company(
        id: 'company_3',
        name: 'اسنپ',
        slug: 'snapp',
        industry: 'حمل‌ونقل و لجستیک',
        size: '۵۰۰ تا ۱۰۰۰ نفر',
        description: 'اسنپ پلتفرم جامع حمل‌ونقل آنلاین.',
        website: 'https://snapp.ir',
        location: 'تهران',
        jobCount: 30,
      ),
    ];
  }

  static List<Job> _mockJobs() {
    final companies = _mockCompanies();
    return [
      Job(
        id: 'job_1',
        title: 'توسعه‌دهنده پایتون',
        contractType: 'تمام‌وقت',
        publishedAt: '۱۴۰۵/۰۳/۱۰',
        levelExperience: 'کمتر از سه سال',
        isRemote: false,
        jobLocation: JobLocation(province: 'تهران', city: 'تهران'),
        salary: JobSalary(isNegotiable: true, display: 'حقوق توافقی'),
        company: companies[0], // Single Source of Truth
        skills: ['Python', 'Django', 'REST API', 'PostgreSQL'],
        benefits: ['بیمه تکمیلی', 'پاداش', 'ساعت کاری انعطاف‌پذیر'],
      ),
      Job(
        id: 'job_2',
        title: 'توسعه‌دهنده Flutter',
        contractType: 'تمام‌وقت',
        publishedAt: '۱۴۰۵/۰۳/۰۸',
        levelExperience: 'سه تا شش سال',
        isRemote: false,
        jobLocation: JobLocation(province: 'تهران', city: 'تهران'),
        salary: JobSalary(isNegotiable: false, display: '۱۵ تا ۲۵ میلیون تومان', amount: 20000000),
        company: companies[1],
        skills: ['Flutter', 'Dart', 'BLoC', 'REST API'],
        benefits: ['بیمه تکمیلی', 'ناهار', 'سرویس'],
      ),
      Job(
        id: 'job_3',
        title: 'مهندس بک‌اند Node.js',
        contractType: 'تمام‌وقت',
        publishedAt: '۱۴۰۵/۰۳/۰۵',
        levelExperience: 'سه تا شش سال',
        isRemote: true,
        jobLocation: JobLocation(province: 'تهران', city: 'تهران'),
        salary: JobSalary(isNegotiable: false, display: '۲۰ تا ۳۵ میلیون تومان', amount: 28000000),
        company: companies[2],
        skills: ['Node.js', 'TypeScript', 'MongoDB', 'Docker'],
        benefits: ['دورکاری', 'بیمه تکمیلی', 'پاداش سالانه'],
      ),
    ];
  }
}