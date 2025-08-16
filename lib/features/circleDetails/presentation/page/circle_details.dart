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
import 'package:halaqaa/core/size.dart';

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
    SizeConfig().init(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text(
            'تفاصيل الحلقة',
            style: TextStyle(
              fontSize: SizeConfig().sp(18),
              fontWeight: FontWeight.w100,
              color: const Color(0xFF48BB78),
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
              final studentData = state.data;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('إنشاء ملف QR'),
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
            return const Center(child: Text('لا توجد بيانات'));
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig().wp(5)), // 16px
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCircleInfoCard(state.circle),
          SizedBox(height: SizeConfig().hp(2)), // 16px
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // يخلي الارتفاع كامل
              children: [
                Expanded(
                  flex: 4, // نسبة عرض الزر الأول
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
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig().hp(2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SizeConfig().wp(3.2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig().wp(2)),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF48BB78)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1, // مربع
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
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig().hp(1)), // 24px
          Text(
            'طلاب الحلقة',
            style: TextStyle(
              fontSize: SizeConfig().sp(18),
              fontWeight: FontWeight.w300,
              color: const Color(0xFF48BB78),
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.6)), // 12px
          if (state.students.isEmpty)
            _buildEmptyState(context, state)
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
      padding: EdgeInsets.all(SizeConfig().wp(5.3)), // 20px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig().wp(4.3)), // 16px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig().wp(2.7), // 10px
            offset: Offset(0, SizeConfig().hp(0.06)), // 2px
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            circle.name,
            style: TextStyle(
              fontSize: SizeConfig().sp(20),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF48BB78),
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.25)), // 8px
          Text(
            circle.description,
            style: TextStyle(
              fontSize: SizeConfig().sp(14),
              color: const Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig().hp(0.83)), // 20px
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.people,
                  title: 'عدد الطلاب',
                  count: circle.studentsCount.toString(),
                  color: const Color(0xFF48BB78),
                ),
              ),
              SizedBox(width: SizeConfig().wp(4.3)), // 16px
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  title: 'الطلاب النشطين',
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
      padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)), // 12px
      ),
      child: Column(
        children: [
          Icon(icon, size: SizeConfig().wp(6.4), color: color), // 24px
          SizedBox(height: SizeConfig().hp(0.25)), // 8px
          Text(
            count,
            style: TextStyle(
              fontSize: SizeConfig().sp(20),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.12)), // 4px
          Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig().sp(12),
              color: const Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Student student, context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig().hp(0.5)), // 12px
      padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)), // 12px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig().wp(2.7), // 10px
            offset: Offset(0, SizeConfig().hp(0.06)), // 2px
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: SizeConfig().wp(6.4), // 24px
                backgroundColor: const Color(0xFF48BB78).withOpacity(0.1),
                child: Text(
                  student.name.isNotEmpty ? student.name[0] : 'ط',
                  style: TextStyle(
                    fontSize: SizeConfig().sp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF48BB78),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig().wp(3.2)), // 12px
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: SizeConfig().sp(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: SizeConfig().hp(0.12)), // 4px
                    Text(
                      'انضم: ${_formatDate(student.joinDate)}',
                      style: TextStyle(
                        fontSize: SizeConfig().sp(12),
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().wp(2.1),
                  vertical: SizeConfig().hp(0.13),
                ), // 8,4px
                decoration: BoxDecoration(
                  color: student.status == 'active'
                      ? const Color(0xFF48BB78).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px
                ),
                child: Text(
                  student.status == 'active' ? 'نشط' : 'غير نشط',
                  style: TextStyle(
                    fontSize: SizeConfig().sp(12),
                    fontWeight: FontWeight.w500,
                    color: student.status == 'active'
                        ? const Color(0xFF48BB78)
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig().hp(0.67)), // 16px
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
                  label: 'إكمال',
                  value: student.completedParts.toString(),
                  color: const Color(0xFF48BB78),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig().hp(0.67)), // 16px
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
                  icon: const Icon(Icons.info_outline, size: 14),
                  label: const Text('تفاصيل'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF48BB78),
                    side: const BorderSide(color: Color(0xFF48BB78)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(
                      double.infinity,
                      SizeConfig().hp(5),
                    ), // الارتفاع الثابت
                  ),
                ),
              ),
              SizedBox(width: SizeConfig().wp(1.8)),
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
                  icon: const Icon(Icons.blur_circular_rounded, size: 14),
                  label: const Text('الأجزاء'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4299E1),
                    side: const BorderSide(color: Color(0xFF4299E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: Size(double.infinity, SizeConfig().hp(5)),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig().wp(1.8)),
              SizedBox(
                height: SizeConfig().hp(5),
                width: SizeConfig().hp(5), // مربع
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFED8936),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero, // إزالة الحشو الافتراضي
                    constraints:
                        const BoxConstraints(), // منع القيود الافتراضية
                    tooltip: 'QR',
                    icon: const Icon(Icons.qr_code, color: Color(0xFFED8936)),
                    onPressed: () {
                      BlocProvider.of<CircleDetailsBloc>(
                        context,
                      ).add(ExportStudentDataEvent(studentId: student.id));
                    },
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
            Icon(icon, size: SizeConfig().wp(3.2), color: color), // 12px
            SizedBox(width: SizeConfig().wp(1.1)), // 4px
            Text(
              value,
              style: TextStyle(
                fontSize: SizeConfig().sp(14),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig().hp(0.12)), // 4px
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig().sp(11),
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig().wp(12.8)), // 48px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)), // 12px
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: SizeConfig().wp(17.1),
            color: Colors.grey[400],
          ), // 64px
          SizedBox(height: SizeConfig().hp(0.67)), // 16px
          Text(
            'لا يوجد طلاب في هذه الحلقة',
            style: TextStyle(
              fontSize: SizeConfig().sp(16),
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.33)), // 8px
          InkWell(
            onTap: () => _showAddStudentDialog(
              context,
              state.circle.id,
              BlocProvider.of<CircleDetailsBloc>(context),
            ),
            child: Text(
              'اضغط لإضافة طلاب للحلقة',
              style: TextStyle(
                fontSize: SizeConfig().sp(14),
                color: Colors.grey[500],
              ),
            ),
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
            borderRadius: BorderRadius.circular(SizeConfig().wp(2.7)), // 10px
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
              SizedBox(height: SizeConfig().hp(0.67), width: 500), // 16px
              textField(
                hintText: 'اكتب اسم الطالب',
                title: 'اسم الطالب',
                controller: nameController,
              ),
              SizedBox(height: SizeConfig().hp(0.67)), // 16px
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().wp(3.2),
                ), // 12px
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig().wp(3.2),
                      vertical: SizeConfig().hp(2), // 16px
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)),
                  elevation: 4,
                  menuMaxHeight: 200,
                  alignment: AlignmentDirectional.bottomStart,
                  items: ['حفظ', 'قراءة', 'حفظ وقراءة']
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
              SizedBox(height: SizeConfig().hp(1)), // 24px
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            selectedValue == null) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text('اكتب الاسم واختر النوع'),
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
                          borderRadius: BorderRadius.circular(
                            SizeConfig().wp(2.1),
                          ), // 8px
                        ),
                      ),
                      child: const Text('إضافة'),
                    ),
                  ),
                  SizedBox(width: SizeConfig().wp(4.3)), // 16px
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            SizeConfig().wp(2.1),
                          ), // 8px
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
