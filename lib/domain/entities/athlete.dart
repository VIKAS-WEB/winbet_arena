import 'package:equatable/equatable.dart';

class Athlete extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final Map<String, dynamic> stats;
  final List<String> teamIds;

  const Athlete({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.stats,
    required this.teamIds,
  });

  @override
  List<Object?> get props => [id, name, photoUrl, stats, teamIds];
}
