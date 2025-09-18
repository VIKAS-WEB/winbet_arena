import '../../domain/entities/athlete.dart';

class AthleteModel extends Athlete {
  const AthleteModel({
    required super.id,
    required super.name,
    required super.photoUrl,
    required super.stats,
    required super.teamIds,
  });

  factory AthleteModel.fromMap(Map<String, dynamic> map, String id) {
    return AthleteModel(
      id: id,
      name: map['name'],
      photoUrl: map['photoUrl'],
      stats: Map<String, dynamic>.from(map['stats'] ?? {}),
      teamIds: List<String>.from(map['teamIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'stats': stats,
      'teamIds': teamIds,
    };
  }
}
