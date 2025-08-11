import 'package:equatable/equatable.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';

abstract class CircleDetailsState extends Equatable {
  const CircleDetailsState();

  @override
  List<Object> get props => [];
}

class CircleDetailsInitial extends CircleDetailsState {}

class CircleDetailsLoading extends CircleDetailsState {}

class CircleDetailsLoaded extends CircleDetailsState {
  final List<Student> students;
  final MemorizationCircle circle;

  const CircleDetailsLoaded({required this.students, required this.circle});

  @override
  List<Object> get props => [students, circle];
}

class CircleDetailsError extends CircleDetailsState {
  final String message;

  const CircleDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

class StudentDetailsExportedState extends CircleDetailsState {
  final Map<String, dynamic> data;
  final List<Student> students;
  final MemorizationCircle circle;

  const StudentDetailsExportedState({
    required this.data,
    required this.students,
    required this.circle,
  });

  @override
  List<Object> get props => [data, students, circle];
}
