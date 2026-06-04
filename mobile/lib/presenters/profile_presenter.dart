// lib/presenters/profile_presenter.dart

import '../models/user.dart';
import '../models/job.dart';
import '../services/mock_api_service.dart';

// Contract defining UI methods for the Profile screen
abstract class ProfileViewContract {
  void showLoading();
  void hideLoading();
  void onProfileLoaded(User user);
  void onAppliedJobsLoaded(List<Job> jobs);
  void showError(String message);
}

class ProfilePresenter {
  final ProfileViewContract _view;
  final MockApiService _apiService;

  ProfilePresenter(this._view) : _apiService = MockApiService();

  // Fetches user profile data from the server
  Future<void> loadProfile() async {
    _view.showLoading();
    try {
      final response = await _apiService.getUserProfile();
      
      _view.hideLoading();
      
      if (response.success && response.data != null) {
        _view.onProfileLoaded(response.data!);
      } else {
        _view.showError(response.message ?? 'Failed to load profile data.');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Fetches the list of jobs the user has applied to
  Future<void> loadAppliedJobs() async {
    try {
      final response = await _apiService.getAppliedJobs();
      
      if (response.success && response.data != null) {
        _view.onAppliedJobsLoaded(response.data!);
      } else {
        _view.showError(response.message ?? 'Failed to load applied jobs.');
      }
    } catch (e) {
      // Passes the background error to the UI instead of failing silently
      _view.showError('Server connection error while syncing applications.');
    }
  }
}