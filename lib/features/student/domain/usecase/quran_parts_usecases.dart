import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/student/domain/entities/juz_progress.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';

class GetQuranParts {
  // Define your use cases here
  final SessionRepository _repository;

  GetQuranParts(this._repository);

  Future<Either<String, List<JuzProgress>>> call(String studentId) async {
    final parts = await _repository.getQuranParts(studentId);

    return parts;
  }
}
