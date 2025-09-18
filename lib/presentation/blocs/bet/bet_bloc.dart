import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_event.dart';
import 'package:winbet_arena/presentation/blocs/bet/bet_state.dart';
import '../../../domain/entities/bet.dart';
import '../../../domain/usecases/place_bet.dart';

class BetBloc extends Bloc<BetEvent, BetState> {
  final PlaceBet placeBet;

  BetBloc(this.placeBet) : super(BetInitial()) {
    on<PlaceBetEvent>((event, emit) async {
      emit(BetLoading());
      try {
        await placeBet(event.bet);
        emit(BetSuccess());
      } catch (e) {
        emit(BetError(e.toString()));
      }
    });
  }
}
