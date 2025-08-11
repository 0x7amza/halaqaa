import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/student_repository.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';

class GetStudentById {
  final StudentRepository repository;
  GetStudentById(this.repository);
  Future<Either<String, Student>> call(String studentId) async {
    return await repository.getStudentById(studentId);
  }
}

class ExportStudentData {
  final SessionRepository repository;
  ExportStudentData(this.repository);
  Future<Either<String, Map<String, dynamic>>> call(String studentId) async {
    return await repository.exportStudentData(studentId);
  }
}
