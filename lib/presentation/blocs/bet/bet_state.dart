import 'package:equatable/equatable.dart';

abstract class BetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BetInitial extends BetState {}
class BetLoading extends BetState {}
class BetSuccess extends BetState {}
class BetError extends BetState {
  final String message;
  BetError(this.message);

  @override
  List<Object?> get props => [message];
}
