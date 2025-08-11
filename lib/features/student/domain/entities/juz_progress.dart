import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class JuzProgress extends Equatable {
  @HiveField(0)
  final String studentId;

  @HiveField(1)
  final String juzNumber;

  @HiveField(2)
  final int totalAyahs;

  @HiveField(3)
  final int memorizedAyahs;

  @HiveField(4)
  final DateTime lastUpdated;

  const JuzProgress({
    required this.studentId,
    required this.juzNumber,
    required this.totalAyahs,
    required this.memorizedAyahs,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    studentId,
    juzNumber,
    totalAyahs,
    memorizedAyahs,
    lastUpdated,
  ];

  JuzProgress copyWith({
    required int memorizedAyahs,
    required DateTime lastUpdated,
  }) {
    return JuzProgress(
      studentId: studentId,
      juzNumber: juzNumber,
      totalAyahs: totalAyahs,
      memorizedAyahs: memorizedAyahs,
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'juzNumber': juzNumber,
      'totalAyahs': totalAyahs,
      'memorizedAyahs': memorizedAyahs,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
