// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VersionModelAdapter extends TypeAdapter<VersionModel> {
  @override
  final int typeId = 1;

  @override
  VersionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VersionModel(
      id: fields[0] as String,
      fileId: fields[1] as String,
      versionNumber: fields[2] as int,
      description: fields[3] as String,
      createdAt: fields[4] as DateTime,
      createdBy: fields[5] as String,
      isConflict: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VersionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileId)
      ..writeByte(2)
      ..write(obj.versionNumber)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.isConflict);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VersionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
