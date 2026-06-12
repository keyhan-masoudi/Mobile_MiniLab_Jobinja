// lib/views/home_screen.dart

import 'package:flutter/material.dart';
import '../models/job.dart';
import '../models/user.dart';
import '../presenters/job_presenter.dart';
import '../widgets/job_card.dart';
import '../widgets/loading_widget.dart' as lw;
import 'job_detail_screen.dart';
import 'company_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Implements JobListViewContract to receive data from JobListPresenter
class _HomeScreenState extends State<HomeScreen> implements JobListViewContract {
  late JobListPresenter _presenter;
  final _searchController = TextEditingController();

  List<Job> _jobs = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Pagination state
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;

  // Filter state
  String? _selectedLocation;
  String? _selectedCategory;
  String _sortBy = 'published_at_desc';
  List<String> _locations = [];
  List<Map<String, dynamic>> _categories = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _presenter = JobListPresenter(this);
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Detects when the user scrolls near the bottom of the list
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _currentPage < _lastPage) {
      _loadMoreJobs();
    }
  }

  Future<void> _loadInitialData() async {
    _locations = await _presenter.getLocations();
    _categories = await _presenter.getCategories();
    await _presenter.loadJobs(page: 1);
  }

  Future<void> _loadMoreJobs() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    
    await _presenter.loadJobs(
      page: _currentPage + 1,
      keyword: _searchController.text.trim(),
      location: _selectedLocation,
      category: _selectedCategory,
      sortBy: _sortBy,
    );
    
    setState(() => _isLoadingMore = false);
  }

  Future<void> _search() async {
    setState(() {
      _jobs = [];
      _currentPage = 1;
    });
    
    await _presenter.loadJobs(
      page: 1,
      keyword: _searchController.text.trim(),
      location: _selectedLocation,
      category: _selectedCategory,
      sortBy: _sortBy,
    );
  }

  // --- JobListViewContract Implementation ---

  @override
  void showLoading() => setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void onJobsLoaded(List<Job> jobs, int currentPage, int lastPage) {
    setState(() {
      if (currentPage == 1) {
        _jobs = jobs;
      } else {
        _jobs.addAll(jobs);
      }
      _currentPage = currentPage;
      _lastPage = lastPage;
    });
  }

  @override
  void showError(String message) => setState(() {
        _errorMessage = message;
        _isLoading = false;
      });

  // --- UI Action Handlers ---

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FilterSheet(
        locations: _locations,
        categories: _categories,
        selectedLocation: _selectedLocation,
        selectedCategory: _selectedCategory,
        sortBy: _sortBy,
        onApply: (location, category, sort) {
          setState(() {
            _selectedLocation = location;
            _selectedCategory = category;
            _sortBy = sort;
          });
          _search();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A56DB),
        elevation: 0,
        title: const Text(
          'Jobinja',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: const Color(0xFF1A56DB),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Search job title or company...',
                      hintStyle: const TextStyle(color: Color(0xFF999999)),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _search();
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: _showFilterSheet,
                    tooltip: 'Filters',
                  ),
                ),
              ],
            ),
          ),
          
          // Filter chips
          if (_selectedLocation != null || _selectedCategory != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  const Text('Filters: ',
                      style: TextStyle(color: Color(0xFF888888))),
                  if (_selectedLocation != null)
                    _buildFilterChip(
                      _selectedLocation!,
                      () => setState(() {
                        _selectedLocation = null;
                        _search();
                      }),
                    ),
                  if (_selectedCategory != null)
                    _buildFilterChip(
                      _selectedCategory!,
                      () => setState(() {
                        _selectedCategory = null;
                        _search();
                      }),
                    ),
                ],
              ),
            ),
            
          // Jobs count
          if (!_isLoading && _errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    '${_jobs.length} Jobs found',
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
          // Content Area
          Expanded(
            child: _isLoading && _jobs.isEmpty
                ? const lw.LoadingWidget(message: 'Loading jobs...')
                : _errorMessage != null && _jobs.isEmpty
                    ? lw.ErrorWidget(
                        message: _errorMessage!,
                        onRetry: _loadInitialData,
                      )
                    : _jobs.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 64, color: Color(0xFFCCCCCC)),
                                SizedBox(height: 16),
                                Text(
                                  'No jobs found',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadInitialData,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount:
                                  _jobs.length + (_isLoadingMore ? 1 : 0),
                              itemBuilder: (_, index) {
                                // Bottom loading indicator
                                if (index == _jobs.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                
                                final job = _jobs[index];
                                return JobCard(
                                  job: job,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          JobDetailScreen(jobId: job.id),
                                    ),
                                  ),
                                  onCompanyTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CompanyScreen(
                                        companySlug: job.company.id, // Replaced with actual ID
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF1A56DB), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: Color(0xFF1A56DB)),
          ),
        ],
      ),
    );
  }
}

// Bottom Sheet widget for filters
class _FilterSheet extends StatefulWidget {
  final List<String> locations;
  final List<Map<String, dynamic>> categories;
  final String? selectedLocation;
  final String? selectedCategory;
  final String sortBy;
  final void Function(String?, String?, String) onApply;

  const _FilterSheet({
    required this.locations,
    required this.categories,
    required this.selectedLocation,
    required this.selectedCategory,
    required this.sortBy,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _location;
  String? _category;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _location = widget.selectedLocation;
    _category = widget.selectedCategory;
    _sortBy = widget.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Filters',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            // Location Dropdown
            const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _location,
              hint: const Text('Select a location'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Locations')),
                ...widget.locations.map(
                  (l) => DropdownMenuItem(value: l, child: Text(l)),
                ),
              ],
              onChanged: (v) => setState(() => _location = v),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _category,
              hint: const Text('Select a category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                ...widget.categories.map(
                      (c) => DropdownMenuItem(value: c['id'], child: Text(c['name'])),
                ),
              ],
              onChanged: (v) => setState(() => _category = v),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),

            // Sorting Dropdown
            const Text('Sort By',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _sortBy,
              items: const [
                DropdownMenuItem(
                    value: 'published_at_desc', child: Text('Newest First')),
                DropdownMenuItem(
                    value: 'salary_desc', child: Text('Highest Salary')),
              ],
              onChanged: (v) => setState(() => _sortBy = v!),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 32),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _location = null;
                        _category = null;
                        _sortBy = 'published_at_desc';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_location, _category, _sortBy);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A56DB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}