// lib/views/company_screen.dart

import 'package:flutter/material.dart';
import '../models/company.dart';
import '../models/job.dart';
import '../presenters/company_presenter.dart';
import '../widgets/job_card.dart';
import '../widgets/loading_widget.dart' as lw;
import 'job_detail_screen.dart';

class CompanyScreen extends StatefulWidget {
  final String companySlug;

  const CompanyScreen({super.key, required this.companySlug});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

// Implements CompanyViewContract to receive data from CompanyPresenter
class _CompanyScreenState extends State<CompanyScreen> implements CompanyViewContract {
  late CompanyPresenter _presenter;
  Company? _company;
  List<Job> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = CompanyPresenter(this);
    _presenter.loadCompany(widget.companySlug);
  }

  // --- CompanyViewContract Implementation ---

  @override
  void showLoading() => setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void onCompanyLoaded(Company company) => setState(() => _company = company);

  @override
  void onCompanyJobsLoaded(List<Job> jobs) => setState(() => _jobs = jobs);

  @override
  void showError(String message) => setState(() => _errorMessage = message);

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A56DB),
        title: Text(
          _company?.name ?? 'Company Profile',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const lw.LoadingWidget(message: 'Loading company information...')
          : _errorMessage != null
              ? lw.ErrorWidget(
                  message: _errorMessage!,
                  onRetry: () => _presenter.loadCompany(widget.companySlug),
                )
              : _company == null
                  ? const SizedBox()
                  : _buildContent(),
    );
  }

  Widget _buildContent() {
    final company = _company!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            width: double.infinity,
            color: const Color(0xFF1A56DB),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.business, color: Color(0xFF1A56DB), size: 44),
                ),
                const SizedBox(height: 12),
                Text(
                  company.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (company.industry != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      company.industry!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Quick Info Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (company.location != null)
                      _buildInfoRow(Icons.location_on_outlined, 'Location', company.location!),
                    if (company.size != null) ...[
                      const Divider(),
                      _buildInfoRow(Icons.people_outline, 'Company Size', company.size!),
                    ],
                    if (company.jobCount != null) ...[
                      const Divider(),
                      _buildInfoRow(Icons.work_outline, 'Job Openings', '${company.jobCount} positions'),
                    ],
                    if (company.website != null) ...[
                      const Divider(),
                      _buildInfoRow(Icons.language, 'Website', company.website!),
                    ],
                  ],
                ),
              ),
            ),
          ),
          
          // About Section
          if (company.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Company',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        company.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF444444),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          // Jobs List Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Open Positions (${_jobs.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          if (_jobs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No active job positions available.',
                  style: TextStyle(color: Color(0xFF888888)),
                ),
              ),
            )
          else
            ...(_jobs.map(
              (job) => JobCard(
                job: job,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobDetailScreen(jobId: job.id),
                  ),
                ),
                // No onCompanyTap here to prevent infinite loop of navigating to the same screen
              ),
            )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Helper method to build rows inside the quick info card
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A56DB)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
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
}