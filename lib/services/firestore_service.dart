import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ybt_match/constants/firebase_constants.dart';
import 'package:ybt_match/models/models.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  // User Methods
  Future<void> createUser(UserModel user) async {
    await _db.collection(FirebaseConstants.usersCollection).doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection(FirebaseConstants.usersCollection).doc(uid).get();
    return doc.exists ? UserModel.fromFirestore(doc) : null;
  }

  Future<void> updateUserProfile(String uid, {
    String? name,
    String? photoUrl,
    String? gameId,
    String? gameType,
  }) async {
    Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (gameId != null) data['gameId'] = gameId;
    if (gameType != null) data['gameType'] = gameType;

    if (data.isNotEmpty) {
      await _db.collection(FirebaseConstants.usersCollection).doc(uid).update(data);
    }
  }

  // Tournament Methods
  Stream<List<TournamentModel>> getTournaments() {
    return _db
        .collection(FirebaseConstants.tournamentsCollection)
        .where('status', isEqualTo: 'published')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TournamentModel.fromFirestore(doc)).toList());
  }

  // Entry Methods
  Future<void> joinTournament(String userId, String tournamentId, double entryFee) async {
    // Check if the user has already joined the tournament
    final existingEntries = await _db
        .collection(FirebaseConstants.entriesCollection)
        .where('userId', isEqualTo: userId)
        .where('tournamentId', isEqualTo: tournamentId)
        .limit(1)
        .get();

    if (existingEntries.docs.isNotEmpty) {
      throw Exception('You have already joined this tournament.');
    }

    String entryId = _uuid.v4();
    String txnId = _uuid.v4();

    WriteBatch batch = _db.batch();

    // Create Entry
    final newEntry = EntryModel(
      entryId: entryId,
      tournamentId: tournamentId,
      userId: userId,
      status: 'confirmed',
      paidAmount: entryFee,
    );
    DocumentReference entryRef = _db.collection(FirebaseConstants.entriesCollection).doc(entryId);
    batch.set(entryRef, newEntry.toMap());

    // Create Transaction
    final newTransaction = TransactionModel(
      txnId: txnId,
      userId: userId,
      amount: entryFee,
      type: 'debit',
      status: 'success',
      timestamp: Timestamp.now(), // This will be replaced by server timestamp in the map
    );
    DocumentReference txnRef = _db.collection(FirebaseConstants.transactionsCollection).doc(txnId);
    var txnMap = newTransaction.toMap();
    txnMap['timestamp'] = FieldValue.serverTimestamp(); // Use server timestamp
    batch.set(txnRef, txnMap);

    // Update Wallet and Achievements
    DocumentReference userRef = _db.collection(FirebaseConstants.usersCollection).doc(userId);
    batch.update(userRef, {
      'walletBalance': FieldValue.increment(-entryFee),
      'matchesJoined': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Stream<List<EntryModel>> getUserEntries(String userId) {
    return _db
        .collection(FirebaseConstants.entriesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => EntryModel.fromFirestore(doc)).toList());
  }

  // Wallet Methods
  Future<void> createWalletRequest(String userId, double amount, String utr) async {
    String requestId = _uuid.v4();
    String txnId = _uuid.v4();
    WriteBatch batch = _db.batch();

    // Create Wallet Request
    final newRequest = WalletRequestModel(
      requestId: requestId,
      userId: userId,
      amount: amount,
      utr: utr,
      status: 'pending',
      timestamp: Timestamp.now(),
      type: 'deposit',
    );
    DocumentReference requestRef = _db.collection(FirebaseConstants.walletRequestsCollection).doc(requestId);
    var requestMap = newRequest.toMap();
    requestMap['timestamp'] = FieldValue.serverTimestamp();
    batch.set(requestRef, requestMap);

    // Create Transaction
    final newTransaction = TransactionModel(
      txnId: txnId,
      userId: userId,
      amount: amount,
      type: 'credit',
      status: 'pending',
      timestamp: Timestamp.now(), // Server timestamp will be set in the map
      description: 'Deposit Request',
    );
    DocumentReference txnRef = _db.collection(FirebaseConstants.transactionsCollection).doc(txnId);
    var txnMap = newTransaction.toMap();
    txnMap['timestamp'] = FieldValue.serverTimestamp();
    batch.set(txnRef, txnMap);

    await batch.commit();
  }

  Future<void> createWithdrawalRequest(String userId, double amount, String upiId) async {
    String requestId = _uuid.v4();
    String txnId = _uuid.v4();
    WriteBatch batch = _db.batch();

    // Create Withdrawal Request
    final newRequest = WalletRequestModel(
      requestId: requestId,
      userId: userId,
      amount: amount,
      status: 'pending',
      timestamp: Timestamp.now(), // Server timestamp will be set in the map
      type: 'withdrawal',
      upiId: upiId,
    );
    DocumentReference requestRef = _db.collection(FirebaseConstants.walletRequestsCollection).doc(requestId);
    var requestMap = newRequest.toMap();
    requestMap['timestamp'] = FieldValue.serverTimestamp();
    batch.set(requestRef, requestMap);

    // Move the amount to pending balance
    DocumentReference userRef = _db.collection(FirebaseConstants.usersCollection).doc(userId);
    batch.update(userRef, {
      'walletBalance': FieldValue.increment(-amount),
      'pendingBalance': FieldValue.increment(amount),
    });

    // Create Transaction
    final newTransaction = TransactionModel(
      txnId: txnId,
      userId: userId,
      amount: amount,
      type: 'debit',
      status: 'pending',
      timestamp: Timestamp.now(), // Server timestamp will be set in the map
      description: 'Withdrawal Request',
    );
    DocumentReference txnRef = _db.collection(FirebaseConstants.transactionsCollection).doc(txnId);
    var txnMap = newTransaction.toMap();
    txnMap['timestamp'] = FieldValue.serverTimestamp();
    batch.set(txnRef, txnMap);

    await batch.commit();
  }

  Stream<List<TransactionModel>> getWalletTransactions(String userId) {
    return _db
        .collection(FirebaseConstants.transactionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TransactionModel.fromFirestore(doc)).toList());
  }

  // Support Ticket Methods
  Future<void> createSupportTicket(String userId, String name, String email, String description) async {
    String ticketId = _uuid.v4();
    final newTicket = SupportTicketModel(
      ticketId: ticketId,
      userId: userId,
      name: name,
      email: email,
      description: description,
      createdAt: Timestamp.now(), // Server timestamp will be set in the map
    );
    var ticketMap = newTicket.toMap();
    ticketMap['createdAt'] = FieldValue.serverTimestamp();
    await _db.collection('supportTickets').doc(ticketId).set(ticketMap);
  }

  // Config Methods
  Stream<ConfigModel?> getConfig() {
    return _db
        .collection(FirebaseConstants.configCollection)
        .doc('default')
        .snapshots()
        .map((doc) => doc.exists ? ConfigModel.fromFirestore(doc) : null);
  }

  // Data Seeding
  Future<void> seedDatabase() async {
    // Seed Config
    final configDoc = await _db.collection(FirebaseConstants.configCollection).doc('default').get();
    if (!configDoc.exists) {
      await _db.collection(FirebaseConstants.configCollection).doc('default').set({
        'upiId': 'your-upi-id@okhdfcbank',
        'qrImageUrl': 'https://placehold.co/400x400.png',
      });
    }

    // Seed Tournament
    final tournaments = await _db.collection(FirebaseConstants.tournamentsCollection).limit(1).get();
    if (tournaments.docs.isEmpty) {
      // Seed BGMI Tournament
      String bgmiTournamentId = _uuid.v4();
      await _db.collection(FirebaseConstants.tournamentsCollection).doc(bgmiTournamentId).set({
        'title': 'BGMI Weekly Showdown',
        'gameType': 'BGMI',
        'date': Timestamp.now(),
        'time': '8:00 PM',
        'entryFee': 50.0,
        'slots': 100,
        'prize': 2500.0,
        'rules': 'Standard BGMI competitive rules apply. No emulators.',
        'imageUrl': 'https://placehold.co/600x400.png',
        'status': 'published',
        'description': 'An exciting weekly BGMI tournament with a huge prize pool.',
      });

      // Seed Free Fire Tournament
      String ffTournamentId = _uuid.v4();
      await _db.collection(FirebaseConstants.tournamentsCollection).doc(ffTournamentId).set({
        'title': 'Free Fire Friday Night',
        'gameType': 'Free Fire',
        'date': Timestamp.now(),
        'time': '9:00 PM',
        'entryFee': 30.0,
        'slots': 50,
        'prize': 1500.0,
        'rules': 'Standard Free Fire rules. Mobile only.',
        'imageUrl': 'https://placehold.co/600x400.png',
        'status': 'published',
        'description': 'Join the Free Fire Friday Night tournament and win big!',
      });
    }

    // Seed Entry, Transaction, Wallet Request (for demonstration)
    final entries = await _db.collection(FirebaseConstants.entriesCollection).limit(1).get();
    if (entries.docs.isEmpty) {
      String entryId = _uuid.v4();
      String txnId = _uuid.v4();
      String walletRequestId = _uuid.v4();
      String testUserId = 'test-user-id'; // A dummy user ID

      // Seed Entry
      await _db.collection(FirebaseConstants.entriesCollection).doc(entryId).set({
        'tournamentId': 'dummy-tournament-id',
        'userId': testUserId,
        'status': 'confirmed',
        'paidAmount': 50.0,
      });

      // Seed Transaction
      await _db.collection(FirebaseConstants.transactionsCollection).doc(txnId).set({
        'userId': testUserId,
        'amount': 50.0,
        'type': 'debit',
        'status': 'success',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Seed Wallet Request
      await _db.collection(FirebaseConstants.walletRequestsCollection).doc(walletRequestId).set({
        'userId': testUserId,
        'amount': 100.0,
        'utr': 'DUMMYUTR12345',
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }
}
