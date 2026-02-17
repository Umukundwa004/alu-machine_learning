import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_provider.dart';

class RiskStatusScreen extends StatelessWidget {
  const RiskStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F3B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F3B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Risk Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          final attendancePercentage = dataProvider.getAttendancePercentage();
          final pendingAssignments = dataProvider.getPendingAssignmentsCount();
          final totalAssignments = dataProvider.assignments.length;
          final assignmentPercentage = totalAssignments > 0
              ? ((totalAssignments - pendingAssignments) /
                    totalAssignments *
                    100)
              : 0.0;

          // Calculate average (simple average of attendance and assignment completion)
          final averagePercentage =
              (attendancePercentage + assignmentPercentage) / 2;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  const Text(
                    'Hello Alex  At Risk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Risk Metrics
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRiskMetric(
                        percentage: 75,
                        label: 'Attendance',
                        color: const Color(0xFFE53935),
                      ),
                      _buildRiskMetric(
                        percentage: 60,
                        label: 'Assignment to\nSlatmment',
                        color: const Color(0xFFFFB800),
                      ),
                      _buildRiskMetric(
                        percentage: 63,
                        label: 'Average\nExsite',
                        color: const Color(0xFFE53935),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Get Help Button container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Get Help',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1A2C5A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRiskMetric({
    required int percentage,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 88,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
