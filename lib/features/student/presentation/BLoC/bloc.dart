import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/features/student/domain/usecase/sessions_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/student_usecases.dart';
import 'package:halaqaa/features/student/presentation/BLoC/event.dart';
import 'package:halaqaa/features/student/presentation/BLoC/state.dart';

class StudentDetailBloc extends Bloc<StudentDetailEvent, StudentDetailState> {
  final GetStudentById getStudentById;
  final GetStudentSessions getStudentSessions;
  final AddSession addSession;

  StudentDetailBloc({
    required this.getStudentById,
    required this.getStudentSessions,
    required this.addSession,
  }) : super(StudentDetailInitial()) {
    on<GetStudentDetailEvent>(_onGetStudentDetail);
    on<AddSessionEvent>(_onAddSession);
    on<RefreshStudentDetailEvent>(_onRefreshStudentDetail);
  }

  Future<void> _onGetStudentDetail(
    GetStudentDetailEvent event,
    Emitter<StudentDetailState> emit,
  ) async {
    emit(StudentDetailLoading());

    final studentResult = await getStudentById(event.studentId);
    final sessionsResult = await getStudentSessions(event.studentId);

    await studentResult.fold(
      (failure) async => emit(StudentDetailError(message: (failure))),
      (student) async {
        await sessionsResult.fold(
          (failure) async => emit(StudentDetailError(message: (failure))),
          (sessions) async =>
              emit(StudentDetailLoaded(student: student, sessions: sessions)),
        );
      },
    );
  }

  Future<void> _onAddSession(
    AddSessionEvent event,
    Emitter<StudentDetailState> emit,
  ) async {
    if (state is StudentDetailLoaded) {
      final currentState = state as StudentDetailLoaded;

      final result = await addSession(event.session);

      await result.fold(
        (failure) async => emit(StudentDetailError(message: failure)),
        (_) async {
          add(RefreshStudentDetailEvent(studentId: event.session.studentId));
        },
      );
    }
  }

  Future<void> _onRefreshStudentDetail(
    RefreshStudentDetailEvent event,
    Emitter<StudentDetailState> emit,
  ) async {
    final studentResult = await getStudentById(event.studentId);
    final sessionsResult = await getStudentSessions(event.studentId);

    await studentResult.fold(
      (failure) async => emit(StudentDetailError(message: failure)),
      (student) async {
        await sessionsResult.fold(
          (failure) async => emit(StudentDetailError(message: failure)),
          (sessions) async =>
              emit(SessionAdded(student: student, sessions: sessions)),
        );
      },
    );
  }
}
