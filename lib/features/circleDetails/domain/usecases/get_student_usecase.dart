import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/student_repository.dart';

class GetStudentsByCircleUseCase {
  final StudentRepository repository;

  GetStudentsByCircleUseCase(this.repository);

  Future<Either<String, List<Student>>> call(String circleId) {
    return repository.getStudentsByCircle(circleId);
  }
}
