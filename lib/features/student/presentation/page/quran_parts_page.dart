import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_event.dart';
import 'package:halaqaa/features/student/presentation/BLoC/QuranParts/quran_parts_state.dart';
import 'package:halaqaa/features/student/presentation/widgets/quran_parts_grid.dart';
import 'package:halaqaa/features/student/presentation/widgets/user_stats_card.dart';
import 'package:halaqaa/injection_container.dart';

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
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'أجزاء القرآن الكريم',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 18,
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
                          Color(0xFF48BB78),
                        ),
                      ),
                    );
                  } else if (state is QuranPartsLoaded) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          UserStatsCard(
                            student: state.student,
                            totalDays: state.totalDays,
                            overallProgress: state.overallProgress,
                            completedJuz: state.completedJuz,
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'أجزاء القرآن الكريم',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          QuranPartsGrid(parts: state.parts),
                          SizedBox(height: 20),
                        ],
                      ),
                    );
                  } else if (state is QuranPartsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.red),
                          SizedBox(height: 16),
                          Text(
                            'حدث خطأ: ${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuranPartsBloc>().add(
                                LoadQuranParts(studentId: studentId),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF48BB78),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF4A5568),
              size: 20,
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF48BB78),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book, color: Colors.white, size: 20),
              ),
            ],
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
