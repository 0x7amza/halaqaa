import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';

class GetStudentSessions {
  final SessionRepository repository;

  GetStudentSessions(this.repository);

  Future<Either<String, List<Session>>> call(String params) async {
    return await repository.getStudentSessions(params);
  }
}

class AddSession {
  final SessionRepository repository;

  AddSession(this.repository);

  Future<Either<String, Unit>> call(Session params) async {
    return await repository.addSession(params);
  }
}

class UpdateSession {
  final SessionRepository repository;

  UpdateSession(this.repository);

  Future<Either<String, Unit>> call(Session params) async {
    return await repository.updateSession(params);
  }
}

class DeleteSession {
  final SessionRepository repository;

  DeleteSession(this.repository);

  Future<Either<String, Unit>> call(String sessionId) async {
    return await repository.deleteSession(sessionId);
  }
}
