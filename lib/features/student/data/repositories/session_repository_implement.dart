import 'package:dartz/dartz.dart';
import 'package:halaqaa/core/utils/functions.utils.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/student/domain/entities/juz_progress.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionRepositoryImplement implements SessionRepository {
  static const String _boxName = 'sessions';
  Box<Session> get _box => Hive.box<Session>(_boxName);
  Box<JuzProgress> get _juzProgressBox => Hive.box<JuzProgress>('juz_progress');
  Box<Student> get _studentBox => Hive.box<Student>('students');
  @override
  Future<Either<String, Unit>> addSession(Session session) async {
    try {
      final ayahData = await readJsonFile('ayah_data') as List<dynamic>;
      final List<int> rangeOfAyahTemp = List.generate(
        session.toAyah - session.fromAyah + 1,
        (index) => session.fromAyah + index,
      );
      final int surahNumber = int.parse(session.surahNumber);

      final List<int> rangeOfAyah = await Future.wait(
        rangeOfAyahTemp.map((ayah) async {
          if (await isAyahMemorized(surahNumber, ayah, _box)) {
            return -1;
          } else {
            return ayah;
          }
        }).toList(),
      );

      for (int ayah in rangeOfAyah) {
        if (ayah != -1) {
          final juzNumber = await getJuzOfAyah(surahNumber, ayah, ayahData);
          print(
            'Adding session: Surah $surahNumber, Ayah $ayah, Juz $juzNumber',
          );
          if (juzNumber != -1) {
            final key = '${session.studentId}_$juzNumber'; // المفتاح المركب

            final juzProgress = _juzProgressBox.get(key);
            if (juzProgress == null) {
              _juzProgressBox.put(
                key,
                JuzProgress(
                  studentId: session.studentId,
                  juzNumber: juzNumber.toString(),
                  memorizedAyahs: 1,
                  totalAyahs: await getTotalAyahsInJuz(juzNumber),
                  lastUpdated: DateTime.now(),
                ),
              );
              // update currentPart to juzNumber
              final student = _studentBox.get(session.studentId);
              if (student != null) {
                _studentBox.put(
                  session.studentId,
                  student.copyWith(currentPart: juzNumber.toInt()),
                );
                print(
                  'Updated student ${student.name} currentPart to ${juzNumber.toInt()}',
                );
              }
            } else {
              _juzProgressBox.put(
                key,
                juzProgress.copyWith(
                  memorizedAyahs: juzProgress.memorizedAyahs + 1,
                  lastUpdated: DateTime.now(),
                ),
              );
              print(
                'Updated juzProgress for Juz $juzNumber: ${juzProgress.memorizedAyahs + 1} / ${juzProgress.totalAyahs}',
              );

              // update currentPart to juzNumber
              final student = _studentBox.get(session.studentId);
              if (student != null) {
                _studentBox.put(
                  session.studentId,
                  student.copyWith(currentPart: juzNumber.toInt()),
                );
                print(
                  'Updated student ${student.name} currentPart to ${juzNumber.toInt()}',
                );
              }
            }
          }
        }
      }
      _box.put(session.id, session);
      return Future.value(Right(unit));
    } catch (e) {
      return Future.value(Left('Failed to add session: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, Unit>> deleteSession(String sessionId) {
    try {
      _box.delete(sessionId);
      return Future.value(Right(unit));
    } catch (e) {
      return Future.value(Left('Failed to delete session: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, List<Session>>> getStudentSessions(String studentId) {
    try {
      final sessions =
          _box.values
              .where((session) => session.studentId == studentId)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      return Future.value(Right(sessions));
    } catch (e) {
      return Future.value(Left('Failed to load sessions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, Unit>> updateSession(Session session) {
    try {
      _box.put(session.id, session);
      return Future.value(Right(unit));
    } catch (e) {
      return Future.value(Left('Failed to update session: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, List<JuzProgress>>> getQuranParts(String studentId) {
    try {
      final parts = _juzProgressBox.values
          .where((juz) => juz.studentId == studentId)
          .toList();
      return Future.value(Right(parts));
    } catch (e) {
      return Future.value(Left('Failed to load Quran parts: ${e.toString()}'));
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> exportStudentData(
    String studentId,
  ) async {
    try {
      final student = _studentBox.get(studentId);
      if (student == null) {
        return Left('Student not found');
      }

      // تأكيد أن الجلسات ليست null وتحويلها بشكل آمن
      final sessions = _box.values
          .where((session) => session.studentId == studentId)
          .map<Map<String, dynamic>>((session) => session.toJson())
          .toList();

      // تأكيد أن تقدم الأجزاء ليس null وتحويله بشكل آمن
      final juzProgress = _juzProgressBox.values
          .where((juz) => juz.studentId == studentId)
          .map<Map<String, dynamic>>((juz) => juz.toJson())
          .toList();

      return Right({
        'student': student.toJson(),
        'sessions': sessions,
        'juzProgress': juzProgress,
      });
    } catch (e) {
      return Left('Failed to export student data: ${e.toString()}');
    }
  }
}
