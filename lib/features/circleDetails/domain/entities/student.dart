import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Student extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String circleId;

  @HiveField(4)
  final int completedParts;

  @HiveField(5)
  final int currentPart;

  @HiveField(6)
  final int stars;

  @HiveField(7)
  final String status; // 'active', 'inactive'

  @HiveField(8)
  final DateTime joinDate;

  @HiveField(9)
  final DateTime updatedAt;

  const Student({
    required this.id,
    required this.name,
    required this.type,
    required this.circleId,
    required this.completedParts,
    required this.currentPart,
    required this.stars,
    required this.status,
    required this.joinDate,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    circleId,
    completedParts,
    currentPart,
    stars,
    status,
    joinDate,
    updatedAt,
  ];

  @override
  Student copyWith({
    String? id,
    String? name,
    String? type,
    String? circleId,
    int? completedParts,
    int? currentPart,
    int? stars,
    String? status,
    DateTime? joinDate,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      circleId: circleId ?? this.circleId,
      completedParts: completedParts ?? this.completedParts,
      currentPart: currentPart ?? this.currentPart,
      stars: stars ?? this.stars,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'circleId': circleId,
      'completedParts': completedParts,
      'currentPart': currentPart,
      'stars': stars,
      'status': status,
      'joinDate': joinDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
