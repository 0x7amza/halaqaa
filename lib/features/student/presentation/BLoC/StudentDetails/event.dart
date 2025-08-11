import 'package:equatable/equatable.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';

abstract class StudentDetailEvent extends Equatable {
  const StudentDetailEvent();

  @override
  List<Object> get props => [];
}

class GetStudentDetailEvent extends StudentDetailEvent {
  final String studentId;

  const GetStudentDetailEvent({required this.studentId});

  @override
  List<Object> get props => [studentId];
}

class AddSessionEvent extends StudentDetailEvent {
  final Session session;

  const AddSessionEvent({required this.session});

  @override
  List<Object> get props => [session];
}

class RefreshStudentDetailEvent extends StudentDetailEvent {
  final String studentId;

  const RefreshStudentDetailEvent({required this.studentId});

  @override
  List<Object> get props => [studentId];
}
