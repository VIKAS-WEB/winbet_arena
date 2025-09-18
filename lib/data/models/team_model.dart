import '../../domain/entities/team.dart';

class TeamModel extends Team {
  const TeamModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.followers,
    required super.trendingScore,
    required super.athleteIds,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map, String id) {
    return TeamModel(
      id: id,
      name: map['name'],
      logoUrl: map['logoUrl'],
      followers: map['followers'] ?? 0,
      trendingScore: (map['trendingScore'] ?? 0).toDouble(),
      athleteIds: List<String>.from(map['athleteIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
      'followers': followers,
      'trendingScore': trendingScore,
      'athleteIds': athleteIds,
    };
  }
}
