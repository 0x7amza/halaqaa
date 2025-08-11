import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/utils/QRScanner.utils.dart';
import 'package:halaqaa/core/utils/widgets.utils.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/bloc.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/event.dart';
import 'package:halaqaa/features/circleDetails/presentation/BLoC/state.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/student/presentation/page/quran_parts_page.dart';
import 'package:halaqaa/features/student/presentation/page/student_page.dart';
import 'package:halaqaa/injection_container.dart';

class CircleDetailsScreen extends StatelessWidget {
  final String circleId;
  final String circleName;

  const CircleDetailsScreen({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CircleDetailsBloc>()
            ..add(LoadCircleDetailsEvent(circleId: circleId)),
      child: CircleDetailsView(circleName: circleName),
    );
  }
}

class CircleDetailsView extends StatelessWidget {
  final String circleName;

  const CircleDetailsView({super.key, required this.circleName});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: const Text(
            'تفاصيل الحلقة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w100,
              color: Color(0xFF48BB78),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF48BB78)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocConsumer<CircleDetailsBloc, CircleDetailsState>(
          listener: (context, state) {
            print('Current state: $state');
            if (state is CircleDetailsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is StudentDetailsExportedState) {
              // generate file with student data
              final studentData = state.data;

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('تصدير بيانات الطلاب'),
                  content: SingleChildScrollView(
                    child: CompressedQRView(studentData: studentData),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CircleDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CircleDetailsLoaded ||
                state is StudentDetailsExportedState) {
              return _buildContent(context, state);
            }

            return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCircleInfoCard(state.circle),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 320,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddStudentDialog(
                    context,
                    state.circle.id,
                    BlocProvider.of<CircleDetailsBloc>(context),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة طالب جديد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // scan qr icon button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF48BB78)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    print('Scan QR button pressed');
                    showDialog(
                      context: context,
                      builder: (_) => const QRScannerDialog(),
                    );
                  },
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: Color(0xFF48BB78),
                  ),
                  tooltip: 'مسح رمز الاستجابة السريعة',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Students Section
          const Text(
            'قائمة الطلاب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Color(0xFF48BB78),
            ),
          ),

          const SizedBox(height: 12),

          if (state.students.isEmpty)
            _buildEmptyState()
          else
            ...state.students
                .map((student) => _buildStudentCard(student, context))
                .toList(),
        ],
      ),
    );
  }

  Widget _buildCircleInfoCard(MemorizationCircle circle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            circle.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF48BB78),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            circle.description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people,
                  title: 'إجمالي الطلاب',
                  count: circle.studentsCount.toString(),
                  color: const Color(0xFF48BB78),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  title: 'الطلاب النشطون',
                  count: circle.activeStudentsCount.toString(),
                  color: const Color(0xFFED8936),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Student student, context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Student Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF48BB78).withOpacity(0.1),
                child: Text(
                  student.name.isNotEmpty ? student.name[0] : 'ط',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF48BB78),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'انضم: ${_formatDate(student.joinDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: student.status == 'active'
                      ? const Color(0xFF48BB78).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  student.status == 'active' ? 'نشط' : 'خمول',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: student.status == 'active'
                        ? const Color(0xFF48BB78)
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStudentStat(
                  icon: Icons.star,
                  label: 'نجوم',
                  value: student.stars.toString(),
                  color: const Color(0xFFFFD700),
                ),
              ),
              Expanded(
                child: _buildStudentStat(
                  icon: Icons.book,
                  label: 'الجزء الحالي',
                  value: student.currentPart.toString(),
                  color: const Color(0xFF4299E1),
                ),
              ),
              Expanded(
                child: _buildStudentStat(
                  icon: Icons.check_circle,
                  label: 'مكتملة',
                  value: student.completedParts.toString(),
                  color: const Color(0xFF48BB78),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentDetailPage(studentId: student.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('تفاصيل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF48BB78),
                    side: const BorderSide(color: Color(0xFF48BB78)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuranPartsPage(studentId: student.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.blur_circular_rounded, size: 16),
                  label: const Text('الأجزاء'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4299E1),
                    side: const BorderSide(color: Color(0xFF4299E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    BlocProvider.of<CircleDetailsBloc>(
                      context,
                    ).add(ExportStudentDataEvent(studentId: student.id));
                  },
                  icon: const Icon(Icons.qr_code, size: 16),
                  label: const Text('QR'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFED8936),
                    side: const BorderSide(color: Color(0xFFED8936)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF718096)),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'لا يوجد طلاب في هذه الحلقة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة الطلاب للحلقة',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void _showAddStudentDialog(
    BuildContext context,
    String circleId,
    CircleDetailsBloc bloc,
  ) {
    final nameController = TextEditingController();
    String? selectedValue;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: AlertDialog(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: const Text(
                  'إضافة طالب جديد',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16, width: 500),

              textField(
                hintText: 'أدخل اسم الطالب',
                title: 'اسم الطالب',
                controller: nameController,
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // زاوية مستديرة
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none, // بدون حواف
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down), // أيقونة مخصصة
                  dropdownColor: Colors.white, // لون خلفية القائمة
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // زوايا مستديرة للقائمة
                  elevation: 4, // ظل خفيف للقائمة
                  menuMaxHeight: 200, // أقصى ارتفاع للقائمة
                  alignment:
                      AlignmentDirectional.bottomStart, // توضعها أسفل الزر

                  items: ['حفظ', 'قراءة', 'قراءة وحفظ']
                      .map(
                        (value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),

                  onChanged: (value) {
                    selectedValue = value;
                  },

                  hint: const Text(
                    'اختر نوع الطالب',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            selectedValue == null) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text('يرجى ملء جميع الحقول'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        bloc.add(
                          AddStudentEvent(
                            circleId: circleId,
                            type: selectedValue!,
                            name: nameController.text,
                          ),
                        );

                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48BB78),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('إضافة'),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
