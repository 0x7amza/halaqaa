import 'package:equatable/equatable.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';

abstract class StudentDetailState extends Equatable {
  const StudentDetailState();

  @override
  List<Object> get props => [];
}

class StudentDetailInitial extends StudentDetailState {}

class StudentDetailLoading extends StudentDetailState {}

class StudentDetailLoaded extends StudentDetailState {
  final Student student;
  final List<Session> sessions;

  const StudentDetailLoaded({required this.student, required this.sessions});

  @override
  List<Object> get props => [student, sessions];
}

class StudentDetailError extends StudentDetailState {
  final String message;

  const StudentDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class SessionAdded extends StudentDetailState {
  final Student student;
  final List<Session> sessions;

  const SessionAdded({required this.student, required this.sessions});

  @override
  List<Object> get props => [student, sessions];
}
