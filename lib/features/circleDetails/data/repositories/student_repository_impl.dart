import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/student_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentRepositoryImpl implements StudentRepository {
  static const String _boxName = 'students';

  Box<Student> get _box => Hive.box<Student>(_boxName);

  @override
  Future<Either<String, List<Student>>> getStudentsByCircle(
    String circleId,
  ) async {
    try {
      final allStudents = _box.values.toList();
      final circleStudents = allStudents
          .where((student) => student.circleId == circleId)
          .toList();

      return Right(circleStudents);
    } catch (e) {
      return Left('فشل في تحميل الطلاب: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Student>> createStudent(Student student) async {
    try {
      await _box.put(student.id, student);
      return Right(student);
    } catch (e) {
      return Left('فشل في إضافة الطالب: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Unit>> deleteStudent(String id) async {
    try {
      await _box.delete(id);
      return const Right(unit);
    } catch (e) {
      return Left('فشل في حذف الطالب: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Student>> updateStudent(Student student) async {
    try {
      await _box.put(student.id, student);
      return Right(student);
    } catch (e) {
      return Left('فشل في تحديث الطالب: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Student>> getStudentById(String studentId) {
    try {
      final student = _box.get(studentId);
      if (student != null) {
        return Future.value(Right(student));
      } else {
        return Future.value(Left('الطالب غير موجود'));
      }
    } catch (e) {
      return Future.value(Left('فشل في تحميل الطالب: ${e.toString()}'));
    }
  }
}
