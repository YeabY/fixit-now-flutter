import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/performance_provider.dart';

class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(
            Icons.star,
            color: Colors.yellow,
            size: 20,
          );
        } else if (index == rating.floor() && rating - rating.floor() >= 0.5) {
          return const Icon(
            Icons.star_half,
            color: Colors.yellow,
            size: 20,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 20,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final performanceState = ref.watch(performanceProvider);

    return performanceState.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(performanceProvider.notifier).loadStats(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (stats) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Performance Overview',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFFEAEAEA),
                elevation: 4,
                child: Column(
                  children: [
                    _buildStatRow(
                      label: 'Total Earnings',
                      value: 'ETB ${stats['totalBudget'].toStringAsFixed(2)}',
                      isFirst: true,
                    ),
                    _buildStatRow(
                      label: 'Tasks Completed',
                      value: stats['completedRequests'].toString(),
                    ),
                    _buildStatRow(
                      label: 'Average Rating',
                      value: '',
                      isLast: true,
                      customValue: _buildStarRating(stats['averageRating']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
    Widget? customValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD5D5D5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: customValue ??
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
