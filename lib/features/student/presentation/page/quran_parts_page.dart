import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_event.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_state.dart';
import 'package:halaqaa/features/student/presentation/widgets/quran_parts_grid.dart';
import 'package:halaqaa/features/student/presentation/widgets/user_stats_card.dart';
import 'package:halaqaa/injection_container.dart';
import 'package:halaqaa/core/size.dart';

class QuranPartsPage extends StatelessWidget {
  final String studentId;
  const QuranPartsPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<QuranPartsBloc>()..add(LoadQuranParts(studentId: studentId)),
      child: QuranPartsPageWidget(studentId: studentId),
    );
  }
}

class QuranPartsPageWidget extends StatelessWidget {
  final String studentId;
  const QuranPartsPageWidget({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'أجزاء القرآن الكريم',
          style: TextStyle(
            color: const Color(0xFF4A5568),
            fontSize: SizeConfig().sp(18), // Scaled font size
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<QuranPartsBloc, QuranPartsState>(
                builder: (context, state) {
                  if (state is QuranPartsLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF48BB78),
                        ),
                      ),
                    );
                  } else if (state is QuranPartsLoaded) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig().wp(4.3),
                      ), // 16px horizontal padding
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig().hp(0.83),
                          ), // 20px height
                          UserStatsCard(
                            student: state.student,
                            totalDays: state.totalDays,
                            overallProgress: state.overallProgress,
                            completedJuz: state.completedJuz,
                          ),
                          SizedBox(
                            height: SizeConfig().hp(1.25),
                          ), // 30px height
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أجزاء القرآن الكريم',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(
                                  20,
                                ), // Scaled font size
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig().hp(0.67),
                          ), // 16px height
                          QuranPartsGrid(parts: state.parts),
                          SizedBox(
                            height: SizeConfig().hp(0.83),
                          ), // 20px height
                        ],
                      ),
                    );
                  } else if (state is QuranPartsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: SizeConfig().wp(17.1),
                            color: Colors.red,
                          ), // 64px icon
                          SizedBox(
                            height: SizeConfig().hp(0.67),
                          ), // 16px height
                          Text(
                            'حدث خطأ: ${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: SizeConfig().sp(16),
                            ), // Scaled font size
                          ),
                          SizedBox(
                            height: SizeConfig().hp(0.67),
                          ), // 16px height
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuranPartsBloc>().add(
                                LoadQuranParts(studentId: studentId),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF48BB78),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig if used independently

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig().wp(2.1),
        vertical: SizeConfig().hp(0.5),
      ), // 8px horizontal, 12px vertical
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig().wp(1.07), // 4px blur
            offset: Offset(0, SizeConfig().hp(0.083)), // 2px offset
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xFF4A5568),
              size: SizeConfig().wp(5.3), // 20px icon
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Row(
            children: [
              Text(
                'أجزاء القرآن',
                style: TextStyle(
                  fontSize: SizeConfig().sp(18), // Scaled font size
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: SizeConfig().wp(2.1)), // 8px width
              Container(
                padding: EdgeInsets.all(SizeConfig().wp(2.1)), // 8px padding
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(2.1),
                  ), // 8px radius
                ),
                child: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                  size: SizeConfig().wp(5.3),
                ), // 20px icon
              ),
            ],
          ),
          SizedBox(width: SizeConfig().wp(2.1)), // 8px width
        ],
      ),
    );
  }
}
