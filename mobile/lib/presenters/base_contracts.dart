abstract class BaseViewContract {
  void showLoading();
  void hideLoading();
  void showError(String message);
}

abstract class AuthViewContract implements BaseViewContract {
  void onAuthSuccess();
}

abstract class JobListViewContract implements BaseViewContract {
  void onJobsLoaded(List<dynamic> jobs);
}

abstract class ProfileViewContract implements BaseViewContract {
  void onProfileLoaded(String name, String email, List<dynamic> appliedJobs);
  void onLogoutSuccess();
}