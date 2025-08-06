import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionRepositoryImplement implements SessionRepository {
  static const String _boxName = 'sessions';
  Box<Session> get _box => Hive.box<Session>(_boxName);

  @override
  Future<Either<String, Unit>> addSession(Session session) {
    try {
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
      final sessions = _box.values
          .where((session) => session.studentId == studentId)
          .toList();
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
}
