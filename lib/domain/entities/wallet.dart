import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String userId;
  final double credits;

  const Wallet({required this.userId, required this.credits});

  @override
  List<Object?> get props => [userId, credits];
}
