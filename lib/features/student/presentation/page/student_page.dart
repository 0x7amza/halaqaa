// File: lib\features\student\presentation\page\student_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/size.dart'; // 确保导入 SizeConfig
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/event.dart';
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/state.dart';
import 'package:halaqaa/injection_container.dart';
import '../widgets/student_detail_loaded_widget.dart';

class StudentDetailPage extends StatelessWidget {
  final String studentId;
  const StudentDetailPage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // 初始化 SizeConfig

    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            getIt<StudentDetailBloc>()
              ..add(GetStudentDetailEvent(studentId: studentId)),
        child: BlocBuilder<StudentDetailBloc, StudentDetailState>(
          builder: (context, state) {
            if (state is StudentDetailLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFF4ECDC4)),
              );
            } else if (state is StudentDetailLoaded || state is SessionAdded) {
              final student = state is StudentDetailLoaded
                  ? (state).student
                  : (state as SessionAdded).student;
              final sessions = state is StudentDetailLoaded
                  ? (state).sessions
                  : (state as SessionAdded).sessions;
              return StudentDetailLoadedWidget(
                student: student,
                sessions: sessions,
              );
            } else if (state is StudentDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: SizeConfig().wp(17.1),
                      color: Colors.red[300],
                    ), // 64px
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: SizeConfig().sp(16),
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    ElevatedButton(
                      onPressed: () {
                        context.read<StudentDetailBloc>().add(
                          GetStudentDetailEvent(studentId: studentId),
                        );
                      },
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('حدث خطأ غير متوقع'));
          },
        ),
      ),
    );
  }
}
