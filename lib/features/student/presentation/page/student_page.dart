import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/size.dart';
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
    SizeConfig().init(context);
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            getIt<StudentDetailBloc>()
              ..add(GetStudentDetailEvent(studentId: studentId)),
        child: BlocBuilder<StudentDetailBloc, StudentDetailState>(
          builder: (context, state) {
            if (state is StudentDetailLoading) {
              return const Center(
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
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StudentDetailBloc>().add(
                          GetStudentDetailEvent(studentId: studentId),
                        );
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('مرحباً بك'));
          },
        ),
      ),
    );
  }
}
