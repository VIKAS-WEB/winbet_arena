import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winbet_arena/data/models/team_model.dart';

abstract class TeamRemoteDataSource {
  Stream<List<TeamModel>> getTrendingTeams();
  Future<TeamModel?> getTeam(String teamId);
  Future<void> followTeam(String teamId, String userId);
  Future<void> unfollowTeam(String teamId, String userId);
  Future<void> createTeam(TeamModel team);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final FirebaseFirestore firestore;
  TeamRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<TeamModel>> getTrendingTeams() {
    return firestore
        .collection('teams')
        .orderBy('trendingScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TeamModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<TeamModel?> getTeam(String teamId) async {
    final doc = await firestore.collection('teams').doc(teamId).get();
    if (!doc.exists) return null;
    return TeamModel.fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> followTeam(String teamId, String userId) async {
    await firestore.collection('teams').doc(teamId).update({
      'followers': FieldValue.increment(1),
    });
    await firestore.collection('users').doc(userId).update({
      'followedTeams': FieldValue.arrayUnion([teamId]),
    });
  }

  @override
  Future<void> unfollowTeam(String teamId, String userId) async {
    await firestore.collection('teams').doc(teamId).update({
      'followers': FieldValue.increment(-1),
    });
    await firestore.collection('users').doc(userId).update({
      'followedTeams': FieldValue.arrayRemove([teamId]),
    });
  }
  @override
  Future<void> createTeam(TeamModel team) async {
    await firestore.collection('teams').add(team.toMap());
  }
}
