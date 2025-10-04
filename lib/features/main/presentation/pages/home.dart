import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/size.dart';
import 'package:halaqaa/core/utils/widgets.utils.dart';
import 'package:halaqaa/features/circleDetails/presentation/page/circle_details.dart';
import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:halaqaa/features/main/presentation/BLoC/bloc.dart';
import 'package:halaqaa/features/main/presentation/BLoC/events.dart';
import 'package:halaqaa/features/main/presentation/BLoC/states.dart';
import 'package:halaqaa/injection_container.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(LoadCirclesEvent()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // Initialize SizeConfig

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'الرئيسية',
          style: TextStyle(
            fontSize: SizeConfig().sp(20), // Scaled font size
            fontWeight: FontWeight.w400,
            color: const Color(0xFF48BB78),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is DashboardSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardLoaded) {
            return _buildDashboardContent(context, state);
          }
          return const Center(child: Text('حدث خطأ أثناء تحميل البيانات'));
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(SizeConfig().wp(6.4)), // 24px padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                SizeConfig().wp(4.3),
              ), // 16px radius
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF48BB78).withOpacity(0.1),
                  blurRadius: SizeConfig().wp(2.7), // 10px blur
                  offset: Offset(0, SizeConfig().hp(0.12)), // 2px offset
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'مرحبا بك',
                  style: TextStyle(
                    fontSize: SizeConfig().sp(24), // Scaled font size
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF48BB78),
                  ),
                ),
                SizedBox(height: SizeConfig().hp(0.5)), // 8px height
                Text(
                  'يمكنك إدارة الحلقات والمتابعة مع الطلاب',
                  style: TextStyle(
                    fontSize: SizeConfig().sp(16), // Scaled font size
                    color: const Color(0xFF718096),
                  ),
                ),
                SizedBox(height: SizeConfig().hp(1.5)), // 24px height
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.school,
                        title: 'عدد الحلقات',
                        count: state.circles.length.toString(),
                        color: const Color(0xFFED8936),
                      ),
                    ),
                    SizedBox(width: SizeConfig().wp(4.3)), // 16px width
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.groups,
                        title: 'عدد الطلاب',
                        count: state.totalStudents.toString(),
                        color: const Color(0xFF48BB78),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig().hp(1.5)), // 24px height

          // Action Buttons
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showCreateCircleDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('إنشاء حلقة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF48BB78),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig().hp(1),
                ), // 16px vertical padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px radius
                ),
              ),
            ),
          ),

          SizedBox(height: SizeConfig().hp(1.5)), // 24px height
          // Circles Section
          Text(
            'الحلقات',
            style: TextStyle(
              fontSize: SizeConfig().sp(18), // Scaled font size
              fontWeight: FontWeight.w600,
              color: const Color(0xFF48BB78),
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.75)), // 12px height
          if (state.circles.isEmpty)
            _buildEmptyState()
          else
            ...state.circles.map(
              (circle) => _buildCircleCard(circle, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CircleDetailsScreen(
                      circleId: circle.id,
                      circleName: circle.name,
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(SizeConfig().wp(5.3)), // 20px padding
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          SizeConfig().wp(3.2),
        ), // 12px radius
      ),
      child: Column(
        children: [
          Icon(icon, size: SizeConfig().wp(8.5), color: color), // 32px icon
          SizedBox(height: SizeConfig().hp(0.75)), // 12px height
          Text(
            count,
            style: TextStyle(
              fontSize: SizeConfig().sp(24), // Scaled font size
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.25)), // 4px height
          Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig().sp(14), // Scaled font size
              color: const Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleCard(MemorizationCircle circle, ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: SizeConfig().hp(0.75),
        ), // 12px bottom margin
        padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            SizeConfig().wp(3.2),
          ), // 12px radius
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF48BB78).withOpacity(0.1),
              blurRadius: SizeConfig().wp(2.7), // 10px blur
              offset: Offset(0, SizeConfig().hp(0.12)), // 2px offset
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circle.name,
                    style: TextStyle(
                      fontSize: SizeConfig().sp(16), // Scaled font size
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF48BB78),
                    ),
                  ),
                  SizedBox(height: SizeConfig().hp(0.25)), // 4px height
                  Text(
                    circle.description,
                    style: TextStyle(
                      fontSize: SizeConfig().sp(14), // Scaled font size
                      color: const Color(0xFF718096),
                    ),
                  ),
                  SizedBox(height: SizeConfig().hp(0.5)), // 8px height
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        size: 16,
                        color: Color(0xFF718096),
                      ),
                      SizedBox(width: SizeConfig().wp(1.1)), // 4px width
                      Text(
                        'تاريخ الإنشاء: ${_formatDate(circle.createdAt)}',
                        style: TextStyle(
                          fontSize: SizeConfig().sp(12), // Scaled font size
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig().wp(2.1), // 8px horizontal
                    vertical: SizeConfig().hp(0.25), // 4px vertical
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF48BB78).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      SizeConfig().wp(3.2),
                    ), // 12px radius
                  ),
                  child: Text(
                    '${circle.studentsCount} طلاب',
                    style: TextStyle(
                      fontSize: SizeConfig().sp(12), // Scaled font size
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF48BB78),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig().wp(12.8)), // 48px padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig().wp(3.2),
        ), // 12px radius
      ),
      child: Column(
        children: [
          Icon(
            Icons.book_outlined,
            size: SizeConfig().wp(17.1),
            color: Colors.grey[400],
          ), // 64px icon
          SizedBox(height: SizeConfig().hp(1)), // 16px height
          Text(
            'لا توجد حلقات مُنشأة',
            style: TextStyle(
              fontSize: SizeConfig().sp(16), // Scaled font size
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: SizeConfig().hp(0.5)), // 8px height
          Text(
            'اضغط على إنشاء حلقة لإضافة حلقات جديدة',
            style: TextStyle(
              fontSize: SizeConfig().sp(14), // Scaled font size
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  void _showCreateCircleDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: getIt<DashboardBloc>(),
        child: AlertDialog(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              SizeConfig().wp(2.7),
            ), // 10px radius
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'إنشاء حلقة جديدة',
                    style: TextStyle(
                      fontSize: SizeConfig().sp(20), // Scaled font size
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig().hp(1), width: 500), // 16px height
                textField(
                  hintText: 'مثال : حلقة القارئ',
                  title: 'اسم الحلقة',
                  controller: nameController,
                ),
                SizedBox(height: SizeConfig().hp(1)), // 16px height
                textField(
                  hintText: 'وصف مختصر للحلقة...',
                  height: 150, // This is a fixed height, might need adjustment
                  isHintCentered: false,
                  title: 'وصف الحلقة',
                  controller: descriptionController,
                ),
                SizedBox(height: SizeConfig().hp(1.5)), // 24px height
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();
                          if (name.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('يرجى ملء جميع الحقول'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          context.read<DashboardBloc>().add(
                            CreateCircleEvent(
                              name: name,
                              description: description,
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
                            ), // 8px radius
                          ),
                        ),
                        child: const Text('إنشاء حلقة'),
                      ),
                    ),
                    SizedBox(width: SizeConfig().wp(4.3)), // 16px width
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
                            ), // 8px radius
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
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تصدير البيانات'),
        content: const Text('هل تريد تصدير بيانات جميع الحلقات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DashboardBloc>().add(ExportDataEvent());
              Navigator.of(dialogContext).pop();
            },
            child: const Text('تصدير'),
          ),
        ],
      ),
    );
  }
}
