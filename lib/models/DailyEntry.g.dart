// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailyEntry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 0;

  @override
  DailyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyEntry(
      notes: fields[0] as String?,
      epochDate: fields[1] as int,
      current: fields[2] as int,
      points: fields[3] as int,
      pallor: fields[4] as int,
      tags: (fields[5] as List?)?.cast<DailyEntryTag>(),
      secured: fields[6] as bool?,
      entryGroupId: fields[7] == null ? 'EG-0001' : fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.notes)
      ..writeByte(1)
      ..write(obj.epochDate)
      ..writeByte(2)
      ..write(obj.current)
      ..writeByte(3)
      ..write(obj.points)
      ..writeByte(4)
      ..write(obj.pallor)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.secured)
      ..writeByte(7)
      ..write(obj.entryGroupId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
