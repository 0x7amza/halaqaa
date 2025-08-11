import 'package:flutter/material.dart';
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  student.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                student.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.library_books,
                value: completedJuz.toString(),
                label: 'أجزاء مكتملة',
                color: Color(0xFF48BB78),
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                value: totalDays.toString(),
                label: 'أيام الدراسة',
                color: Color(0xFFF56565),
              ),
              _buildStatItem(
                icon: Icons.timeline,
                value: student.currentPart.toString(),
                label: 'الجزء الحالي',
                color: Color(0xFF9F7AEA),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم الإجمالي',
                style: TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
              ),
              Text(
                '$overallProgress%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: overallProgress / 100,
            backgroundColor: Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF48BB78)),
            minHeight: 6,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تاريخ الانضمام: ${student.joinDate.toString().substring(0, 10)}',
                style: TextStyle(fontSize: 11, color: Color(0xFF718096)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: student.status == 'active'
                      ? Color(0xFF48BB78).withOpacity(0.1)
                      : Color(0xFF718096).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: student.status == 'active'
                            ? Color(0xFF48BB78)
                            : Color(0xFF718096),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      student.status == 'active' ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        fontSize: 10,
                        color: student.status == 'active'
                            ? Color(0xFF48BB78)
                            : Color(0xFF718096),
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
