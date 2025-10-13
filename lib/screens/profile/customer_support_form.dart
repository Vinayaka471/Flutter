import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class CustomerSupportForm extends StatefulWidget {
  const CustomerSupportForm({super.key});

  @override
  State<CustomerSupportForm> createState() => _CustomerSupportFormState();
}

class _CustomerSupportFormState extends State<CustomerSupportForm> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserModel?>(context, listen: false);
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _descriptionController = TextEditingController();
  }

  void _submitTicket() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || !(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await _firestoreService.createSupportTicket(
        user.uid,
        _nameController.text,
        _emailController.text,
        _descriptionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support ticket submitted successfully!')),
      );
      _descriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit ticket: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contact Support', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Problem Description'),
              maxLines: 5,
              validator: (value) => (value?.isEmpty ?? true) ? 'Please describe your problem' : null,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: CustomButton(
                  text: 'Submit Ticket',
                  onPressed: _submitTicket,
                ),
              ),
            const Divider(height: 40),
            Text('My Tickets', style: Theme.of(context).textTheme.headlineSmall),
            // TODO: Display user's support tickets here
          ],
        ),
      ),
    );
  }
}
