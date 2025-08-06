import 'package:dartz/dartz.dart';
import 'package:halaqaa/features/main/domain/repositories/memorization_repository.dart';

class ExportDataUseCase {
  final MemorizationRepository repository;

  ExportDataUseCase(this.repository);

  Future<Either<String, Unit>> call() {
    return repository.exportData();
  }
}
