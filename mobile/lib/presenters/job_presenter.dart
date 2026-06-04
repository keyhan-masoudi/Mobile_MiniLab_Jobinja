import '../services/mock_api_service.dart';
import 'base_contracts.dart';

class JobPresenter {
  final JobListViewContract _view;
  final MockApiService _apiService;

  JobPresenter(this._view, this._apiService);

  void loadJobs({String keyword = '', String location = ''}) {
    _view.showLoading();
    _apiService.getJobs(keyword: keyword, location: location).then((response) {
      _view.hideLoading();
      _view.onJobsLoaded(response.data);
    }).catchError((error) {
      _view.hideLoading();
      _view.showError('خطا در بارگذاری موقعیت‌های شغلی');
    });
  }
}