import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/request.dart';
import '../providers/request_provider.dart';

class RequestScreen extends ConsumerWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestNotifierProvider);

    return Container(
      color: const Color(0xFFF6F9FA),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Service Requests',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _buildFilterButton(ref, 'all', 'All')),
              const SizedBox(width: 8),
              Expanded(child: _buildFilterButton(ref, 'completed', 'Completed')),
              const SizedBox(width: 8),
              Expanded(child: _buildFilterButton(ref, 'rejected', 'Rejected')),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.black, width: 0.5),
              ),
              child: requestsAsync.when(
                data: (requests) => _buildRequestList(requests),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${error.toString()}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(requestNotifierProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<Request> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Text('No requests found'),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final status = request.status;
        final serviceType = request.serviceType.toUpperCase();
        final requestId = request.id.toString();
        final requesterName = request.requesterId?.toString() ?? 'Unknown';
        final requestTime = request.createdAt.toIso8601String();

        // Parse and format time if possible
        String formattedTime = requestTime;
        try {
          final dt = DateTime.parse(requestTime);
          formattedTime = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}\n${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
        } catch (_) {}

        // Emoji for each service type
        String serviceEmoji;
        switch (serviceType) {
          case 'ELECTRICAL':
            serviceEmoji = '⚡';
            break;
          case 'PLUMBING':
            serviceEmoji = '🔧';
            break;
          case 'PAINTING':
            serviceEmoji = '🎨';
            break;
          case 'CLEANING':
            serviceEmoji = '🧹';
            break;
          case 'CARPENTRY':
            serviceEmoji = '🔨';
            break;
          case 'GARDENING':
            serviceEmoji = '🌿';
            break;
          case 'MOVING':
            serviceEmoji = '🚚';
            break;
          default:
            serviceEmoji = '🛠️';
        }

        Widget statusIcon;
        if (status == 'REJECTED') {
          statusIcon = const Icon(Icons.close, color: Colors.red, size: 28);
        } else if (status == 'COMPLETED') {
          statusIcon = const Icon(Icons.check_circle, color: Colors.green, size: 28);
        } else {
          statusIcon = const SizedBox(width: 28);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      serviceEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(serviceType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Request ID: $requestId', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(requesterName, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40, child: Center(child: statusIcon)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(WidgetRef ref, String value, String label) {
    final selectedFilter = ref.watch(requestNotifierProvider.notifier).selectedFilter; // Access selectedFilter from the notifier
    final bool isSelected = selectedFilter == value;
    return OutlinedButton(
      onPressed: () {
        ref.read(requestNotifierProvider.notifier).setFilter(value);
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade400,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
