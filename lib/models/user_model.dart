import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final double walletBalance;
  final double pendingBalance;
  final String role;
  final String? gameId;
  final String? gameType;
  final int matchesJoined;
  final int matchesWon;
  final int matchesLost;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.walletBalance = 0.0,
    this.pendingBalance = 0.0,
    this.role = 'user',
    this.gameId,
    this.gameType,
    this.matchesJoined = 0,
    this.matchesWon = 0,
    this.matchesLost = 0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      walletBalance: (data['walletBalance'] ?? 0.0).toDouble(),
      pendingBalance: (data['pendingBalance'] ?? 0.0).toDouble(),
      role: data['role'] ?? 'user',
      gameId: data['gameId'],
      gameType: data['gameType'],
      matchesJoined: data['matchesJoined'] ?? 0,
      matchesWon: data['matchesWon'] ?? 0,
      matchesLost: data['matchesLost'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'walletBalance': walletBalance,
      'pendingBalance': pendingBalance,
      'role': role,
      'gameId': gameId,
      'gameType': gameType,
      'matchesJoined': matchesJoined,
      'matchesWon': matchesWon,
      'matchesLost': matchesLost,
    };
  }
}
