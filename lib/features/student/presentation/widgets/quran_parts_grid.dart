import 'package:flutter/material.dart';
import 'package:halaqaa/core/model/quran_part_model.dart';

class QuranPartsGrid extends StatelessWidget {
  final List<QuranPartModel> parts;

  const QuranPartsGrid({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(8),
        border: (part.isLocked)
            ? Border.all(color: Colors.black.withOpacity(0.1))
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              part.id.toString(),
              style: TextStyle(
                color: part.isLocked ? Color(0xFF718096) : Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              part.arabicName,
              style: TextStyle(
                color: part.isLocked ? Color(0xFF718096) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 6),

            if (!part.isLocked && part.progress > 0) ...[
              SizedBox(
                height: 6,
                child: LinearProgressIndicator(
                  value: part.progress / 100,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),

              SizedBox(height: 8),

              Text(
                '${part.progress}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'آخر مراجعة: ${part.lastReviewDate}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ),
            ],

            if (part.isLocked) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'لم يبدأ',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 14),
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
