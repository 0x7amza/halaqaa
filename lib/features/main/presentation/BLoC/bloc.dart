import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/domain/usecases/create_circle_usecase.dart';
import 'package:halaqaa/features/main/domain/usecases/export_data_usecase.dart';
import 'package:halaqaa/features/main/domain/usecases/get_circles_usecase.dart';
import 'package:halaqaa/features/main/presentation/BLoC/events.dart';
import 'package:halaqaa/features/main/presentation/BLoC/states.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetCirclesUseCase getCirclesUseCase;
  final CreateCircleUseCase createCircleUseCase;
  final ExportDataUseCase exportDataUseCase;

  DashboardBloc({
    required this.getCirclesUseCase,
    required this.createCircleUseCase,
    required this.exportDataUseCase,
  }) : super(DashboardInitial()) {
    on<LoadCirclesEvent>(_onLoadCircles);
    on<CreateCircleEvent>(_onCreateCircle);
    on<ExportDataEvent>(_onExportData);
  }

  Future<void> _onLoadCircles(
    LoadCirclesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await getCirclesUseCase();
    result.fold((error) => emit(DashboardError(message: error)), (circles) {
      int totalStudents = 0;
      for (var circle in circles) {
        totalStudents += circle.studentsCount;
      }
      emit(DashboardLoaded(circles: circles, totalStudents: totalStudents));
    });
  }

  Future<void> _onCreateCircle(
    CreateCircleEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      final newCircle = MemorizationCircle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
        studentsCount: 0,
        activeStudentsCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await createCircleUseCase(newCircle);
      result.fold((error) => emit(DashboardError(message: error)), (circle) {
        final updatedCircles = [...currentState.circles, circle];
        final totalStudents = updatedCircles.fold<int>(
          0,
          (sum, c) => sum + c.studentsCount,
        );
        emit(
          DashboardLoaded(
            circles: updatedCircles,
            totalStudents: totalStudents,
          ),
        );
      });
    }
  }

  Future<void> _onExportData(
    ExportDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await exportDataUseCase();
    result.fold(
      (error) => emit(DashboardError(message: error)),
      (_) => emit(const DashboardSuccess(message: 'تم تصدير البيانات بنجاح')),
    );
  }
}
