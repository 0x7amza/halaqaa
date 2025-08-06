import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/domain/repositories/memorization_repository.dart';

class CreateCircleUseCase {
  final MemorizationRepository repository;

  CreateCircleUseCase(this.repository);

  Future<Either<String, MemorizationCircle>> call(MemorizationCircle circle) {
    return repository.createCircle(circle);
  }
}
