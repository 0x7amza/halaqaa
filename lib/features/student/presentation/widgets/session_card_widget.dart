import 'package:flutter/material.dart';
import 'package:halaqaa/core/utils/string.utils.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:intl/intl.dart';

class SessionCardWidget extends StatelessWidget {
  final Session session;

  const SessionCardWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final statusIcon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 15, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('yyyy/MM/dd').format(session.date)} م',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
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
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: Colors.orangeAccent[100],
              ),
              const SizedBox(width: 8),
              Text(
                '${surasInfo[int.parse(session.surahNumber) - 1]['name']} - آية ${session.fromAyah} إلى ${session.toAyah}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (session.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                session.notes,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (session.status) {
      case 'ممتاز':
        return const Color(0xFFFFA726);
      case 'جيد':
        return const Color(0xFF4ECDC4);
      case 'يحتاج تحسين':
        return Colors.orange;
      case 'غائب':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (session.status) {
      case 'ممتاز':
        return 'ممتاز';
      case 'جيد':
        return 'جيد';
      case 'غائب':
        return 'غائب';
      case 'يحتاج تحسين':
        return 'يحتاج تحسين';
      default:
        return 'غير محدد';
    }
  }

  IconData _getStatusIcon() {
    switch (session.status) {
      case 'ممتاز':
        return Icons.star;
      case 'جيد':
        return Icons.star_half;
      case 'غائب':
        return Icons.close;
      case 'يحتاج تحسين':
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }
}
