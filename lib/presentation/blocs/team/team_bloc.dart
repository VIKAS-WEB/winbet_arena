import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:winbet_arena/data/datasources/remote/team_remote_datasource.dart';
import 'package:winbet_arena/data/models/team_model.dart';


// Events
abstract class TeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoadTrendingTeams extends TeamEvent {}
class FollowTeam extends TeamEvent {
  final String teamId;
  final String userId;
  FollowTeam(this.teamId, this.userId);
  @override
  List<Object?> get props => [teamId, userId];
}
class UnfollowTeam extends TeamEvent {
  final String teamId;
  final String userId;
  UnfollowTeam(this.teamId, this.userId);
  @override
  List<Object?> get props => [teamId, userId];
}

// States
abstract class TeamState extends Equatable {
  @override
  List<Object?> get props => [];
}
class TeamInitial extends TeamState {}
class TeamLoading extends TeamState {}
class TeamLoaded extends TeamState {
  final List<TeamModel> teams;
  TeamLoaded(this.teams);
  @override
  List<Object?> get props => [teams];
}
class TeamError extends TeamState {
  final String message;
  TeamError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRemoteDataSource remote;
  TeamBloc(this.remote) : super(TeamInitial()) {
    on<LoadTrendingTeams>(_onLoadTrendingTeams);
    on<FollowTeam>(_onFollowTeam);
    on<UnfollowTeam>(_onUnfollowTeam);
  }

  Future<void> _onLoadTrendingTeams(LoadTrendingTeams event, Emitter<TeamState> emit) async {
    emit(TeamLoading());
    try {
      await emit.onEach<List<TeamModel>>(
        remote.getTrendingTeams(),
        onData: (teams) => emit(TeamLoaded(teams)),
        onError: (e, _) => emit(TeamError(e.toString())),
      );
    } catch (e) {
      emit(TeamError(e.toString()));
    }
  }

  Future<void> _onFollowTeam(FollowTeam event, Emitter<TeamState> emit) async {
    try {
      await remote.followTeam(event.teamId, event.userId);
      add(LoadTrendingTeams());
    } catch (e) {
      emit(TeamError(e.toString()));
    }
  }

  Future<void> _onUnfollowTeam(UnfollowTeam event, Emitter<TeamState> emit) async {
    try {
      await remote.unfollowTeam(event.teamId, event.userId);
      add(LoadTrendingTeams());
    } catch (e) {
      emit(TeamError(e.toString()));
    }
  }
}
