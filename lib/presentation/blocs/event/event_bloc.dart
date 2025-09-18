import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// Event Model
class Event {
  final String id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      status: data['status'] ?? '',
    );
  }
}

// Bloc Events
abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {}
class CreateEvent extends EventEvent {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  CreateEvent({required this.title, required this.description, required this.startTime, required this.endTime});
  @override
  List<Object?> get props => [title, description, startTime, endTime];
}

// Bloc States
abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}
class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventLoaded extends EventState {
  final List<Event> events;
  EventLoaded(this.events);
  @override
  List<Object?> get props => [events];
}
class EventError extends EventState {
  final String message;
  EventError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc Implementation
class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<CreateEvent>(_onCreateEvent);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('status', isEqualTo: 'ongoing')
          .get();
      final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> _onCreateEvent(CreateEvent event, Emitter<EventState> emit) async {
    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': event.title,
        'description': event.description,
        'startTime': event.startTime.toIso8601String(),
        'endTime': event.endTime.toIso8601String(),
        'status': 'ongoing',
      });
      add(LoadEvents());
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}
