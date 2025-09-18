import 'package:equatable/equatable.dart';
import 'package:winbet_arena/domain/entities/bet.dart';

abstract class BetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlaceBetEvent extends BetEvent {
  final Bet bet;
  PlaceBetEvent(this.bet);

  @override
  List<Object?> get props => [bet];
}
