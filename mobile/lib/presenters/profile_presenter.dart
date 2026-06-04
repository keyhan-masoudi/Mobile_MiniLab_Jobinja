import '../services/mock_api_service.dart';
import 'base_contracts.dart';

class ProfilePresenter {
  final ProfileViewContract _view;
  final MockApiService _apiService;

  ProfilePresenter(this._view, this._apiService);

  void loadUserProfileAndApplications() async {
    _view.showLoading();
    try {
      final user = await _apiService.getCurrentProfile();
      final applied = await _apiService.getAppliedJobs();
      _view.hideLoading();
      if (user != null) {
        _view.onProfileLoaded(user.name, user.email, applied);
      } else {
        _view.showError('کاربر احراز هویت نشده است');
      }
    } catch (e) {
      _view.hideLoading();
      _view.showError('خطا در دریافت اطلاعات کاربر');
    }
  }

  void logout() {
    _view.showLoading();
    _apiService.logout().then((_) {
      _view.hideLoading();
      _view.onLogoutSuccess();
    });
  }
}