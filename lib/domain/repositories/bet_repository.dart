import '../entities/bet.dart';

abstract class BetRepository {
  Future<void> placeBet(Bet bet);
  Stream<List<Bet>> getUserBets(String userId);
}
