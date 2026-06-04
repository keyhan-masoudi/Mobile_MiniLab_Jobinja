// lib/views/job_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/job.dart';
import '../presenters/job_presenter.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart' as lw;
import 'company_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

// Implements JobDetailViewContract to receive data from JobDetailPresenter
class _JobDetailScreenState extends State<JobDetailScreen> implements JobDetailViewContract {
  late JobDetailPresenter _presenter;
  Job? _job;
  bool _isLoading = false;
  String? _errorMessage;
  bool _applied = false;

  @override
  void initState() {
    super.initState();
    _presenter = JobDetailPresenter(this);
    _presenter.loadJobDetail(widget.jobId);
  }

  // --- JobDetailViewContract Implementation ---

  @override
  void showLoading() => setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void onJobDetailLoaded(Job job) => setState(() => _job = job);

  @override
  void onApplySuccess(String message) {
    setState(() => _applied = true);
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

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
          _job?.title ?? 'Job Details',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const lw.LoadingWidget(message: 'Loading details...')
          : _errorMessage != null
              ? lw.ErrorWidget(
                  message: _errorMessage!,
                  onRetry: () => _presenter.loadJobDetail(widget.jobId),
                )
              : _job == null
                  ? const SizedBox()
                  : _buildContent(),
      bottomNavigationBar: _job != null ? _buildBottomBar() : null,
    );
  }

  Widget _buildContent() {
    final job = _job!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card (Company & Title)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.business, color: Color(0xFF1A56DB), size: 34),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompanyScreen(
                                companySlug: job.company.id, // Using standard ID/Slug mapping
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                job.company.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A56DB),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF1A56DB)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Job Information Chips
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(Icons.location_on_outlined, 'Location', job.jobLocation.city),
                  const Divider(),
                  _buildInfoRow(Icons.work_outline, 'Contract', job.contractType),
                  const Divider(),
                  _buildInfoRow(Icons.payments_outlined, 'Salary', job.salary.display),
                  
                  if (job.levelExperience != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.trending_up, 'Experience', job.levelExperience!),
                  ],
                  if (job.isRemote ?? false) ...[
                    const Divider(),
                    _buildInfoRow(Icons.home_work_outlined, 'Work Type', 'Remote'),
                  ],
                  if (job.publishedAt != null) ...[
                    const Divider(),
                    _buildInfoRow(Icons.calendar_today_outlined, 'Published', job.publishedAt!),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Required Skills
          if (job.skills != null && job.skills!.isNotEmpty) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Required Skills',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.skills!
                          .map((s) => Chip(
                                label: Text(
                                  s,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: const Color(0xFFE8F0FE),
                                labelStyle: const TextStyle(color: Color(0xFF1A56DB)),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Job Description
          if (job.description != null) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Job Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      job.description!,
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
            const SizedBox(height: 12),
          ],
          
          // Benefits & Perks
          if (job.benefits != null && job.benefits!.isNotEmpty) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Benefits & Perks',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...job.benefits!.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                b,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), // Padding for the bottom bar
          ],
        ],
      ),
    );
  }

  // Helper method to build rows inside the info card
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A56DB)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF888888),
            ),
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

  // Helper method to build the sticky apply button at the bottom
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: _applied ? '✓ Applied' : 'Apply Now',
        onPressed: _applied || _isLoading
            ? null
            : () => _presenter.applyForJob(widget.jobId),
        isLoading: _isLoading,
        backgroundColor: _applied ? Colors.green : const Color(0xFF1A56DB),
      ),
    );
  }
}