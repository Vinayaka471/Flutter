import 'package:cloud_firestore/cloud_firestore.dart';

class SupportTicketModel {
  final String ticketId;
  final String userId;
  final String name;
  final String email;
  final String description;
  final String status;
  final Timestamp createdAt;
  final List<Map<String, dynamic>> replies;

  SupportTicketModel({
    required this.ticketId,
    required this.userId,
    required this.name,
    required this.email,
    required this.description,
    this.status = 'open',
    required this.createdAt,
    this.replies = const [],
  });

  factory SupportTicketModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SupportTicketModel(
      ticketId: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'open',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      replies: List<Map<String, dynamic>>.from(data['replies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'replies': replies,
    };
  }
}
