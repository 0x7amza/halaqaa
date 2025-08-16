import 'package:flutter/material.dart';
import 'package:halaqaa/core/size.dart'; // 确保导入 SizeConfig
import '../../../circleDetails/domain/entities/student.dart';

class UserStatsCard extends StatelessWidget {
  final Student student;
  final int totalDays;
  final int overallProgress;
  final int completedJuz;
  const UserStatsCard({
    super.key,
    required this.student,
    required this.totalDays,
    required this.overallProgress,
    required this.completedJuz,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); // 初始化 SizeConfig

    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig().wp(1.1)), // 4px
      padding: EdgeInsets.all(SizeConfig().wp(5.3)), // 20px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig().wp(4.3)), // 16px
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig().wp(2.7), // 10px
            offset: Offset(0, SizeConfig().hp(0.12)), // 2px
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().wp(3.2), // 12px
                  vertical: SizeConfig().hp(0.37), // 6px
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(5.3),
                  ), // 20px
                ),
                child: Text(
                  student.type,
                  style: TextStyle(
                    fontSize: SizeConfig().sp(12), // 12px
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                student.name,
                style: TextStyle(
                  fontSize: SizeConfig().sp(18), // 18px
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig().hp(1.25)), // 20px
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.library_books,
                value: completedJuz.toString(),
                label: 'عدد الأجزاء المكتملة',
                color: const Color(0xFF48BB78),
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: totalDays.toString(),
                label: 'عدد الأيام',
                color: const Color(0xFFF56565),
              ),
              _buildStatItem(
                icon: Icons.timeline,
                value: student.currentPart.toString(),
                label: 'الجزء الحالي',
                color: const Color(0xFF9F7AEA),
              ),
            ],
          ),
          SizedBox(height: SizeConfig().hp(1.25)), // 20px
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'معدل التقدم العام',
                style: TextStyle(
                  fontSize: SizeConfig().sp(14), // 14px
                  color: const Color(0xFF4A5568),
                ),
              ),
              Text(
                '$overallProgress%',
                style: TextStyle(
                  fontSize: SizeConfig().sp(14), // 14px
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig().hp(0.5)), // 8px
          LinearProgressIndicator(
            value: overallProgress / 100,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF48BB78)),
            minHeight: SizeConfig().hp(0.37), // 6px
          ),
          SizedBox(height: SizeConfig().hp(0.75)), // 12px
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ الانضمام: ${student.joinDate.toString().substring(0, 10)}',
                style: TextStyle(
                  fontSize: SizeConfig().sp(11), // 11px
                  color: const Color(0xFF718096),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().wp(2.1), // 8px
                  vertical: SizeConfig().hp(0.25), // 4px
                ),
                decoration: BoxDecoration(
                  color: student.status == 'active'
                      ? const Color(0xFF48BB78).withOpacity(0.1)
                      : const Color(0xFF718096).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: SizeConfig().wp(1.6), // 6px
                      height: SizeConfig().wp(1.6), // 6px
                      decoration: BoxDecoration(
                        color: student.status == 'active'
                            ? const Color(0xFF48BB78)
                            : const Color(0xFF718096),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: SizeConfig().wp(1.1)), // 4px
                    Text(
                      student.status == 'active' ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        fontSize: SizeConfig().sp(10), // 10px
                        color: student.status == 'active'
                            ? const Color(0xFF48BB78)
                            : const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (student.type.toLowerCase()) {
      case 'حفظ':
        return Color(0xFF48BB78);
      case 'مراجعة':
        return Color(0xFF4299E1);
      case 'تلاوة':
        return Color(0xFFECC94B);
      default:
        return Color(0xFF9F7AEA);
    }
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
