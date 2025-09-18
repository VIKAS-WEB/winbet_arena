import 'package:equatable/equatable.dart';

class Team extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final int followers;
  final double trendingScore;
  final List<String> athleteIds;

  const Team({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.followers,
    required this.trendingScore,
    required this.athleteIds,
  });

  @override
  List<Object?> get props => [id, name, logoUrl, followers, trendingScore, athleteIds];
}
