import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/remote/wallet_remote_datasource.dart';
import '../../../data/models/wallet_model.dart';

// Events
abstract class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoadWallet extends WalletEvent {
  final String userId;
  LoadWallet(this.userId);
  @override
  List<Object?> get props => [userId];
}
class AddCredits extends WalletEvent {
  final String userId;
  final double amount;
  AddCredits(this.userId, this.amount);
  @override
  List<Object?> get props => [userId, amount];
}

// States
abstract class WalletState extends Equatable {
  @override
  List<Object?> get props => [];
}
class WalletInitial extends WalletState {}
class WalletLoading extends WalletState {}
class WalletLoaded extends WalletState {
  final WalletModel wallet;
  WalletLoaded(this.wallet);
  @override
  List<Object?> get props => [wallet];
}
class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRemoteDataSource remote;
  WalletBloc(this.remote) : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<AddCredits>(_onAddCredits);
  }

  Future<void> _onLoadWallet(LoadWallet event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final wallet = await remote.getWallet(event.userId);
      if (wallet == null) {
        // Create wallet with default credits
        final newWallet = WalletModel(userId: event.userId, credits: 1000);
        await remote.updateWallet(newWallet);
        emit(WalletLoaded(newWallet));
      } else {
        emit(WalletLoaded(wallet));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onAddCredits(AddCredits event, Emitter<WalletState> emit) async {
    try {
      final wallet = await remote.getWallet(event.userId);
      if (wallet != null) {
        final updated = WalletModel(userId: wallet.userId, credits: wallet.credits + event.amount);
        await remote.updateWallet(updated);
        emit(WalletLoaded(updated));
      }
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }
}
