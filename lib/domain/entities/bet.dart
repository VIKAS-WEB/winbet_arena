import 'package:equatable/equatable.dart';

class Bet extends Equatable {
  final String id;
  final String userId;
  final String teamId;
  final double stake;
  final String status; // pending, won, lost (but credits never deducted)

  const Bet({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.stake,
    required this.status,
  });

  @override
  List<Object?> get props => [id, userId, teamId, stake, status];
}
