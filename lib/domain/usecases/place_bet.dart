import '../entities/bet.dart';
import '../repositories/bet_repository.dart';

class PlaceBet {
  final BetRepository repository;
  PlaceBet(this.repository);

  Future<void> call(Bet bet) async {
    return repository.placeBet(bet);
  }
}
