import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/circle_repository.dart';

class GetCircleByIdUseCase {
  final CircleRepositoryDeteails repository;

  GetCircleByIdUseCase(this.repository);

  Future<Either<String, MemorizationCircle?>> call(String id) {
    return repository.getCircleById(id);
  }
}

class UpdateCircleUseCase {
  final CircleRepositoryDeteails repository;

  UpdateCircleUseCase(this.repository);

  Future<Either<String, MemorizationCircle>> call(MemorizationCircle circle) {
    return repository.updateCircle(circle);
  }
}
