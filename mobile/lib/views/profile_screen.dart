// lib/views/profile_screen.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/job.dart';
import '../presenters/auth_presenter.dart';
import '../presenters/profile_presenter.dart';
import '../widgets/loading_widget.dart' as lw;
import '../widgets/custom_button.dart';
import '../widgets/job_card.dart';
import 'login_screen.dart';
import 'job_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// Implements both Profile and Auth view contracts to handle data and logout
class _ProfileScreenState extends State<ProfileScreen>
    implements ProfileViewContract, AuthViewContract {
  late ProfilePresenter _profilePresenter;
  late AuthPresenter _authPresenter;

  User? _user;
  List<Job> _appliedJobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _profilePresenter = ProfilePresenter(this);
    _authPresenter = AuthPresenter(this);
    _user = widget.user;

    if (_user != null) {
      _profilePresenter.loadProfile();
      _profilePresenter.loadAppliedJobs();
    }
  }

  // --- ProfileViewContract & AuthViewContract Shared Methods ---

  @override
  void showLoading() => setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void showError(String message) => setState(() {
        _errorMessage = message;
        _isLoading = false;
      });

  // --- ProfileViewContract Specific Methods ---

  @override
  void onProfileLoaded(User user) => setState(() => _user = user);

  @override
  void onAppliedJobsLoaded(List<Job> jobs) =>
      setState(() => _appliedJobs = jobs);

  // --- AuthViewContract Specific Methods ---

  @override
  void onLoginSuccess(User user) {} // Not used here

  @override
  void onSignupSuccess(User user) {} // Not used here

  @override
  void onLogoutSuccess() {
    if (!mounted) return;
    // Clear the navigation stack and return to Login Screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // --- UI Action Handlers ---

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _authPresenter.logout(); // Trigger logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A56DB),
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Log Out',
              onPressed: _confirmLogout,
            ),
        ],
      ),
      body: _user == null
          ? _buildNotLoggedIn()
          : _isLoading
              ? const lw.LoadingWidget(message: 'Loading profile data...')
              : _errorMessage != null
                  ? lw.ErrorWidget(
                      message: _errorMessage!,
                      onRetry: _profilePresenter.loadProfile,
                    )
                  : _buildContent(),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle_outlined,
                size: 80, color: Color(0xFFCCCCCC)),
            const SizedBox(height: 20),
            const Text(
              'Please log in to view your profile',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Login / Sign Up',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final user = _user!;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            color: const Color(0xFF1A56DB),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // User Information Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.person_outline, 'Name', user.name),
                    const Divider(),
                    _buildInfoRow(Icons.email_outlined, 'Email', user.email),
                    if (user.phone != null) ...[
                      const Divider(),
                      _buildInfoRow(
                          Icons.phone_outlined, 'Phone', user.phone!),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Application Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                        '${_appliedJobs.length}', 'Applied', Icons.send),
                    _buildStatCard('0', 'Viewed', Icons.visibility),
                    _buildStatCard('0', 'Rejected', Icons.close),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Recent Applications List
          if (_appliedJobs.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Recent Applications',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_appliedJobs.length} items',
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ..._appliedJobs.map(
              (job) => JobCard(
                job: job,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobDetailScreen(jobId: job.id),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: 'Log Out of Account',
              onPressed: _confirmLogout,
              backgroundColor: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A56DB)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1A56DB), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A56DB),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
        ),
      ],
    );
  }
}