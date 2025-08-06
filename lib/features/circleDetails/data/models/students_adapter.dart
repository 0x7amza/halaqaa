import 'package:halaqaa/features/circleDetails/domain/entities/student.dart';
import 'package:hive/hive.dart';

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 1;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      circleId: fields[3] as String,
      completedParts: fields[4] as int,
      currentPart: fields[5] as int,
      stars: fields[6] as int,
      status: fields[7] as String,
      joinDate: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.circleId)
      ..writeByte(4)
      ..write(obj.completedParts)
      ..writeByte(5)
      ..write(obj.currentPart)
      ..writeByte(6)
      ..write(obj.stars)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.joinDate)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
