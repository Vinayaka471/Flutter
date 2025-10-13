import 'package:cloud_firestore/cloud_firestore.dart';

class EntryModel {
  final String entryId;
  final String tournamentId;
  final String userId;
  final String status;
  final double paidAmount;

  EntryModel({
    required this.entryId,
    required this.tournamentId,
    required this.userId,
    required this.status,
    required this.paidAmount,
  });

  factory EntryModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EntryModel(
      entryId: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'pending',
      paidAmount: (data['paidAmount'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tournamentId': tournamentId,
      'userId': userId,
      'status': status,
      'paidAmount': paidAmount,
    };
  }
}
