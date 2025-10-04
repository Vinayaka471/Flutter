import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ybt_match/models/models.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/locator.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final FirestoreService _firestoreService = locator<FirestoreService>();

    if (user == null) return const Center(child: Text('Please log in.'));

    return StreamBuilder<List<TransactionModel>>(
      stream: _firestoreService.getWalletTransactions(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions yet.'));
        }

        final transactions = snapshot.data!;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final txn = transactions[index];
            final isCredit = txn.type == 'credit';
            return ListTile(
              leading: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? Colors.green : Colors.red,
              ),
              title: Text(txn.description ?? (isCredit ? 'Credit' : 'Debit')),
              subtitle: Text('${txn.status.toUpperCase()} - ${DateFormat.yMMMd().add_jm().format(txn.timestamp.toDate())}'),
              trailing: Text(
                '${isCredit ? '+' : '-'}₹${txn.amount.toStringAsFixed(2)}',
                style: TextStyle(color: isCredit ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
