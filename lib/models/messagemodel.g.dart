// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messagemodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class messagemodelAdapter extends TypeAdapter<messagemodel> {
  @override
  final int typeId = 1;

  @override
  messagemodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return messagemodel(
      uid: fields[0] as String?,
      text: fields[1] as String?,
      date: fields[2] as String?,
      isseen: fields[4] as bool?,
      issend: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, messagemodel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.issend)
      ..writeByte(4)
      ..write(obj.isseen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is messagemodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
