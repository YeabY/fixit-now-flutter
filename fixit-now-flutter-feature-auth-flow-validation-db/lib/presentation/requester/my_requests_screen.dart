import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/my_requests_provider.dart';
import '../../core/models/request.dart';
import '../providers/provider_coordinator.dart';

class MyRequestsScreen extends ConsumerStatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  ConsumerState<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends ConsumerState<MyRequestsScreen> {
  Future<void> _showReviewDialog(int requestId) async {
    final ratingController = TextEditingController();
    final reviewController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating (1-5)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final rating = double.tryParse(ratingController.text);
              if (rating == null || rating < 1 || rating > 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid rating (1-5)')),
                );
                return;
              }
              if (reviewController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a review')),
                );
                return;
              }

              try {
                await ref.read(myRequestsNotifierProvider.notifier).addReview(
                  requestId: requestId,
                  rating: rating,
                  review: reviewController.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review submitted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsComplete(int requestId) async {
    try {
      await ref.read(myRequestsNotifierProvider.notifier).updateRequestStatus(requestId, 'COMPLETED');
      ref.read(providerCoordinator).onRequestCompleted();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request marked as complete. You can now add a review.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _declineRequest(int requestId) async {
    try {
      await ref.read(myRequestsNotifierProvider.notifier).updateRequestStatus(requestId, 'REJECTED');
      ref.read(providerCoordinator).onRequestCompleted();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request declined')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsState = ref.watch(myRequestsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text(
          'My Request',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: requestsState.when(
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
                onPressed: () => ref.read(myRequestsNotifierProvider.notifier).refreshRequests(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (requests) => requests.isEmpty
            ? const Center(
                child: Text(
                  'No requests found',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  final status = request.status.toUpperCase();
                  final description = request.description;
                  final date = request.scheduledDate?.toString() ?? request.createdAt.toString();
                  final providerName = request.providerName ?? '';
                  final providerPhone = request.providerPhone ?? '';
                  final showProvider = ['IN_PROGRESS', 'COMPLETED', 'REJECTED'].contains(status);

                  return Card(
                    color: const Color(0xFFF2F2F2),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusBgColor(status),
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (date.isNotEmpty)
                            Text(
                              'Date: $date',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                          if (showProvider && providerName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Provider: $providerName', style: const TextStyle(fontSize: 15)),
                            ),
                          if (showProvider && providerPhone.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('Provider Phone: $providerPhone', style: const TextStyle(fontSize: 15)),
                            ),
                          if (request.budget != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Budget: \$${request.budget}', style: const TextStyle(fontSize: 15)),
                            ),
                          const SizedBox(height: 12),
                          if (status == 'IN_PROGRESS')
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _markAsComplete(request.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF86D069),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    child: const Text('Mark as Complete'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _declineRequest(request.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF2D4D4),
                                      foregroundColor: Color(0xFFF43939),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                ),
                              ],
                            )
                          else if (status == 'COMPLETED' && request.rating == null)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _showReviewDialog(request.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD9D9D9),
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    child: const Text('Add Review'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.grey.shade200;
      case 'IN_PROGRESS':
        return const Color(0xFF96ADF1);
      case 'ACCEPTED':
        return Colors.blue.shade100;
      case 'COMPLETED':
        return const Color(0xFF86D069);
      case 'REJECTED':
        return const Color(0xFFF1D8D8);
      default:
        return Colors.grey.shade200;
    }
  }
}
