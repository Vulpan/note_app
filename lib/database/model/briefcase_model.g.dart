// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'briefcase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BriefcaseAdapter extends TypeAdapter<Briefcase> {
  @override
  final int typeId = 1;

  @override
  Briefcase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Briefcase(
      id: fields[0] as int,
      title: fields[1] as String,
      notes: (fields[2] as List).cast<Note>(),
      creationDate: fields[3] as DateTime,
      lastEditionDate: fields[4] as DateTime,
      color: fields[5] as Color,
      secondColor: fields[6] as Color,
      textColor: fields[7] as Color,
      iconColor: fields[8] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Briefcase obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.creationDate)
      ..writeByte(4)
      ..write(obj.lastEditionDate)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.secondColor)
      ..writeByte(7)
      ..write(obj.textColor)
      ..writeByte(8)
      ..write(obj.iconColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BriefcaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
