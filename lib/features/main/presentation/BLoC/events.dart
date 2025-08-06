import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadCirclesEvent extends DashboardEvent {}

class CreateCircleEvent extends DashboardEvent {
  final String name;
  final String description;

  const CreateCircleEvent({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}

class ExportDataEvent extends DashboardEvent {}
