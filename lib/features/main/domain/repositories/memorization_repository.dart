import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';

abstract class MemorizationRepository {
  Future<Either<String, List<MemorizationCircle>>> getCircles();
  Future<Either<String, MemorizationCircle>> createCircle(
    MemorizationCircle circle,
  );
  Future<Either<String, Unit>> deleteCircle(String id);
  Future<Either<String, Unit>> exportData();
}
