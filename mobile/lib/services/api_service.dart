// lib/services/api_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';
import '../models/user.dart';
import '../models/company.dart';
import '../models/api_response.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../utils/constants.dart';

class ApiService {
  final String baseUrl;
  String? _token;

  ApiService({this.baseUrl = Constants.mockBaseUrl});

  // Inject the authentication token for protected routes
  void setToken(String token) {
    _token = token;
  }

  // Remove the token when logging out
  void clearToken() {
    _token = null;
  }

  // Generates headers, including the Authorization Bearer token if it exists
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // POST /api/auth/signup
  Future<ApiResponse<User>> signup(SignupRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/signup'),
            headers: _headers,
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = User.fromJson(body['data'] as Map<String, dynamic>? ?? body);
        return ApiResponse.success(user);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Registration failed',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // POST /api/auth/login
  Future<ApiResponse<User>> login(LoginRequest request) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: _headers,
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final user = User.fromJson(body['data'] as Map<String, dynamic>? ?? body);
        return ApiResponse.success(user);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Incorrect email or password',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // POST /api/auth/logout
  Future<ApiResponse<bool>> logout() async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error('Failed to log out');
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/jobs?keyword=&location=&page=
  Future<ApiResponse<PaginatedResponse<Job>>> getJobs({
    int page = 1,
    String? keyword,
    String? location,
    String? category,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (location != null && location.isNotEmpty) 'location': location,
        if (category != null && category.isNotEmpty) 'category': category,
        if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      };

      final uri = Uri.parse('$baseUrl/jobs').replace(queryParameters: queryParams);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final paginated = PaginatedResponse.fromJson(body, Job.fromJson);
        return ApiResponse.success(paginated);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Failed to load jobs',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/jobs/{id}
  Future<ApiResponse<Job>> getJobDetail(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/jobs/$id'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final job = Job.fromJson(body['data'] as Map<String, dynamic>? ?? body);
        return ApiResponse.success(job);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Job not found',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // POST /api/applications/{jobId} (Added to support the application logic)
  Future<ApiResponse<bool>> applyForJob(String jobId) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl/applications/$jobId'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      }
      
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ApiResponse.error(
        body['message'] as String? ?? 'Failed to submit application',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/companies/{slug}
  Future<ApiResponse<Company>> getCompany(String slug) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/companies/$slug'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final company = Company.fromJson(
          body['data'] as Map<String, dynamic>? ?? body,
        );
        return ApiResponse.success(company);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Company not found',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/companies/{slug}/jobs
  Future<ApiResponse<List<Job>>> getCompanyJobs(String slug) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/companies/$slug/jobs'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final jobs = (body['data'] as List<dynamic>? ?? [])
            .map((e) => Job.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(jobs);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Failed to load company jobs',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/user/profile
  Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/user/profile'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final user = User.fromJson(body['data'] as Map<String, dynamic>? ?? body);
        return ApiResponse.success(user);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Failed to load profile',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/user/applied-jobs
  Future<ApiResponse<List<Job>>> getAppliedJobs() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/user/applied-jobs'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final jobs = (body['data'] as List<dynamic>? ?? [])
            .map((e) => Job.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(jobs);
      }
      return ApiResponse.error(
        body['message'] as String? ?? 'Failed to load applied jobs',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/jobs/categories
  Future<ApiResponse<List<Map<String, dynamic>>>> getJobCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/jobs/categories'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = body is List
            ? body.map((e) => e as Map<String, dynamic>).toList()
            : (body['data'] as List<dynamic>? ?? [])
                .map((e) => e as Map<String, dynamic>)
                .toList();
        return ApiResponse.success(list);
      }
      return ApiResponse.error('Failed to load categories');
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/jobs/locations
  Future<ApiResponse<List<String>>> getLocations() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/jobs/locations'), headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = body is List
            ? body.map((e) => e.toString()).toList()
            : (body['data'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .toList();
        return ApiResponse.success(list);
      }
      return ApiResponse.error('Failed to load locations');
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // GET /api/job-skills/search?q=
  Future<ApiResponse<List<String>>> searchSkills(String query) async {
    try {
      final uri = Uri.parse('$baseUrl/job-skills/search').replace(
        queryParameters: {'q': query},
      );
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final list = body is List
            ? body.map((e) => (e['name'] ?? e).toString()).toList()
            : (body['data'] as List<dynamic>? ?? [])
                .map((e) => (e['name'] ?? e).toString())
                .toList();
        return ApiResponse.success(list);
      }
      return ApiResponse.error('Failed to search skills');
    } catch (e) {
      return ApiResponse.error(_handleException(e));
    }
  }

  // Consolidates network and timeout errors into user-friendly English messages
  String _handleException(dynamic e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Connection refused')) {
      return 'No internet connection or server is unreachable.';
    }
    if (msg.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}