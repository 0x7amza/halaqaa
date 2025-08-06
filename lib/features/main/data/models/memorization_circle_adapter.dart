import 'package:halaqaa/features/main/domain/entities/memorization_circle.dart';
import 'package:hive/hive.dart';

class MemorizationCircleAdapter extends TypeAdapter<MemorizationCircle> {
  @override
  final int typeId = 0;

  @override
  MemorizationCircle read(BinaryReader reader) {
    return MemorizationCircle(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      studentsCount: reader.readInt(),
      activeStudentsCount: reader.readInt(),
      createdAt: reader.read() as DateTime,
      updatedAt: reader.read() as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MemorizationCircle obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeInt(obj.studentsCount);
    writer.writeInt(obj.activeStudentsCount);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
  }
}
