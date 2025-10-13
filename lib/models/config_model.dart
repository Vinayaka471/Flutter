import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigModel {
  final String upiId;
  final String? qrImageUrl;

  ConfigModel({required this.upiId, this.qrImageUrl});

  factory ConfigModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ConfigModel(
      upiId: data['upiId'] ?? '',
      qrImageUrl: data['qrImageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'upiId': upiId,
      'qrImageUrl': qrImageUrl,
    };
  }
}
