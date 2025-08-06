import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/domain/repositories/memorization_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:halaqaa/features/main/data/models/memorization_circle_adapter.dart';

class MemorizationRepositoryImpl implements MemorizationRepository {
  static const String _boxName = 'memorization_circles';

  Box<MemorizationCircle> get _box => Hive.box<MemorizationCircle>(_boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MemorizationCircleAdapter());
    await Hive.openBox<MemorizationCircle>(_boxName);
  }

  @override
  Future<Either<String, List<MemorizationCircle>>> getCircles() async {
    try {
      final circles = _box.values.toList();
      return Right(circles);
    } catch (e) {
      return Left('فشل في تحميل الحلقات: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, MemorizationCircle>> createCircle(
    MemorizationCircle circle,
  ) async {
    try {
      await _box.put(circle.id, circle);
      return Right(circle);
    } catch (e) {
      return Left('فشل في إنشاء الحلقة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Unit>> deleteCircle(String id) async {
    try {
      await _box.delete(id);
      return const Right(unit);
    } catch (e) {
      return Left('فشل في حذف الحلقة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Unit>> exportData() async {
    try {
      // Here you would implement export logic
      // For now, just simulate success
      await Future.delayed(const Duration(seconds: 1));
      return const Right(unit);
    } catch (e) {
      return Left('فشل في تصدير البيانات: ${e.toString()}');
    }
  }
}
