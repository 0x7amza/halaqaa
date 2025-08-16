// File: lib\features\student\presentation\widgets\session_card_widget.dart
import 'package:flutter/material.dart';
import 'package:halaqaa/core/size.dart';
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
      padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          SizeConfig().wp(3.2),
        ), // 12px radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig().wp(2.1), // 8px blur
            offset: Offset(0, SizeConfig().hp(0.12)), // 2px offset
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
                  Icon(
                    Icons.calendar_today,
                    size: SizeConfig().wp(4.0),
                    color: Colors.green,
                  ), // 15px icon
                  SizedBox(width: SizeConfig().wp(2.1)), // 8px width
                  Text(
                    '${DateFormat('yyyy/MM/dd').format(session.date)} م',
                    style: TextStyle(
                      fontSize: SizeConfig().sp(14), // Scaled font size
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig().wp(3.2), // 12px horizontal
                  vertical: SizeConfig().hp(0.37), // 6px vertical
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px radius
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: SizeConfig().wp(4.3),
                      color: statusColor,
                    ), // 16px icon
                    SizedBox(width: SizeConfig().wp(1.1)), // 4px width
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: SizeConfig().sp(12), // Scaled font size
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
          SizedBox(height: SizeConfig().hp(0.5)), // 8px height
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: SizeConfig().wp(5.3), // 20px icon
                color: Colors.orangeAccent[100],
              ),
              SizedBox(width: SizeConfig().wp(2.1)), // 8px width
              Text(
                '${surasInfo[int.parse(session.surahNumber) - 1]['name']} - من الآية ${session.fromAyah} إلى الآية ${session.toAyah}',
                style: TextStyle(
                  fontSize: SizeConfig().sp(14), // Scaled font size
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (session.notes.isNotEmpty) ...[
            SizedBox(height: SizeConfig().hp(0.5)), // 8px height
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig().wp(3.2),
                vertical: SizeConfig().hp(0.5),
              ), // 12,8px padding
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  SizeConfig().wp(2.1),
                ), // 8px radius
              ),
              child: Text(
                session.notes,
                style: TextStyle(
                  fontSize: SizeConfig().sp(14), // Scaled font size
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
