import 'package:flutter/material.dart';
import '../models/job.dart';

/// A comprehensive card widget displaying job details using clean chips and layouts.
class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onCompanyTap;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onCompanyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company logo placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Color(0xFF1A56DB),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: onCompanyTap,
                          child: Text(
                            job.company.name, // Mapped to our Single Source of Truth
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A56DB),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildChip(Icons.location_on_outlined, job.jobLocation.city), // Adjusted to model
                  _buildChip(Icons.work_outline, job.contractType),
                  _buildChip(Icons.payments_outlined, job.salary.display), // Adjusted to model
                  // Assuming your Job model has an isRemote boolean, otherwise this can be safely removed
                  if (job.isRemote ?? false) 
                    _buildChip(Icons.home_work_outlined, 'Remote', isHighlight: true),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Safe fallback in case your model doesn't have levelExperience yet
                  if (job.levelExperience != null)
                    Text(
                      job.levelExperience!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                  const Spacer(),
                  if (job.publishedAt != null)
                    Text(
                      job.publishedAt!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the UI chips for job properties
  Widget _buildChip(IconData icon, String label, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isHighlight
                ? const Color(0xFF2E7D32)
                : const Color(0xFF666666),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isHighlight
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}