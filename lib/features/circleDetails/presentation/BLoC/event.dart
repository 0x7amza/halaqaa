import 'package:equatable/equatable.dart';

abstract class CircleDetailsEvent extends Equatable {
  const CircleDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadCircleDetailsEvent extends CircleDetailsEvent {
  final String circleId;

  const LoadCircleDetailsEvent({required this.circleId});

  @override
  List<Object> get props => [circleId];
}

class AddStudentEvent extends CircleDetailsEvent {
  final String name;
  final String type;
  final String circleId;

  const AddStudentEvent({
    required this.name,
    required this.type,
    required this.circleId,
  });

  @override
  List<Object> get props => [name, type, circleId];
}

class ExportStudentDataEvent extends CircleDetailsEvent {
  final String studentId;

  const ExportStudentDataEvent({required this.studentId});

  @override
  List<Object> get props => [studentId];
}
