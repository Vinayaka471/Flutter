import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/screens/wallet/add_funds_form.dart';
import 'package:ybt_match/screens/wallet/transaction_list.dart';
import 'package:ybt_match/screens/wallet/withdraw_funds_form.dart';
import 'package:ybt_match/widgets/widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  void _showAddFundsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const AddFundsForm(),
      ),
    );
  }

  void _showWithdrawFundsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const WithdrawFundsForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Available Balance: ₹${user?.walletBalance.toStringAsFixed(2) ?? '0.00'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          if (user?.pendingBalance != null && user!.pendingBalance > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Pending Balance: ₹${user.pendingBalance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.orange),
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Deposit',
                    onPressed: () => _showAddFundsSheet(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Withdraw',
                    onPressed: () => _showWithdrawFundsSheet(context),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const Expanded(
            child: TransactionList(),
          ),
        ],
      ),
    );
  }
}
