import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recruitment_provider.dart';

class RecruitmentScreen extends ConsumerWidget {
  const RecruitmentScreen({super.key});

  String _getServiceImage(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'cleaning':
        return 'assets/images/cleaning.jpg';
      case 'plumbing':
        return 'assets/images/pluming.jpg';
      case 'electrical':
        return 'assets/images/electrical.jpg';
      case 'carpentry':
        return 'assets/images/carpentry.jpg';
      case 'painting':
        return 'assets/images/painting.jpg';
      default:
        return 'assets/images/img.png';
    }
  }

  String _getPriceByServiceType(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'electrical':
        return 'ETB 800';
      case 'cleaning':
        return 'ETB 400';
      case 'plumbing':
        return 'ETB 500';
      case 'carpentry':
        return 'ETB 700';
      case 'painting':
        return 'ETB 600';
      default:
        return 'ETB 400';
    }
  }

  Widget _buildServiceCard(dynamic service) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.asset(
                      _getServiceImage(service['serviceType']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.yellow, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            service['rating']?.toString() ?? '0.0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service['serviceType'] ?? 'Unknown Service',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _getPriceByServiceType(service['serviceType'] ?? ''),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProviderCard(dynamic provider) {
    final serviceType = (provider['serviceType'] ?? '').toString();
    final price = _getPriceByServiceType(serviceType);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider['name'] ?? 'Unknown Provider',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    serviceType.isNotEmpty ? serviceType : 'No Service Type',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recruitmentState = ref.watch(recruitmentNotifierProvider);

    return recruitmentState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(recruitmentNotifierProvider.notifier).refreshData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) {
        final trendingServices = data['trendingServices'] as List<dynamic>;
        final topProviders = data['topProviders'] as List<dynamic>;
        final totalProviders = data['totalProviders'] as int;
        final averageRating = data['averageRating'] as double;

        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trending Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingServices.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildServiceCard(trendingServices[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Top Providers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...topProviders.map((provider) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildTopProviderCard(provider),
                    )),
                const SizedBox(height: 32),
                const Text(
                  'Service Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      'Total Providers',
                      totalProviders.toString(),
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Average Rating',
                      averageRating.toStringAsFixed(1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
