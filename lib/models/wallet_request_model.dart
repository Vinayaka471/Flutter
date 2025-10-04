import 'package:cloud_firestore/cloud_firestore.dart';

class WalletRequestModel {
  final String requestId;
  final String userId;
  final double amount;
  final String? utr;
  final String status;
  final Timestamp timestamp;
  final String type;
  final String? upiId;

  WalletRequestModel({
    required this.requestId,
    required this.userId,
    required this.amount,
    this.utr,
    required this.status,
    required this.timestamp,
    required this.type,
    this.upiId,
  });

  factory WalletRequestModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WalletRequestModel(
      requestId: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      utr: data['utr'],
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      type: data['type'] ?? 'deposit',
      upiId: data['upiId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'utr': utr,
      'status': status,
      'timestamp': timestamp,
      'type': type,
      'upiId': upiId,
    };
  }
}
