import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Session extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String studentId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String surahNumber;

  @HiveField(4)
  final int fromAyah;

  @HiveField(5)
  final int toAyah;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final String notes;

  @HiveField(8)
  final int stars;

  const Session({
    required this.id,
    required this.studentId,
    required this.date,
    required this.surahNumber,
    required this.fromAyah,
    required this.toAyah,
    required this.status,
    required this.notes,
    required this.stars,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'surahNumber': surahNumber,
      'fromAyah': fromAyah,
      'toAyah': toAyah,
      'status': status,
      'notes': notes,
      'stars': stars,
    };
  }

  @override
  List<Object?> get props => [
    id,
    studentId,
    date,
    surahNumber,
    fromAyah,
    toAyah,
    status,
    notes,
    stars,
  ];
}
