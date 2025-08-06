import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';

abstract class StudentRepository {
  Future<Either<String, List<Student>>> getStudentsByCircle(String circleId);
  Future<Either<String, Student>> createStudent(Student student);
  Future<Either<String, Unit>> deleteStudent(String id);
  Future<Either<String, Student>> updateStudent(Student student);
  Future<Either<String, Student>> getStudentById(String studentId);
}
