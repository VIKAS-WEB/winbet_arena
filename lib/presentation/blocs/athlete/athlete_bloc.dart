import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/datasources/remote/athlete_remote_datasource.dart';
import '../../../data/models/athlete_model.dart';

// Events
abstract class AthleteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class LoadTrendingAthletes extends AthleteEvent {}

// States
abstract class AthleteState extends Equatable {
  @override
  List<Object?> get props => [];
}
class AthleteInitial extends AthleteState {}
class AthleteLoading extends AthleteState {}
class AthleteLoaded extends AthleteState {
  final List<AthleteModel> athletes;
  AthleteLoaded(this.athletes);
  @override
  List<Object?> get props => [athletes];
}
class AthleteError extends AthleteState {
  final String message;
  AthleteError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AthleteBloc extends Bloc<AthleteEvent, AthleteState> {
  final AthleteRemoteDataSource remote;
  AthleteBloc(this.remote) : super(AthleteInitial()) {
    on<LoadTrendingAthletes>(_onLoadTrendingAthletes);
  }

  Future<void> _onLoadTrendingAthletes(LoadTrendingAthletes event, Emitter<AthleteState> emit) async {
    emit(AthleteLoading());
    try {
      await emit.onEach<List<AthleteModel>>(
        remote.getTrendingAthletes(),
        onData: (athletes) => emit(AthleteLoaded(athletes)),
        onError: (e, _) => emit(AthleteError(e.toString())),
      );
    } catch (e) {
      emit(AthleteError(e.toString()));
    }
  }
}
