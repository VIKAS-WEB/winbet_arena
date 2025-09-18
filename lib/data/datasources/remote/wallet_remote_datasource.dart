import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winbet_arena/data/models/wallet_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel?> getWallet(String userId);
  Future<void> updateWallet(WalletModel wallet);
}


class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;
  WalletRemoteDataSourceImpl(this.firestore);

  @override
  Future<WalletModel?> getWallet(String userId) async {
    final doc = await firestore.collection('wallets').doc(userId).get();
    if (!doc.exists) return null;
    return WalletModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateWallet(WalletModel wallet) async {
    await firestore.collection('wallets').doc(wallet.userId).set(wallet.toMap());
  }
}
