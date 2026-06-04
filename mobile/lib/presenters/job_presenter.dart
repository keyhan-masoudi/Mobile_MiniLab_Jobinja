// lib/presenters/job_presenter.dart

import '../models/job.dart';
import '../services/mock_api_service.dart';

// ─── CONTRACTS ────────────────────────────────────────────────────────────

abstract class JobListViewContract {
  void showLoading();
  void hideLoading();
  void onJobsLoaded(List<Job> jobs, int currentPage, int lastPage);
  void showError(String message);
}

abstract class JobDetailViewContract {
  void showLoading();
  void hideLoading();
  void onJobDetailLoaded(Job job);
  void onApplySuccess(String message);
  void showError(String message);
}

// ─── LIST PRESENTER (For Home Screen) ─────────────────────────────────────

class JobListPresenter {
  final JobListViewContract _view;
  final MockApiService _apiService;

  JobListPresenter(this._view) : _apiService = MockApiService();

  // Fetches paginated jobs with optional search and filter parameters
  Future<void> loadJobs({
    int page = 1,
    String? keyword,
    String? location,
    String? category,
    String? sortBy,
  }) async {
    _view.showLoading();
    try {
      final response = await _apiService.getJobs(
        page: page,
        keyword: keyword,
        location: location,
        category: category,
        sortBy: sortBy,
      );
      
      _view.hideLoading();
      
      if (response.success && response.data != null) {
        final paginated = response.data!;
        _view.onJobsLoaded(paginated.data, paginated.currentPage, paginated.lastPage);
      } else {
        _view.showError(response.message ?? 'Failed to load jobs');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Helper method to populate filter dropdowns
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _apiService.getJobCategories();
    return response.data ?? [];
  }

  // Helper method to populate location dropdowns
  Future<List<String>> getLocations() async {
    final response = await _apiService.getLocations();
    return response.data ?? [];
  }
}

// ─── DETAIL PRESENTER (For Job Detail Screen) ─────────────────────────────

class JobDetailPresenter {
  final JobDetailViewContract _view;
  final MockApiService _apiService;

  JobDetailPresenter(this._view) : _apiService = MockApiService();

  // Fetches the full data of a single job
  Future<void> loadJobDetail(String id) async {
    _view.showLoading();
    try {
      final response = await _apiService.getJobDetail(id);
      
      _view.hideLoading();
      
      if (response.success && response.data != null) {
        _view.onJobDetailLoaded(response.data!);
      } else {
        _view.showError(response.message ?? 'Job not found');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Sends the user's resume/application to the mock server
  Future<void> applyForJob(String jobId) async {
    _view.showLoading();
    try {
      final response = await _apiService.applyForJob(jobId);
      
      _view.hideLoading();
      
      if (response.success) {
        _view.onApplySuccess('Resume submitted successfully!');
      } else {
        _view.showError(response.message ?? 'Failed to submit application');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }
}