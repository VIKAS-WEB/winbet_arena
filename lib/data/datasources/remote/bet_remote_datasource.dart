import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/bet_model.dart';

abstract class BetRemoteDataSource {
  Future<void> placeBet(BetModel bet);
  Stream<List<BetModel>> getUserBets(String userId);
}

class BetRemoteDataSourceImpl implements BetRemoteDataSource {
  final FirebaseFirestore firestore;
  BetRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> placeBet(BetModel bet) async {
    final doc = firestore.collection('bets').doc();
    await doc.set(bet.toMap());
  }

  @override
  Stream<List<BetModel>> getUserBets(String userId) {
    return firestore
        .collection('bets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BetModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}
