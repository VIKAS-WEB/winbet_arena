import '../../domain/entities/bet.dart';

class BetModel extends Bet {
  const BetModel({
    required super.id,
    required super.userId,
    required super.teamId,
    required super.stake,
    required super.status,
  });

  factory BetModel.fromMap(Map<String, dynamic> map, String id) {
    return BetModel(
      id: id,
      userId: map['userId'],
      teamId: map['teamId'],
      stake: (map['stake'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'teamId': teamId,
      'stake': stake,
      'status': status,
    };
  }
}
