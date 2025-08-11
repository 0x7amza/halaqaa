import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/model/quran_part_model.dart';
import 'package:halaqaa/core/utils/string.utils.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/student/domain/entities/juz_progress.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/domain/usecase/quran_parts_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/sessions_usecases.dart';
import 'package:halaqaa/features/student/domain/usecase/student_usecases.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_event.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_state.dart';

class QuranPartsBloc extends Bloc<QuranPartsEvent, QuranPartsState> {
  final GetQuranParts getQuranParts;
  final GetStudentSessions getStudentSessions;
  final GetStudentById getStudentById;

  QuranPartsBloc({
    required this.getQuranParts,
    required this.getStudentSessions,
    required this.getStudentById,
  }) : super(QuranPartsInitial()) {
    on<LoadQuranParts>(_onLoadQuranParts);
  }

  Future<void> _onLoadQuranParts(
    LoadQuranParts event,
    Emitter<QuranPartsState> emit,
  ) async {
    emit(QuranPartsLoading());
    try {
      // Get student data
      final studentResult = await getStudentById(event.studentId);
      late Student student;

      studentResult.fold(
        (failure) => throw Exception(failure),
        (studentData) => student = studentData,
      );

      // Get sessions to count days
      final sessionsResult = await getStudentSessions(event.studentId);
      late List<Session> sessions;

      sessionsResult.fold(
        (failure) => throw Exception(failure),
        (sessionsList) => sessions = sessionsList,
      );

      // Get juz progress data
      final partsResult = await getQuranParts(event.studentId);
      late List<JuzProgress> juzProgressList;
      print('result : $partsResult');
      partsResult.fold(
        (failure) => juzProgressList = [],
        (partsList) => juzProgressList = partsList,
      );
      print('Juz Progress List: $juzProgressList');
      // Create QuranPartModel list combining all juz data
      List<QuranPartModel> allParts = [];
      int totalMemorizedAyahs = 0;
      int totalAyahs = 0;
      int completedJuz = 0;
      for (int i = 1; i <= 30; i++) {
        print('---------------------');
        final juzData = juzInfo.firstWhere((juz) => juz['juz'] == i);
        final existingProgress = juzProgressList
            .cast<JuzProgress?>()
            .firstWhere(
              (progress) => progress?.juzNumber == i.toString(),
              orElse: () => null,
            );
        print(existingProgress);
        final int memorizedAyahs = existingProgress?.memorizedAyahs ?? 0;
        final int ayahCount = juzData['ayahCount'] as int;
        final int progress = ayahCount > 0
            ? ((memorizedAyahs / ayahCount) * 100).round()
            : 0;

        totalMemorizedAyahs += memorizedAyahs;
        totalAyahs += ayahCount;

        print('Juz $i: $memorizedAyahs / $ayahCount');
        print('Juz $i Progress: $progress%');
        String status = 'لم يبدأ';
        int stars = 0;
        bool isLocked = memorizedAyahs == 0; // Lock juz if no ayahs memorized

        if (progress == 100) {
          status = 'مكتمل';
          completedJuz++;
          stars = 3;
        } else if (progress > 0) {
          status = 'جاري العمل';
          stars = progress > 50 ? 2 : 1;
        }

        // Current juz should not be locked
        if (i == student.currentPart) {
          isLocked = false;
        }

        allParts.add(
          QuranPartModel(
            id: i,
            arabicName: _getJuzName(i),
            progress: progress,
            status: status,
            stars: stars,
            isLocked: isLocked,
            lastReviewDate:
                existingProgress?.lastUpdated.toString().substring(0, 10) ??
                'غير محدد',
            totalAyahs: ayahCount,
            memorizedAyahs: memorizedAyahs,
          ),
        );
      }

      final overallProgress = totalAyahs > 0
          ? ((totalMemorizedAyahs / totalAyahs) * 100).round()
          : 0;
      final uniqueDays = sessions
          .map((s) => s.date.toString().substring(0, 10))
          .toSet()
          .length;

      emit(
        QuranPartsLoaded(
          parts: allParts,
          student: student,
          totalDays: uniqueDays,
          overallProgress: overallProgress,
          completedJuz: completedJuz,
        ),
      );
    } catch (e) {
      emit(QuranPartsError(message: e.toString()));
    }
  }

  String _getJuzName(int juzNumber) {
    switch (juzNumber) {
      case 1:
        return 'الم';
      case 2:
        return 'سيقول السفهاء';
      case 3:
        return 'تلك الرسل';
      case 4:
        return 'لن تنالوا البر';
      case 5:
        return 'والمحصنات';
      case 6:
        return 'لا يحب الله';
      case 7:
        return 'وإذا سمعوا';
      case 8:
        return 'ولو أننا';
      case 9:
        return 'قال الملأ';
      case 10:
        return 'واعلموا';
      case 11:
        return 'يعتذرون';
      case 12:
        return 'وما من دابة';
      case 13:
        return 'وما أبرئ';
      case 14:
        return 'ربما';
      case 15:
        return 'سبحان الذي';
      case 16:
        return 'قال ألم';
      case 17:
        return 'اقترب للناس';
      case 18:
        return 'قد أفلح';
      case 19:
        return 'وقال الذين';
      case 20:
        return 'أمن خلق';
      case 21:
        return 'اتل ما أوحي';
      case 22:
        return 'ومن يقنت';
      case 23:
        return 'وما أنزلنا';
      case 24:
        return 'فمن أظلم';
      case 25:
        return 'إليه يرد';
      case 26:
        return 'حم';
      case 27:
        return 'قال فما خطبكم';
      case 28:
        return 'قد سمع الله';
      case 29:
        return 'تبارك الذي';
      case 30:
        return 'عم يتساءلون';
      default:
        return 'الجزء $juzNumber';
    }
  }
}
