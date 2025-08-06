import 'package:equatable/equatable.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<MemorizationCircle> circles;
  final int totalStudents;

  const DashboardLoaded({required this.circles, required this.totalStudents});

  @override
  List<Object> get props => [circles, totalStudents];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

class DashboardSuccess extends DashboardState {
  final String message;

  const DashboardSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
