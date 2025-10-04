import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';
import 'package:ybt_match/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AddFundsForm extends StatefulWidget {
  const AddFundsForm({super.key});

  @override
  State<AddFundsForm> createState() => _AddFundsFormState();
}

class _AddFundsFormState extends State<AddFundsForm> {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String _utr = '';
  bool _isLoading = false;

  void _launchUpi(String upiId, double amount) async {
    final uri = Uri.parse('upi://pay?pa=$upiId&am=$amount&cu=INR');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch UPI app.')),
      );
    }
  }

  void _submitRequest() async {
    final user = Provider.of<UserModel?>(context, listen: false);
    if (user == null || !(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      await _firestoreService.createWalletRequest(user.uid, _amount, _utr);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet request submitted successfully!')),
      );
      _formKey.currentState?.reset();
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
    return StreamBuilder<ConfigModel?>(
      stream: _firestoreService.getConfig(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final config = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (config.qrImageUrl != null)
                  Center(child: Image.network(config.qrImageUrl!, height: 150)),
                const SizedBox(height: 16),
                Center(child: Text('UPI ID: ${config.upiId}', style: Theme.of(context).textTheme.titleMedium)),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) => (double.tryParse(value ?? '') == null || double.parse(value!) <= 0) ? 'Enter a valid amount' : null,
                  onSaved: (value) => _amount = double.parse(value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'UTR/Transaction ID'),
                  validator: (value) => (value?.isEmpty ?? true) ? 'Enter the UTR' : null,
                  onSaved: (value) => _utr = value!,
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Pay with UPI',
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _formKey.currentState?.save();
                              _launchUpi(config.upiId, _amount);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Submit Request',
                          onPressed: _submitRequest,
                          backgroundColor: Colors.blue,
                        ),
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
