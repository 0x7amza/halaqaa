import 'package:halaqaa/features/student/domain/entities/session.dart';
import 'package:hive/hive.dart';

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 2;

  @override
  Session read(BinaryReader reader) {
    return Session(
      id: reader.read() as String,
      studentId: reader.read() as String,
      date: reader.read() as DateTime,
      surahNumber: reader.read() as String,
      fromAyah: reader.read() as int,
      toAyah: reader.read() as int,
      status: reader.read() as String,
      notes: reader.read() as String,
      stars: reader.read() as int,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer.write(obj.id);
    writer.write(obj.studentId);
    writer.write(obj.date);
    writer.write(obj.surahNumber);
    writer.write(obj.fromAyah);
    writer.write(obj.toAyah);
    writer.write(obj.status);
    writer.write(obj.notes);
    writer.write(obj.stars);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
