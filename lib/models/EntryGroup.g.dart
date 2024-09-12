// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EntryGroup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryGroupAdapter extends TypeAdapter<EntryGroup> {
  @override
  final int typeId = 3;

  @override
  EntryGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntryGroup(
      name: fields[0] == null ? '0001' : fields[0] as String,
      entries: fields[1] == null ? [] : (fields[1] as List).cast<DailyEntry>(),
    )..id = fields[2] == null ? -1 : fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, EntryGroup obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.entries)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
