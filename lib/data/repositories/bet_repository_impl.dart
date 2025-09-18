import '../../domain/entities/bet.dart';
import '../../domain/repositories/bet_repository.dart';
import '../datasources/remote/bet_remote_datasource.dart';
import '../models/bet_model.dart';

class BetRepositoryImpl implements BetRepository {
  final BetRemoteDataSource remote;

  BetRepositoryImpl(this.remote);

  @override
  Future<void> placeBet(Bet bet) {
    return remote.placeBet(BetModel(
      id: bet.id,
      userId: bet.userId,
      teamId: bet.teamId,
      stake: bet.stake,
      status: bet.status,
    ));
  }

  @override
  Stream<List<Bet>> getUserBets(String userId) {
    return remote.getUserBets(userId);
  }
}
