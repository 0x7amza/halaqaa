import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/circle_usecases.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/create_student_usecase.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/get_student_usecase.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/event.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/state.dart';

class CircleDetailsBloc extends Bloc<CircleDetailsEvent, CircleDetailsState> {
  final GetStudentsByCircleUseCase getStudentsByCircleUseCase;
  final CreateStudentUseCase createStudentUseCase;
  final GetCircleByIdUseCase getCircleByIdUseCase;
  final UpdateCircleUseCase updateCircleUseCase;

  CircleDetailsBloc({
    required this.getStudentsByCircleUseCase,
    required this.createStudentUseCase,
    required this.getCircleByIdUseCase,
    required this.updateCircleUseCase,
  }) : super(CircleDetailsInitial()) {
    on<LoadCircleDetailsEvent>(_onLoadCircleDetails);
    on<AddStudentEvent>(_onAddStudent);
  }

  Future<void> _onLoadCircleDetails(
    LoadCircleDetailsEvent event,
    Emitter<CircleDetailsState> emit,
  ) async {
    emit(CircleDetailsLoading());

    try {
      // Load circle details
      final circleResult = await getCircleByIdUseCase(event.circleId);
      final studentsResult = await getStudentsByCircleUseCase(event.circleId);

      final circle = circleResult.fold((error) => null, (circle) => circle);

      final students = studentsResult.fold(
        (error) => <Student>[],
        (students) => students,
      );

      if (circle != null) {
        // Update circle statistics
        final activeStudents = students
            .where((s) => s.status == 'active')
            .length;
        final updatedCircle = MemorizationCircle(
          id: circle.id,
          name: circle.name,
          description: circle.description,
          studentsCount: students.length,
          activeStudentsCount: activeStudents,
          createdAt: circle.createdAt,
          updatedAt: DateTime.now(),
        );

        // Save updated circle
        await updateCircleUseCase(updatedCircle);

        emit(CircleDetailsLoaded(students: students, circle: updatedCircle));
      } else {
        // Create default circle if not found
        final defaultCircle = MemorizationCircle(
          id: event.circleId,
          name: 'حلقة الفجر',
          description: 'حلقة تحفيظ القرآن لطلاب الصباح',
          studentsCount: students.length,
          activeStudentsCount: students
              .where((s) => s.status == 'active')
              .length,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await updateCircleUseCase(defaultCircle);
        emit(CircleDetailsLoaded(students: students, circle: defaultCircle));
      }
    } catch (e) {
      emit(
        CircleDetailsError(message: 'فشل في تحميل البيانات: ${e.toString()}'),
      );
    }
  }

  Future<void> _onAddStudent(
    AddStudentEvent event,
    Emitter<CircleDetailsState> emit,
  ) async {
    if (state is CircleDetailsLoaded) {
      final currentState = state as CircleDetailsLoaded;

      final newStudent = Student(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        type: event.type,
        circleId: event.circleId,
        completedParts: 0,
        currentPart: 1,
        stars: 0,
        status: 'active',
        joinDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      print('Adding new student: ${newStudent.name}');

      final result = await createStudentUseCase(newStudent);
      print('Create student result: $result');

      if (result.isLeft()) {
        final error = result.fold((l) => l, (r) => null);
        emit(CircleDetailsError(message: error!));
        return; // تأكد من الخروج بعد الخطأ
      }

      final student = result.getOrElse(
        () => throw Exception('Unexpected null'),
      );

      final updatedStudents = [...currentState.students, student];
      final activeStudents = updatedStudents
          .where((s) => s.status == 'active')
          .length;

      final updatedCircle = MemorizationCircle(
        id: currentState.circle.id,
        name: currentState.circle.name,
        description: currentState.circle.description,
        studentsCount: updatedStudents.length,
        activeStudentsCount: activeStudents,
        createdAt: currentState.circle.createdAt,
        updatedAt: DateTime.now(),
      );

      await updateCircleUseCase(updatedCircle);

      emit(
        CircleDetailsLoaded(students: updatedStudents, circle: updatedCircle),
      );
    }
  }
}
