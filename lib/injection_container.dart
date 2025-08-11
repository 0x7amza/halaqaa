import 'package:get_it/get_it.dart';
import 'package:halaqaa/core/BLoC/DropDown/drop_down_bloc.dart';
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
import 'package:halaqaa/features/student/data/models/juz_progress_adapter.dart';
import 'package:halaqaa/features/student/data/models/session_adapter.dart';
import 'package:halaqaa/features/student/data/repositories/session_repository_implement.dart';
import 'package:halaqaa/features/student/domain/entities/juz_progress.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/repositories/session_repository.dart';
import 'package:halaqaa/features/student/domain/usecase/quran_parts_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/sessions_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/student_usecases.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/bloc.dart';
import 'package:hive/hive.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize Hive
  await MemorizationRepositoryImpl.init();
  // await Hive.deleteBoxFromDisk('memorization_circles');
  // await Hive.deleteBoxFromDisk('students');
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(JuzProgressAdapter());

  await Hive.openBox<MemorizationCircle>('memorization_circles');
  await Hive.openBox<Student>('students');
  await Hive.openBox<Session>('sessions');
  await Hive.openBox<JuzProgress>('juz_progress');

  // Core - bloc
  getIt.registerFactory(() => DropDownBloc());
  // Repository
  getIt.registerLazySingleton<MemorizationRepository>(
    () => MemorizationRepositoryImpl(),
  );

  // Use Cases

  // BLoC
  getIt.registerFactory(
    () => DashboardBloc(
      getCirclesUseCase: getIt(),
      createCircleUseCase: getIt(),
      exportDataUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => QuranPartsBloc(
      getQuranParts: getIt(),
      getStudentSessions: getIt(),
      getStudentById: getIt(),
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
  getIt.registerLazySingleton(() => UpdateCircleUseCase(getIt()));
  getIt.registerLazySingleton(() => GetQuranParts(getIt()));
  getIt.registerLazySingleton(() => GetCirclesUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateCircleUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportDataUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCircleByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => ExportStudentData(getIt()));

  // BLoC
  getIt.registerFactory(
    () => CircleDetailsBloc(
      getStudentsByCircleUseCase: getIt(),
      createStudentUseCase: getIt(),
      getCircleByIdUseCase: getIt(),
      updateCircleUseCase: getIt(),
      exportStudentData: getIt(),
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
