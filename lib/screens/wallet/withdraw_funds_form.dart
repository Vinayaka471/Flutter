import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';

class WithdrawFundsForm extends StatefulWidget {
  const WithdrawFundsForm({super.key});

  @override
  State<WithdrawFundsForm> createState() => _WithdrawFundsFormState();
}

class _WithdrawFundsFormState extends State<WithdrawFundsForm> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String _upiId = '';
  bool _isLoading = false;

  void _submitRequest() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || !(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();

    if (user.walletBalance < _amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient wallet balance.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _firestoreService.createWithdrawalRequest(user.uid, _amount, _upiId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal request submitted successfully!')),
      );
      _formKey.currentState?.reset();
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: ${e.toString()}')),
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
            Text('Withdraw Funds', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => (double.tryParse(value ?? '') == null || double.parse(value!) <= 0) ? 'Enter a valid amount' : null,
              onSaved: (value) => _amount = double.parse(value!),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'UPI ID'),
              validator: (value) => (value?.isEmpty ?? true) ? 'Enter your UPI ID' : null,
              onSaved: (value) => _upiId = value!,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: CustomButton(
                  text: 'Submit Request',
                  onPressed: _submitRequest,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
