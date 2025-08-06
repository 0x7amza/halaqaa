import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/circle_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CircleRepositoryDeteailsImpl implements CircleRepositoryDeteails {
  static const String _boxName = 'memorization_circles';

  Box<MemorizationCircle> get _box => Hive.box<MemorizationCircle>(_boxName);

  @override
  Future<Either<String, MemorizationCircle?>> getCircleById(String id) async {
    try {
      final circle = _box.get(id);
      return Right(circle);
    } catch (e) {
      return Left('فشل في تحميل الحلقة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, MemorizationCircle>> updateCircle(
    MemorizationCircle circle,
  ) async {
    try {
      await _box.put(circle.id, circle);
      return Right(circle);
    } catch (e) {
      return Left('فشل في تحديث الحلقة: ${e.toString()}');
    }
  }
}
