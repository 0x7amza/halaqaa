import 'package:get_it/get_it.dart';
import 'package:halaqaa/features/circleDetails/data/models/students_adapter.dart';
import 'package:halaqaa/features/circleDetails/data/repositories/circle_repository_impl.dart';
import 'package:halaqaa/features/circleDetails/data/repositories/student_repository_impl.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/circle_repository.dart';
import 'package:halaqaa/features/circleDetails/domain/repositories/student_repository.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/circle_usecases.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/create_student_usecase.dart';
import 'package:halaqaa/features/circleDetails/domain/usecases/get_student_usecase.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/bloc.dart';
import 'package:halaqaa/features/main/data/repositories/memorization_repository_implement.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/domain/repositories/memorization_repository.dart';
import 'package:halaqaa/features/main/domain/usecases/create_circle_usecase.dart';
import 'package:halaqaa/features/main/domain/usecases/export_data_usecase.dart';
import 'package:halaqaa/features/main/domain/usecases/get_circles_usecase.dart';
import 'package:halaqaa/features/main/presentation/BLoC/bloc.dart';
import 'package:halaqaa/features/student/data/models/session_adapter.dart';
import 'package:halaqaa/features/student/data/repositories/session_repository_implement.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';
import 'package:halaqaa/features/student/domain/usecase/sessions_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/student_usecases.dart';
import 'package:halaqaa/features/student/presentation/BLoC/bloc.dart';
import 'package:hive/hive.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize Hive
  await MemorizationRepositoryImpl.init();
  await Hive.deleteBoxFromDisk('memorization_circles');
  await Hive.deleteBoxFromDisk('students');
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(SessionAdapter());

  await Hive.openBox<MemorizationCircle>('memorization_circles');
  await Hive.openBox<Student>('students');
  await Hive.openBox<Session>('sessions');

  // Repository
  getIt.registerLazySingleton<MemorizationRepository>(
    () => MemorizationRepositoryImpl(),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetCirclesUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateCircleUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportDataUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => DashboardBloc(
      getCirclesUseCase: getIt(),
      createCircleUseCase: getIt(),
      exportDataUseCase: getIt(),
    ),
  );

  // Open Boxes

  // Repositories
  getIt.registerLazySingleton<StudentRepository>(() => StudentRepositoryImpl());

  getIt.registerLazySingleton<CircleRepositoryDeteails>(
    () => CircleRepositoryDeteailsImpl(),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetStudentsByCircleUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateStudentUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCircleByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateCircleUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => CircleDetailsBloc(
      getStudentsByCircleUseCase: getIt(),
      createStudentUseCase: getIt(),
      getCircleByIdUseCase: getIt(),
      updateCircleUseCase: getIt(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImplement(),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetStudentById(getIt()));
  getIt.registerLazySingleton(() => GetStudentSessions(getIt()));
  getIt.registerLazySingleton(() => AddSession(getIt()));

  // BLoC
  getIt.registerFactory(
    () => StudentDetailBloc(
      getStudentById: getIt(),
      getStudentSessions: getIt(),
      addSession: getIt(),
    ),
  );
}
