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
    final isAbsent = session.status == 'غائب';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig().wp(2.1),
        vertical: SizeConfig().hp(0.6),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig().wp(3.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: SizeConfig().wp(2.1),
            offset: Offset(0, SizeConfig().hp(0.25)),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(SizeConfig().wp(4.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date section
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: SizeConfig().wp(4.0),
                            color: Colors.green.shade600,
                          ),
                          SizedBox(width: SizeConfig().wp(2.7)),
                          Expanded(
                            child: Text(
                              '${DateFormat('yyyy/MM/dd').format(session.date)} م',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(13),
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig().wp(3.2),
                        vertical: SizeConfig().hp(0.37),
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(
                          SizeConfig().wp(3.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusIcon,
                            size: SizeConfig().wp(4.0),
                            color: statusColor,
                          ),
                          SizedBox(width: SizeConfig().wp(1.6)),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: SizeConfig().sp(12),
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Conditional content based on attendance
                if (isAbsent) ...[
                  SizedBox(height: SizeConfig().hp(1.5)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(SizeConfig().wp(4.0)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(SizeConfig().wp(2.1)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_off_rounded,
                          size: SizeConfig().wp(8.0),
                          color: Colors.grey.shade500,
                        ),
                        SizedBox(height: SizeConfig().hp(0.8)),
                        Text(
                          'لم يحضر الطالب هذه الجلسة',
                          style: TextStyle(
                            fontSize: SizeConfig().sp(14),
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  SizedBox(height: SizeConfig().hp(1.2)),

                  // Surah and Ayah information
                  Container(
                    padding: EdgeInsets.all(SizeConfig().wp(3.5)),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(SizeConfig().wp(2.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: SizeConfig().wp(5.0),
                          color: Colors.orange.shade600,
                        ),
                        SizedBox(width: SizeConfig().wp(3.2)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${surasInfo[int.parse(session.surahNumber) - 1]['name']}',
                                style: TextStyle(
                                  fontSize: SizeConfig().sp(15),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                              SizedBox(height: SizeConfig().hp(0.3)),
                              Text(
                                'من الآية ${session.fromAyah} إلى الآية ${session.toAyah}',
                                style: TextStyle(
                                  fontSize: SizeConfig().sp(13),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orange.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Notes section (show for all statuses if notes exist)
                if (session.notes.isNotEmpty) ...[
                  SizedBox(height: SizeConfig().hp(1.2)),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(SizeConfig().wp(3.5)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(SizeConfig().wp(2.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.note_alt_rounded,
                              size: SizeConfig().wp(4.5),
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: SizeConfig().wp(2.1)),
                            Text(
                              'ملاحظات',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(13),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig().hp(0.6)),
                        Text(
                          session.notes,
                          style: TextStyle(
                            fontSize: SizeConfig().sp(13),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (session.status) {
      case 'ممتاز':
        return const Color(0xFF4CAF50); // Green
      case 'جيد':
        return const Color(0xFF2196F3); // Blue
      case 'يحتاج تحسين':
        return const Color(0xFFFF9800); // Orange
      case 'غائب':
        return const Color(0xFFF44336); // Red
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
        return Icons.star_rounded;
      case 'جيد':
        return Icons.thumb_up_rounded;
      case 'غائب':
        return Icons.person_off_rounded;
      case 'يحتاج تحسين':
        return Icons.trending_up_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
