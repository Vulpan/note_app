import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColorAdapter extends TypeAdapter {
  @override
  final typeId = 100;

  @override
  Color read(BinaryReader reader) => Color(reader.readUint32());

  @override
  void write(BinaryWriter writer, obj) => writer.writeUint32(obj.value);
}
