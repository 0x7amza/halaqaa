// File: lib\features\student\presentation\widgets\quran_parts_grid.dart
import 'package:flutter/material.dart';
import 'package:halaqaa/core/model/quran_part_model.dart';
import 'package:halaqaa/core/size.dart'; // Import SizeConfig

class QuranPartsGrid extends StatelessWidget {
  final List<QuranPartModel> parts;
  const QuranPartsGrid({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context); // Usually initialized in the page, not widget

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: SizeConfig().wp(3.2), // 12px
        mainAxisSpacing: SizeConfig().wp(3.2), // 12px
      ),
      itemCount: parts.length,
      itemBuilder: (context, index) {
        return QuranPartCard(part: parts[index]);
      },
    );
  }
}

class QuranPartCard extends StatelessWidget {
  final QuranPartModel part;
  const QuranPartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context); // Usually initialized in the page, not widget

    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(SizeConfig().wp(2.1)), // 8px
        border: (part.isLocked)
            ? Border.all(color: Colors.black.withOpacity(0.1))
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig().wp(2.1)), // 8px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              part.id.toString(),
              style: TextStyle(
                color: part.isLocked ? const Color(0xFF718096) : Colors.white,
                fontSize: SizeConfig().sp(30), // Scaled font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig().hp(0.25)), // 4px
            Text(
              part.arabicName,
              style: TextStyle(
                color: part.isLocked ? const Color(0xFF718096) : Colors.white,
                fontSize: SizeConfig().sp(16), // Scaled font size
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: SizeConfig().hp(0.375)), // 6px
            if (!part.isLocked && part.progress > 0) ...[
              SizedBox(
                height: SizeConfig().hp(0.375), // 6px
                child: LinearProgressIndicator(
                  value: part.progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig().wp(1.07)),
                  ), // 4px
                ),
              ),
              SizedBox(height: SizeConfig().hp(0.5)), // 8px
              Text(
                '${part.progress}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig().sp(18), // Scaled font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig().hp(0.25)), // 4px
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'آخر مراجعة: ${part.lastReviewDate}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: SizeConfig().sp(10), // Scaled font size
                  ),
                ),
              ),
            ],
            if (part.isLocked) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'غير مفتوح',
                  style: TextStyle(
                    color: const Color(0xFF718096),
                    fontSize: SizeConfig().sp(14), // Scaled font size
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCardColor() {
    if (part.isLocked) {
      return const Color(0xFFF1F5F9); // Gray for locked parts
    }
    switch (part.status) {
      case 'مكتمل':
        return const Color(0xFF34D399);
      default:
        return Colors.amber;
    }
  }
}
