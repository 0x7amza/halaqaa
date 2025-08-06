import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/domain/repositories/memorization_repository.dart';

class GetCirclesUseCase {
  final MemorizationRepository repository;

  GetCirclesUseCase(this.repository);

  Future<Either<String, List<MemorizationCircle>>> call() {
    return repository.getCircles();
  }
}
