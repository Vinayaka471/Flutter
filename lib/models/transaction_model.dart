import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String txnId;
  final String userId;
  final double amount;
  final String type;
  final String status;
  final Timestamp timestamp;
  final String? description;

  TransactionModel({
    required this.txnId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    required this.timestamp,
    this.description,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      txnId: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      type: data['type'] ?? 'debit',
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'type': type,
      'status': status,
      'timestamp': timestamp,
      'description': description,
    };
  }
}
