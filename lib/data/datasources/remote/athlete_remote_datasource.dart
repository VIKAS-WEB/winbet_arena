import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/athlete_model.dart';

abstract class AthleteRemoteDataSource {
  Stream<List<AthleteModel>> getTrendingAthletes();
  Future<AthleteModel?> getAthlete(String athleteId);
}

class AthleteRemoteDataSourceImpl implements AthleteRemoteDataSource {
  final FirebaseFirestore firestore;
  AthleteRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<AthleteModel>> getTrendingAthletes() {
    return firestore
        .collection('athletes')
        .orderBy('stats.performance', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AthleteModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<AthleteModel?> getAthlete(String athleteId) async {
    final doc = await firestore.collection('athletes').doc(athleteId).get();
    if (!doc.exists) return null;
    return AthleteModel.fromMap(doc.data()!, doc.id);
  }
}
