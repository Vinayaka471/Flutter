import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentModel {
  final String id;
  final String title;
  final String gameType;
  final Timestamp date;
  final String time;
  final double entryFee;
  final int slots;
  final double prize;
  final String rules;
  final String? imageUrl;
  final String status;
  final String description;

  TournamentModel({
    required this.id,
    required this.title,
    required this.gameType,
    required this.date,
    required this.time,
    required this.entryFee,
    required this.slots,
    required this.prize,
    required this.rules,
    this.imageUrl,
    required this.status,
    required this.description,
  });

  factory TournamentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TournamentModel(
      id: doc.id,
      title: data['title'] ?? '',
      gameType: data['gameType'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      time: data['time'] ?? '',
      entryFee: (data['entryFee'] ?? 0.0).toDouble(),
      slots: data['slots'] ?? 0,
      prize: (data['prize'] ?? 0.0).toDouble(),
      rules: data['rules'] ?? '',
      imageUrl: data['imageUrl'],
      status: data['status'] ?? 'draft',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'gameType': gameType,
      'date': date,
      'time': time,
      'entryFee': entryFee,
      'slots': slots,
      'prize': prize,
      'rules': rules,
      'imageUrl': imageUrl,
      'status': status,
      'description': description,
    };
  }
}
