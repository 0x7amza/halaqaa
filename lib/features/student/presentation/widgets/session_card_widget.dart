import 'package:flutter/material.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:intl/intl.dart';

class SessionCardWidget extends StatelessWidget {
  final Session session;

  const SessionCardWidget({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = session.status != 'absent';
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final statusIcon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: const Color(0xFF4ECDC4), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Date and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Date
              Text(
                DateFormat('yyyy/MM/dd').format(session.date) + ' هـ',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Surah Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                session.notes.isNotEmpty ? session.notes : 'لا توجد ملاحظات',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '${session.surahName} - آية ${session.fromAyah} إلى ${session.toAyah}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (session.status) {
      case 'excellent':
        return const Color(0xFFFFA726);
      case 'good':
        return const Color(0xFF4ECDC4);
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (session.status) {
      case 'excellent':
        return 'ممتاز';
      case 'good':
        return 'جيد';
      case 'absent':
        return 'غائب';
      default:
        return 'غير محدد';
    }
  }

  IconData _getStatusIcon() {
    switch (session.status) {
      case 'excellent':
        return Icons.star;
      case 'good':
        return Icons.star_half;
      case 'absent':
        return Icons.close;
      default:
        return Icons.help_outline;
    }
  }
}
