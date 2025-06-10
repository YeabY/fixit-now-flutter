import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/request_service_provider.dart';

class RequestServiceScreen extends ConsumerStatefulWidget {
  final int requesterId;

  const RequestServiceScreen({
    super.key,
    required this.requesterId,
  });

  @override
  ConsumerState<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends ConsumerState<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urgencyController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime? _scheduledDate;

  final TextStyle inputTextStyle = const TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestServiceNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,  
        titleSpacing: 16,
        title: const Text(
          'Request Service',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Service Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Choose Type',
                  labelStyle: inputTextStyle,
                  border: const OutlineInputBorder(),
                ),
                style: inputTextStyle,
                items: ['PLUMBING', 'ELECTRICAL', 'CARPENTRY', 'CLEANING']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: inputTextStyle),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _serviceTypeController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                style: inputTextStyle,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: inputTextStyle,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Urgency',
                  labelStyle: inputTextStyle,
                  border: const OutlineInputBorder(),
                ),
                style: inputTextStyle,
                items: ['LOW', 'MEDIUM', 'HIGH']
                    .map((urgency) => DropdownMenuItem(
                          value: urgency,
                          child: Text(urgency, style: inputTextStyle),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _urgencyController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select urgency level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text(
                  'Scheduled Date (Optional)',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _scheduledDate?.toString() ?? 'Not set',
                  style: inputTextStyle,
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _scheduledDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _showBudgetDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7EBADF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _budgetController.text.isEmpty
                            ? 'Pay'
                            : 'Pay: ETB ${_budgetController.text}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: requestState.isLoading ? null : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: requestState.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit Request'),
                    ),
                  ),
                ],
              ),
              if (requestState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Error: ${requestState.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog() async {
    final controller = TextEditingController(text: _budgetController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            labelText: 'Budget',
            prefixText: 'ETB ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty &&
                  double.tryParse(controller.text) != null) {
                Navigator.pop(context, controller.text);
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _budgetController.text = result;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      if (_budgetController.text.isEmpty ||
          double.tryParse(_budgetController.text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set a valid budget')),
        );
        return;
      }

      try {
        await ref.read(requestServiceNotifierProvider.notifier).createRequest(
          serviceType: _serviceTypeController.text,
          description: _descriptionController.text,
          urgency: _urgencyController.text,
          budget: double.parse(_budgetController.text),
          scheduledDate: _scheduledDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request submitted successfully')),
          );
          _formKey.currentState?.reset();
          _serviceTypeController.clear();
          _descriptionController.clear();
          _urgencyController.clear();
          _budgetController.clear();
          setState(() {
            _scheduledDate = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _urgencyController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
}
