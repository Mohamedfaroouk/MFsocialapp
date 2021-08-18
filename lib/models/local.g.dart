// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class localmodelAdapter extends TypeAdapter<localmodel> {
  @override
  final int typeId = 2;

  @override
  localmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return localmodel(
      thelist: (fields[0] as List?)?.cast<messagemodel>(),
    );
  }

  @override
  void write(BinaryWriter writer, localmodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.thelist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is localmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
