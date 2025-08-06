import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/student_repository.dart';

class CreateStudentUseCase {
  final StudentRepository repository;

  CreateStudentUseCase(this.repository);

  Future<Either<String, Student>> call(Student student) {
    return repository.createStudent(student);
  }
}
