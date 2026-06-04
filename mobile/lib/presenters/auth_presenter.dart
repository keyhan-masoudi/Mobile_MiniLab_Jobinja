import '../services/mock_api_service.dart';
import 'base_contracts.dart';

class AuthPresenter {
  final AuthViewContract _view;
  final MockApiService _apiService;

  AuthPresenter(this._view, this._apiService);

  void performLogin(String email, String password) {
    _view.showLoading();
    _apiService.login(email, password).then((user) {
      _view.hideLoading();
      _view.onAuthSuccess();
    }).catchError((error) {
      _view.hideLoading();
      _view.showError(error.toString());
    });
  }

  void performSignup(String name, String email, String password) {
    _view.showLoading();
    _apiService.signup(name, email, password).then((user) {
      _view.hideLoading();
      _view.onAuthSuccess();
    }).catchError((error) {
      _view.hideLoading();
      _view.showError(error.toString());
    });
  }
}