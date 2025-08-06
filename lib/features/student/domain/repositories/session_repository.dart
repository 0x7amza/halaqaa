import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Either<String, List<Session>>> getStudentSessions(String studentId);
  Future<Either<String, Unit>> addSession(Session session);
  Future<Either<String, Unit>> deleteSession(String sessionId);
  Future<Either<String, Unit>> updateSession(Session session);
}
