// lib/presenters/company_presenter.dart

import '../models/company.dart';
import '../models/job.dart';
import '../services/mock_api_service.dart';

// Contract defining UI methods for the Company profile screen
abstract class CompanyViewContract {
  void showLoading();
  void hideLoading();
  void onCompanyLoaded(Company company);
  void onCompanyJobsLoaded(List<Job> jobs);
  void showError(String message);
}

class CompanyPresenter {
  final CompanyViewContract _view;
  final MockApiService _apiService;

  CompanyPresenter(this._view) : _apiService = MockApiService();

  // Fetches company details and automatically triggers fetching its jobs on success
  Future<void> loadCompany(String slug) async {
    _view.showLoading();
    try {
      final response = await _apiService.getCompany(slug);
      
      if (response.success && response.data != null) {
        _view.onCompanyLoaded(response.data!);
        // Chain the job fetch request immediately after getting the company data
        await loadCompanyJobs(slug);
      } else {
        _view.hideLoading();
        _view.showError(response.message ?? 'Company not found.');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error. Please try again.');
    }
  }

  // Fetches the list of jobs posted by a specific company
  Future<void> loadCompanyJobs(String slug) async {
    try {
      final response = await _apiService.getCompanyJobs(slug);
      
      // We hide the loading indicator here because this is the final step of the chain
      _view.hideLoading(); 
      
      if (response.success && response.data != null) {
        _view.onCompanyJobsLoaded(response.data!);
      } else {
        _view.showError(response.message ?? 'Failed to load company jobs.');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('Server connection error while loading company jobs.');
    }
  }
}