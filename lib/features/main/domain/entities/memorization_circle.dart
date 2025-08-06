import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class MemorizationCircle extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int studentsCount;

  @HiveField(4)
  final int activeStudentsCount;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  const MemorizationCircle({
    required this.id,
    required this.name,
    required this.description,
    required this.studentsCount,
    required this.activeStudentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    studentsCount,
    activeStudentsCount,
    createdAt,
    updatedAt,
  ];
}
