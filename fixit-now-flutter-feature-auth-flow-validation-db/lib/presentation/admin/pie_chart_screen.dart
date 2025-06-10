import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartScreen extends StatelessWidget {
  final int pendingCount;
  final int completedCount;
  final int rejectedCount;

  const PieChartScreen({
    super.key,
    required this.pendingCount,
    required this.completedCount,
    required this.rejectedCount,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;
    
    // Calculate chart size based on screen width
    final chartSize = isDesktop ? size.width * 0.2 : size.width * 0.4;
    final chartHeight = isDesktop ? 180.0 : 150.0;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: isDesktop ? 250 : 200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Text(
          //   'Request Status Distribution',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // const SizedBox(height: 8),
          Center(
            child: SizedBox(
              height: chartHeight,
              width: chartSize,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: pendingCount.toDouble(),
                      title: pendingCount > 0 ? 'Pending' : '',
                      color: Colors.orange,
                      radius: chartSize * 0.4,
                    ),
                    PieChartSectionData(
                      value: completedCount.toDouble(),
                      title: completedCount > 0 ? 'Completed' : '',
                      color: Colors.green,
                      radius: chartSize * 0.4,
                    ),
                    PieChartSectionData(
                      value: rejectedCount.toDouble(),
                      title: rejectedCount > 0 ? 'Rejected' : '',
                      color: Colors.red,
                      radius: chartSize * 0.4,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: chartSize * 0.3, // Thinner donut
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
