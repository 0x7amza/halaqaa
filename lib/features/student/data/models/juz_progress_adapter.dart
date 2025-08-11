import 'package:halaqaa/features/student/domain/entities/juz_progress.dart';
import 'package:hive/hive.dart';

class JuzProgressAdapter extends TypeAdapter<JuzProgress> {
  @override
  final int typeId = 3;

  @override
  JuzProgress read(BinaryReader reader) {
    return JuzProgress(
      studentId: reader.read() as String,
      juzNumber: reader.read() as String,
      totalAyahs: reader.read() as int,
      memorizedAyahs: reader.read() as int,
      lastUpdated: reader.read() as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JuzProgress obj) {
    writer.write(obj.studentId);
    writer.write(obj.juzNumber);
    writer.write(obj.totalAyahs);
    writer.write(obj.memorizedAyahs);
    writer.write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JuzProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
