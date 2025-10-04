// File: lib\features\student\presentation\widgets\student_detail_loaded_widget.dart
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
    SizeConfig().init(context); // تهيئة SizeConfig

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
          'تفاصيل الطالب',
          style: TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig().wp(4.3)), // 16px
        child: Column(
          children: [
            // Student Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(SizeConfig().wp(6.4)), // 24px
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  SizeConfig().wp(4.3),
                ), // 16px
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
                  // Student Name
                  Text(
                    student.name,
                    style: TextStyle(
                      fontSize: SizeConfig().sp(24), // 24px
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF48BB78),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig().hp(1.5)), // 24px
                  // Student Details Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'نوع الطالب',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(14), // 14px
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: SizeConfig().hp(0.25)), // 4px
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig().wp(3.2), // 12px
                                vertical: SizeConfig().hp(0.37), // 6px
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF48BB78).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  SizeConfig().wp(2.1),
                                ), // 8px
                              ),
                              child: Text(
                                student.type,
                                style: TextStyle(
                                  fontSize: SizeConfig().sp(14), // 14px
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF48BB78),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig().wp(8.5)), // 32px
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'تاريخ الانضمام',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(14), // 14px
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: SizeConfig().hp(0.25)), // 4px
                            Text(
                              DateFormat('yyyy/MM/dd').format(student.joinDate),
                              style: TextStyle(
                                fontSize: SizeConfig().sp(16), // 16px
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig().hp(0.95)), // 15.2px
                  Container(height: 0.6, color: Colors.grey),
                  SizedBox(height: SizeConfig().hp(0.95)), // 15.2px
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${student.currentPart}',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(26), // 26px
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF48BB78),
                              ),
                            ),
                            Text(
                              'الجزء الحالي',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(14), // 14px
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
                              style: TextStyle(
                                fontSize: SizeConfig().sp(26), // 26px
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFFA726),
                              ),
                            ),
                            Text(
                              'عدد الجلسات',
                              style: TextStyle(
                                fontSize: SizeConfig().sp(14), // 14px
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
            SizedBox(height: SizeConfig().hp(1)), // 16px
            // Add New Session Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
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
                      borderRadius: BorderRadius.circular(8), // 16px
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: SizeConfig().wp(6.4)), // 24px
                      SizedBox(width: SizeConfig().wp(2.1)), // 8px
                      Text(
                        'تسجيل جلسه',
                        style: TextStyle(
                          fontSize: SizeConfig().sp(16), // 16px
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddSessionDialogSecend(
                      context,
                      BlocProvider.of<StudentDetailBloc>(context),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 16px
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        size: SizeConfig().wp(6.4),
                      ), // 24px
                      SizedBox(width: SizeConfig().wp(2.1)), // 8px
                      Text(
                        'تسجيل كغائب',
                        style: TextStyle(
                          fontSize: SizeConfig().sp(16), // 16px
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig().hp(1.5)), // 24px
            // Progress Record Title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'سجل التقدم',
                style: TextStyle(
                  fontSize: SizeConfig().sp(20), // 20px
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF48BB78),
                ),
              ),
            ),
            SizedBox(height: SizeConfig().hp(1)), // 16px
            // Progress Records List
            if (sessions.isNotEmpty)
              ...sessions.map(
                (session) => Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig().hp(0.75),
                  ), // 12px
                  child: SessionCardWidget(session: session),
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(SizeConfig().wp(8.5)), // 32px
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    SizeConfig().wp(3.2),
                  ), // 12px
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: SizeConfig().wp(12.8), // 48px
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    Text(
                      'لا يوجد جلسات بعد',
                      style: TextStyle(
                        fontSize: SizeConfig().sp(16),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddSessionDialogSecend(
    BuildContext context,
    StudentDetailBloc bloc,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig().wp(2.7)),
            ),
            content: SizedBox(
              width: SizeConfig().wp(75),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'هل انت متاكد من تسجيله كغائب؟',
                      style: TextStyle(
                        fontSize: SizeConfig().sp(20), // 20px
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig().hp(1.5)), // 24px
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            bloc.add(
                              AddSessionEvent(
                                session: Session(
                                  date: DateTime.now(),
                                  surahNumber: (-1).toString(),
                                  fromAyah: -1,
                                  toAyah: -1,
                                  status: 'غائب',
                                  notes: '',
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
                              borderRadius: BorderRadius.circular(
                                SizeConfig().wp(2.1),
                              ), // 8px
                            ),
                          ),
                          child: const Text('نعم'),
                        ),
                      ),
                      SizedBox(width: SizeConfig().wp(4.3)), // 16px
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
                              ), // 8px
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
        var value = 'سورة الفاتحة - 1';

        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            backgroundColor: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig().wp(2.7)), // 10px
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: SizeConfig().wp(75), // 75% of screen width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'إضافة جلسة تلاوة جديدة',
                        style: TextStyle(
                          fontSize: SizeConfig().sp(20), // 20px
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig().hp(1)), // 16px
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
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: SizeConfig().wp(33), // 33% of screen width
                          child: textField(
                            hintText: 'من آية',
                            title: 'من آية',
                            controller: fromAyahController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig().wp(33), // 33% of screen width
                          child: textField(
                            hintText: 'إلى آية',
                            title: 'إلى آية',
                            controller: toAyahController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حالة الجلسة',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig().sp(14), // 14px
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig().wp(3.2),
                          ), // 12px
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              SizeConfig().wp(3.2),
                            ), // 12px
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: SizeConfig().wp(3.2), // 12px
                                vertical: SizeConfig().hp(1), // 16px
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  SizeConfig().wp(3.2),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(
                              SizeConfig().wp(3.2),
                            ),
                            elevation: 4,
                            menuMaxHeight: 200,
                            alignment: AlignmentDirectional.bottomStart,
                            items: ['ممتاز', 'جيد', 'يحتاج تحسين']
                                .map(
                                  (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
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
                    SizedBox(height: SizeConfig().hp(1)), // 16px
                    textField(
                      hintText: 'ملاحظات إضافية (اختياري)',
                      height:
                          150, // This is a fixed height, might need adjustment
                      isHintCentered: false,
                      title: 'ملاحظات',
                      controller: noteController,
                    ),
                    SizedBox(height: SizeConfig().hp(1.5)), // 24px
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
                                ScaffoldMessenger.of(
                                  dialogContext,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text('البيانات المدخلة غير صحيحة'),
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
                                    fromAyah: int.parse(
                                      fromAyahController.text,
                                    ),
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
                                borderRadius: BorderRadius.circular(
                                  SizeConfig().wp(2.1),
                                ), // 8px
                              ),
                            ),
                            child: const Text('إضافة'),
                          ),
                        ),
                        SizedBox(width: SizeConfig().wp(4.3)), // 16px
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
                                ), // 8px
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
      },
    );
  }
}
