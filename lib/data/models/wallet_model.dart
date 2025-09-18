import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({required super.userId, required super.credits});

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      userId: map['userId'],
      credits: (map['credits'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'credits': credits,
    };
  }
}
