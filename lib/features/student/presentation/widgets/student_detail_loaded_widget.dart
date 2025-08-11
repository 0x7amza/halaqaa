import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:halaqaa/core/size.dart';
import 'package:halaqaa/core/utils/string.utils.dart';
import 'package:halaqaa/core/utils/widgets.utils.dart';
import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/bloc.dart';
import 'package:halaqaa/features/student/presentation/BLoC/StudentDetails/event.dart';
import 'package:intl/intl.dart';
import 'session_card_widget.dart';

class StudentDetailLoadedWidget extends StatelessWidget {
  final Student student;
  final List<Session> sessions;

  const StudentDetailLoadedWidget({
    super.key,
    required this.student,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تقدم الطالب',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Student Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Student Name
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF48BB78),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Student Details Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'نوع التحفيظ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF48BB78).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                student.type,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF48BB78),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),

                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'تاريخ الانضمام',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('yyyy/MM/dd').format(student.joinDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15.2),
                  Container(height: 0.6, color: Colors.grey),
                  const SizedBox(height: 15.2),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${student.currentPart}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF48BB78),
                              ),
                            ),
                            const Text(
                              'الجزء الحالي',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Completed Parts
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              sessions.length.toString(),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA726),
                              ),
                            ),
                            const Text(
                              'عدد الجلسات',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Current Part
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Add New Session Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _showAddSessionDialog(
                    context,
                    BlocProvider.of<StudentDetailBloc>(context),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF48BB78),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'تسجيل جلسة جديدة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Progress Record Title
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'سجل التقدم',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF48BB78),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Progress Records List
            if (sessions.isNotEmpty)
              ...sessions.map(
                (session) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SessionCardWidget(session: session),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد جلسات مسجلة',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context, StudentDetailBloc bloc) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        var statusText = 'جيد';
        TextEditingController fromAyahController = TextEditingController(
          text: '1',
        );
        TextEditingController toAyahController = TextEditingController(
          text: '1',
        );
        TextEditingController noteController = TextEditingController();
        var value = 'الفاتحة - 1';
        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: SizedBox(
              width: SizeConfig().wp(75),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: const Text(
                      'تسجيل التقدم اليومي',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: dropDwon(
                      items: surasInfo.map((e) {
                        return '${e['name']} - ${e['number']}';
                      }).toList(),
                      value: value,
                      title: 'اختر السورة',
                      onTap: (val) {
                        value = val;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: SizeConfig().wp(33),
                        child: textField(
                          hintText: 'من أية',
                          title: 'من أية',
                          controller: fromAyahController,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig().wp(33),
                        child: textField(
                          hintText: 'إلى أية',
                          title: 'إلى أية',
                          controller: toAyahController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مستوى الاداء',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // زاوية مستديرة
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none, // بدون حواف
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                          ), // أيقونة مخصصة
                          dropdownColor: Colors.white, // لون خلفية القائمة
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // زوايا مستديرة للقائمة
                          elevation: 4, // ظل خفيف للقائمة
                          menuMaxHeight: 200, // أقصى ارتفاع للقائمة
                          alignment: AlignmentDirectional
                              .bottomStart, // توضعها أسفل الزر

                          items: ['غائب', 'يحتاج تحسين', 'جيد', 'ممتاز']
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
                            if (value != null) {
                              statusText = value;
                            }
                          },
                          value: 'جيد',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  textField(
                    hintText: 'ملاحظات اضافية (اختياري)',
                    height: 150,
                    isHintCentered: false,
                    title: 'ملاحظات',
                    controller: noteController,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final sorahNumber =
                                int.parse(value.split('-')[1]) - 1;
                            print('Adding session for Surah: $sorahNumber');
                            print('shorahName: $value');
                            print('Status: $statusText');
                            print(noteController.text);
                            print(surasInfo[sorahNumber]['count']);
                            print(
                              'from: ${int.parse(fromAyahController.text)} to: ${int.parse(toAyahController.text)}',
                            );

                            if (value.isEmpty ||
                                fromAyahController.text.isEmpty ||
                                toAyahController.text.isEmpty ||
                                int.parse(fromAyahController.text) < 1 ||
                                int.parse(toAyahController.text) <
                                    int.parse(fromAyahController.text) ||
                                int.parse(toAyahController.text) >
                                    surasInfo[sorahNumber]['count'] ||
                                int.parse(fromAyahController.text) >
                                    surasInfo[sorahNumber]['count']) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'الرجاء ملء جميع الحقول بشكل صحيح',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            bloc.add(
                              AddSessionEvent(
                                session: Session(
                                  date: DateTime.now(),
                                  surahNumber: (sorahNumber + 1).toString(),
                                  fromAyah: int.parse(fromAyahController.text),
                                  toAyah: int.parse(toAyahController.text),
                                  status: statusText,
                                  notes: noteController.text,
                                  stars: 0,
                                  studentId: student.id,
                                  id: DateTime.now().toIso8601String(),
                                ),
                              ),
                            );

                            Navigator.of(dialogContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF48BB78),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('إضافة'),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
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
      },
    );
  }
}
