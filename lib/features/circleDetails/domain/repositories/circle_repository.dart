import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';

abstract class CircleRepositoryDeteails {
  Future<Either<String, MemorizationCircle?>> getCircleById(String id);
  Future<Either<String, MemorizationCircle>> updateCircle(
    MemorizationCircle circle,
  );
}
